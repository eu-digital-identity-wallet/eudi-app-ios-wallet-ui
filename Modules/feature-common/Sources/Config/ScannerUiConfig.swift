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
import logic_ui
import logic_resources

public struct ScannerUiConfig: UIConfigType, Equatable {

  public let flow: Flow

  public var log: String {
    return "flow: \(flow.rawValue)"
  }

  public init(flow: Flow) {
    self.flow = flow
  }
}

public extension ScannerUiConfig {
  enum Flow: Equatable, Sendable {

    case presentation
    case issuing(IssuanceFlowUiConfig)

    var title: LocalizableStringKey {
      return switch self {
      case .presentation:
          .scannerQrTitlePresentation
      case .issuing:
          .scannerQrTitleIssuing
      }
    }

    var caption: LocalizableStringKey {
      return switch self {
      case .presentation:
          .scannerQrCaptionPresentation
      case .issuing:
          .scannerQrCaptionIssuing
      }
    }

    var informativeText: LocalizableStringKey {
      return .qrScanInformativeText
    }

    var rawValue: String {
      return switch self {
      case .presentation:
        "presentation"
      case .issuing:
        "issuing"
      }
    }
  }
}
