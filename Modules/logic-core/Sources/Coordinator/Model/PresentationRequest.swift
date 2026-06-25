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

public struct PresentationRequest: Sendable, Equatable {
  /// One entry per selectable credential combination produced by DCQL resolution.
  /// Proximity (BLE) always yields a single combination; OpenID4VP DCQL may yield several.
  public let itemSets: [[DocElements]]
  public let relyingParty: String
  public let dataRequestInfo: String
  public let isTrusted: Bool
}
