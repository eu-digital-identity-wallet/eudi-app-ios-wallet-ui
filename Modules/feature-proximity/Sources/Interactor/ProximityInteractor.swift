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
import logic_api
import logic_business
import CoreImage.CIFilterBuiltins
import UIKit
import EudiWalletKit

public enum ProximityPartialState {
  case success
  case failure(Error)
}

public enum ProximityInitialisationPartialState {
  case success
  case failure(Error)
}

public enum ProximityQrCodePartialState {
  case success(UIImage)
  case failure(Error)
}

public protocol ProximityInteractorType {
  var presentationSession: PresentationSession { get }
  func doWork() async -> ProximityPartialState

  func startDeviceEngagement() async -> ProximityInitialisationPartialState
  func generateQRCode() async -> ProximityQrCodePartialState
}

public final actor ProximityInteractor: ProximityInteractorType {

  public let presentationSession: PresentationSession

  public init() {
    guard WalletKitController.shared.activeSession.status != .initializing else {
      presentationSession = WalletKitController.shared.startPresentation(flow: .ble)
      return
    }
    presentationSession = WalletKitController.shared.activeSession
  }

  public func startDeviceEngagement() async -> ProximityInitialisationPartialState {
    do {
      try await presentationSession.startQrEngagement()
      try await presentationSession.receiveRequest()
      return .success
    } catch {
      return .failure(error)
    }
  }

  public func generateQRCode() async -> ProximityQrCodePartialState {

    guard let data = presentationSession.deviceEngagement else {
      return .failure(RuntimeError.genericError)
    }

    guard let qrImage = UIImage(data: data) else {
      return .failure(RuntimeError.genericError)
    }

    return .success(qrImage)
  }

  public func doWork() async -> ProximityPartialState {
    do {
      try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
      return .success
    } catch {
      return .failure(error)
    }
  }

  deinit {
    WalletKitController.shared.stopPresentation()
  }
}
