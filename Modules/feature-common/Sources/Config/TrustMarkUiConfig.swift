/*
 * Copyright (c) 2026 European Commission
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
import logic_ui

public struct TrustMarkUiConfig: UIConfigType, Equatable {

  public enum Mode: Equatable, Sendable {
    case welcome(continuationRoute: AppRoute)
    case about
  }

  public let mode: Mode

  public var log: String {
    return switch mode {
    case .welcome(let continuationRoute):
      "mode: welcome, continuationRoute: \(continuationRoute.info.key)"
    case .about:
      "mode: about"
    }
  }

  public var isWelcome: Bool {
    if case .welcome = mode { return true }
    return false
  }

  public init(mode: Mode) {
    self.mode = mode
  }
}
