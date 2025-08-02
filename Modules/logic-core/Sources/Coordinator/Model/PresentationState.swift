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

public enum PresentationState: Sendable {
  case loading
  case prepareQr
  case qrReady(imageData: Data)
  case requestReceived(PresentationRequest)
  case responseToSend(RequestItemConvertible)
  case responseSent(URL?)
  case error(Error)
}

extension PresentationState: Equatable {
  public static func == (lhs: PresentationState, rhs: PresentationState) -> Bool {
    return switch (lhs, rhs) {
    case (.loading, .loading), (.prepareQr, .prepareQr):
      true
    case let (.qrReady(a), .qrReady(b)):
      a == b
    case let (.requestReceived(a), .requestReceived(b)):
      a == b
    case let (.responseToSend(a), .responseToSend(b)):
      a.items == b.items
    case let (.responseSent(a), .responseSent(b)):
      a == b
    case let (.error(a), .error(b)):
      a.localizedDescription == b.localizedDescription
    default:
      false
    }
  }
}
