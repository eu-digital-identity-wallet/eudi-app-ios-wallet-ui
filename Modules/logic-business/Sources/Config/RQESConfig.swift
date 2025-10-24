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
import EudiRQESUi

final class RQESConfig: EudiRQESUiConfig {

  let buildVariant: AppBuildVariant
  let buildType: AppBuildType

  init(buildVariant: AppBuildVariant, buildType: AppBuildType) {
    self.buildVariant = buildVariant
    self.buildType = buildType
  }

  var rssps: [QTSPData] {
    return switch buildVariant {
    case .DEV:
      [
        .init(
          name: "Wallet-Centric",
          rsspId: "https://walletcentric.signer.dev.eudiw.dev/csc/v2",
          tsaUrl: "https://timestamp.sectigo.com/qualified",
          clientId: "wallet-client",
          clientSecret: "somesecret2",
          authFlowRedirectionURI: "rqes://oauth/callback",
          hashAlgorithm: .SHA256,
          includeRevocationInfo: false
        )
      ]
    case .DEMO:
      [
        .init(
          name: "Wallet-Centric",
          rsspId: "https://walletcentric.signer.eudiw.dev/csc/v2",
          tsaUrl: "https://timestamp.sectigo.com/qualified",
          clientId: "wallet-client",
          clientSecret: "somesecret2",
          authFlowRedirectionURI: "rqes://oauth/callback",
          hashAlgorithm: .SHA256,
          includeRevocationInfo: false
        )
      ]
    }
  }

  var printLogs: Bool {
    buildType == .DEBUG
  }
}
