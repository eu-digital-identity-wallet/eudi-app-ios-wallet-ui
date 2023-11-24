/*
 * Copyright (c) 2023 European Commission
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

public enum DashboardPartialState {
  case success(BearerUIModel, [DocumentUIModel])
  case failure(Error)
}

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
  func fetchDashboard() async -> DashboardPartialState
}

public final actor DashboardInteractor: DashboardInteractorType {

  public init() {}

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
      try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
      return .success(DocumentUIModel.mocks())
    } catch {
      return .failure(error)
    }
  }

  public func fetchDashboard() async -> DashboardPartialState {
    var bearer: BearerUIModel?
    let bearerState = await fetchBearer()
    switch bearerState {
    case .success(let value):
      bearer = value
    default: break
    }

    var document: [DocumentUIModel]?
    let documentsSate = await fetchDocuments()
    switch documentsSate {
    case .success(let value):
      document = value
    default: break
    }

    guard let bearer = bearer else {
      return .failure(RuntimeError.customError("Unable to fetch bearer info"))
    }

    guard let document = document else {
      return .failure(RuntimeError.customError("Unable to fetch documents"))
    }

    return .success(bearer, document)
  }
}
