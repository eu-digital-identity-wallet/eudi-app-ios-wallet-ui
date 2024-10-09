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

public protocol AnalyticsController: Sendable {
  func initialize()
  func logScreen(screen: String, arguments: [String: String])
  func logEvent(event: String, arguments: [String: String])
}

final class AnalyticsControllerImpl: AnalyticsController {

  private let analyticsConfig: AnalyticsConfig?

  init(analyticsConfig: AnalyticsConfig?) {
    self.analyticsConfig = analyticsConfig
  }

  public func initialize() {
    analyticsConfig?.analyticsProviders.forEach { (key, provider) in
      provider.initialize(key: key)
    }
  }

  public func logScreen(screen: String, arguments: [String: String]) {
    analyticsConfig?.analyticsProviders.forEach { (_, provider) in
      provider.logScreen(screen: screen, arguments: arguments)
    }
  }

  public func logEvent(event: String, arguments: [String: String]) {
    analyticsConfig?.analyticsProviders.forEach { (_, provider) in
      provider.logEvent(event: event, arguments: arguments)
    }
  }
}
