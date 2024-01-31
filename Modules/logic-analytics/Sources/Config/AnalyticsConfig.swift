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
protocol AnalyticsConfigType {
  /**
   * Supported Analytics Provider, e.g. Firebase
   */
  var analyticsProviders: [String: AnalyticsProviderType] { get }
}

struct AnalyticsConfig: AnalyticsConfigType {
  var analyticsProviders: [String: AnalyticsProviderType] {
    return ["c076a68c-6b3a-458c-9fed-daa7f323df6d": AppCenterProvider()]
  }
}

import AppCenter
import AppCenterCrashes
import AppCenterAnalytics
import AppCenterDistribute

struct AppCenterProvider: AnalyticsProviderType {

  func initialize(key: String) {
    Distribute.updateTrack = .private
    AppCenter.start(
      withAppSecret: key,
      services: [
        Crashes.self,
        Analytics.self,
        Distribute.self
      ]
    )
  }

  func logScreen(screen: String, arguments: [String: String]) {
    if Analytics.enabled {
      logEvent(event: screen, arguments: arguments)
    }
  }

  func logEvent(event: String, arguments: [String: String]) {
    Analytics.trackEvent(event, withProperties: arguments)
  }
}
