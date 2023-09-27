/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Foundation
import Alamofire
import logic_business

public actor NetworkManager: GlobalActor {

  public static let shared = NetworkManager()

  private let configLogic: ConfigLogic

  private init(configLogic: ConfigLogic = ConfigProvider.shared.getConfigLogic()) {
    self.configLogic = configLogic
  }

  func execute<R: NetworkRequest, T: Decodable>(with request: R, parameters: [NetworkParameter]? = nil) async throws -> T {

    let request = self.prepare(
      request: request,
      parameters: parameters,
      baseHost: self.configLogic.baseHost
    )

    return try await withCheckedThrowingContinuation { continuation in
      AF.request(request)
        .responseDecodable(of: T.self) { response in

          self.log(
            request: request,
            responseData: response.data
          )

          switch response.result {
          case let .success(data):
            continuation.resume(returning: data)
          case let .failure(error):
            continuation.resume(throwing: error)
          }
        }
    }
  }
}

private extension NetworkManager {
  func prepare<R: NetworkRequest>(
    request: R,
    parameters: [NetworkParameter]?,
    baseHost: String
  ) -> URLRequest {

    guard let baseAPI = URL(string: baseHost) else {
      fatalError("No base url provided")
    }

    let endpoint = baseAPI.appendingPathComponent(request.path)

    var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: false)

    if let parameters = parameters {
      components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }

    guard let url = components?.url else {
      fatalError("No base url components provided")
    }

    var urlRequest = URLRequest(url: url)

    urlRequest.httpMethod = request.method.rawValue
    urlRequest.httpBody = request.body
    urlRequest.addValue(
      "application/json",
      forHTTPHeaderField: "Content-Type"
    )

    return urlRequest
  }
}

private extension NetworkManager {

  func log(request: URLRequest, responseData: Data? = nil) {
    print("1️⃣ Request: " + (request.url?.absoluteString ?? "") )
    print("2️⃣ Request Http Method: " + (request.httpMethod ?? "") )
    print("3️⃣ Request HttpBody: " + (request.httpBody?.prettyJson ?? "") )
    print("4️⃣ Request Headers: ")
    request.allHTTPHeaderFields?.forEach({ key, value in
      print("\(key): \(value)")
    })

    if let responseData {
      print("✅ Response Body: " + (responseData.prettyJson ?? "") )
    }
  }
}
