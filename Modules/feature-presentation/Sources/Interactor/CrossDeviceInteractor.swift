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
import logic_api
import logic_business
import feature_common

public enum CrossDevicePartialState {
  case success
  case failure(Error)
}

public enum CrossDevicePartialStateState {
  case success([RequestDataCell], relyingParty: String, dataRequestInfo: String, isTrusted: Bool)
  case failure(Error)
}

public protocol CrossDeviceInteractorType {
  var presentationCoordinator: PresentationSessionCoordinatorType { get }
  func doWork() async -> CrossDevicePartialState
}

public final actor CrossDeviceInteractor: CrossDeviceInteractorType {

  public let presentationCoordinator: PresentationSessionCoordinatorType
  private lazy var walletKitController: WalletKitControllerType = WalletKitController.shared

  public init(with presentationCoordinator: PresentationSessionCoordinatorType) {
    self.presentationCoordinator = presentationCoordinator
  }

  public func onRequestReceived() async -> CrossDevicePartialStateState {
    do {
      let response = try await presentationSessionCoordinator.requestReceived()
      return .success(
        RequestDataUiModel.items(
          for: response.items
        ),
        relyingParty: getVerifierName(response: response),
        dataRequestInfo: response.dataRequestInfo,
        isTrusted: response.isTrusted
      )
    } catch {
      return .failure(error)
    }
  }

  public func doWork() async -> CrossDevicePartialState {
    do {
      try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
      return .success
    } catch {
      return .failure(error)
    }
  }
}
