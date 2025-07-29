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
import SwiftUI
import logic_resources

public struct DocumentCredentialsInfoUi: Sendable {
  public let availableCredentials: Int
  public let totalCredentials: Int
  public let title: LocalizableStringKey
  public let collapsedInfo: CollapsedInfo?
  public let expandedInfo: ExpandedInfo?
  public let isExpanded: Bool

  public init(
    availableCredentials: Int,
    totalCredentials: Int,
    title: LocalizableStringKey,
    collapsedInfo: CollapsedInfo? = nil,
    expandedInfo: ExpandedInfo? = nil,
    isExpanded: Bool = false
  ) {
    self.availableCredentials = availableCredentials
    self.totalCredentials = totalCredentials
    self.title = title
    self.collapsedInfo = collapsedInfo
    self.expandedInfo = expandedInfo
    self.isExpanded = isExpanded
  }
}

public struct CollapsedInfo: Sendable {
  public let moreInfoText: LocalizableStringKey

  public init(moreInfoText: LocalizableStringKey) {
    self.moreInfoText = moreInfoText
  }
}

public struct ExpandedInfo: Sendable {
  public let subtitle: LocalizableStringKey
  public let updateNowButtonText: LocalizableStringKey?
  public let hideButtonText: LocalizableStringKey

  public init(
    subtitle: LocalizableStringKey,
    updateNowButtonText: LocalizableStringKey? = nil,
    hideButtonText: LocalizableStringKey
  ) {
    self.subtitle = subtitle
    self.updateNowButtonText = updateNowButtonText
    self.hideButtonText = hideButtonText
  }
}
