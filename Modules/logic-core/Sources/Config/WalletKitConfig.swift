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

struct VciConfig {
  public let issuerUrl: String
  public let clientId: String
  public let redirectUri: String
}

struct VerifierConfig {
  public let apiUri: String
  public let legalName: String
}

struct ProximityConfig {
  public let trustedCerts: [Data]
}

protocol WalletKitConfig {

  /**
   * Verifier API URI.
   */
  var verifierConfig: VerifierConfig { get }

  /**
   * VCI Configuration
   */
  var vciConfig: VciConfig { get }

  /**
   * Proximity Configuration
   */
  var proximityConfig: ProximityConfig { get }

  /**
   * User authentication required accessing core's secure storage
   */
  var userAuthenticationRequired: Bool { get }
}

struct WalletKitConfigImpl: WalletKitConfig {

  var userAuthenticationRequired: Bool {
    getBundleValue(key: "Core User Auth").toBool()
  }

  var verifierConfig: VerifierConfig {
    .init(
      apiUri: getBundleValue(key: "Verifier API"),
      legalName: getBundleValue(key: "Verifier Legal Name")
    )
  }

  var vciConfig: VciConfig {
    .init(
      issuerUrl: getBundleValue(key: "Vci Issuer URL"),
      clientId: getBundleValue(key: "Vci Client Id"),
      redirectUri: getBundleValue(key: "Vci Redirect Uri")
    )
  }

  var proximityConfig: ProximityConfig {
    guard let cert = Data(name: "eudi_pid_issuer_ut", ext: "der") else {
      return .init(trustedCerts: [])
    }
    return .init(trustedCerts: [cert])
  }
}
