/*
 * Copyright (c) 2025 European Commission
 *
 * Licensed under the EUPL, Version 1.2 or - as soon they will be approved by the European
 * Commission - subsequent versions of the EUPL (the "Licence"); You may not use this work
 * except in compliance with the Licence.
 *
 * You may obtain a copy of the Licence at:
 * https://joinup.ec.europa.eu/software/page/eupl
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the Licence is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the Licence for the specific language
 * governing permissions and limitations under the Licence.
 */
import Foundation
import logic_business

protocol NetworkManager: Sendable {

  func execute<R: NetworkRequest, T: Decodable & Sendable>(
    with request: R,
    parameters: [NetworkParameter]?
  ) async throws -> T

  func prepare<R: NetworkRequest>(
    request: R,
    parameters: [NetworkParameter]?,
    baseHost: String
  ) async -> URLRequest
  func log(request: URLRequest, responseData: Data?)
}

actor NetworkManagerImpl: NetworkManager {

  private let session: URLSession

  init(with sessionProvider: NetworkSessionProvider) {
    self.session = sessionProvider.urlSession
  }

  func execute<R: NetworkRequest, T: Decodable & Sendable>(
    with request: R,
    parameters: [NetworkParameter]?
  ) async throws -> T {

    let urlRequest = await self.prepare(
      request: request,
      parameters: parameters,
      baseHost: request.host
    )

    let (data, response) = try await session.data(for: urlRequest)

    self.log(
      request: urlRequest,
      responseData: data
    )

    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.invalidResponse
    }

    guard (200...299).contains(httpResponse.statusCode) else {
      throw NetworkError.httpStatus(code: httpResponse.statusCode, data: data)
    }

    do {
      let decoder = JSONDecoder()
      return try decoder.decode(T.self, from: data)
    } catch {
      throw NetworkError.decoding(error)
    }
  }

  func prepare<R: NetworkRequest>(
    request: R,
    parameters: [NetworkParameter]?,
    baseHost: String
  ) async -> URLRequest {

    guard let baseAPI = baseHost.toCompatibleUrl() else {
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

  nonisolated func log(request: URLRequest, responseData: Data? = nil) {
    print("1️⃣ Request: " + (request.url?.absoluteString ?? "") )
    print("2️⃣ Request Http Method: " + (request.httpMethod ?? "") )
    print("3️⃣ Request HttpBody: " + ((try? request.httpBody?.toJSONString(prettyPrinted: true)).orEmpty) )
    print("4️⃣ Request Headers: ")
    request.allHTTPHeaderFields?.forEach({ key, value in
      print("\(key): \(value)")
    })

    if let responseData {
      print("✅ Response Body: " + ((try? responseData.toJSONString(prettyPrinted: true)).orEmpty) )
    }
  }
}
