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

public enum DashboardDocumentsPartialState {
  case success([DocumentUIModel])
  case failure(Error)
}

public enum DashboardBearerPartialState {
  case success(BearerUIModel)
  case failure(Error)
}

public protocol DashboardInteractorType {
  func fetchDocuments() async -> DashboardDocumentsPartialState
  func fetchBearer() async -> DashboardBearerPartialState
}

public final actor DashboardInteractor: DashboardInteractorType {
  public func fetchBearer() async -> DashboardBearerPartialState {
    do {
      try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
      return .success(BearerUIModel.mock())
    } catch {
      return .failure(error)
    }
  }

  public func fetchDocuments() async -> DashboardDocumentsPartialState {
    do {
      try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
      return .success(DocumentUIModel.mocks())
    } catch {
      return .failure(error)
    }
  }

  public init() {}
}
