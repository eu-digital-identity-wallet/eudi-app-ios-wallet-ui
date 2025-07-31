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
import UIKit
import OpenID4VCI

@MainActor
class IssuerManager {
  static let shared = IssuerManager()

  private let userDefaults = UserDefaults.standard
  private let issuersKey = "storedIssuers"
  private let selectedIssuerKey = "selectedIssuer"
  private let selectedIssuerUrlKey = "selectedIssuerUrl"

  private let defaultIssuers: [IssuerInfo] = [
    IssuerInfo(
      name: "EUDI Issuer",
      url: "https://issuer.eudiw.dev"
    ),
    IssuerInfo(
      name: "RDW Issuer",
      url: "https://mdlissuer.azurewebsites.net"
    )
  ]

  var defaultIssuerName: String {
    return defaultIssuers.first?.name ?? ""
  }

  private init() {
    if getIssuers().isEmpty {
      for _ in defaultIssuers {
        addIssuer(defaultIssuers.first?.name ?? "", url: defaultIssuers.first?.url ?? "")
      }
    }
  }

  func getIssuers() -> [IssuerInfo] {
    var issuers: [IssuerInfo]
    if let data = userDefaults.data(forKey: issuersKey),
       let storedIssuers = try? JSONDecoder().decode([IssuerInfo].self, from: data) {
      issuers = storedIssuers
    } else {
      issuers = []
    }

    if !issuers.contains(defaultIssuers) {
      issuers.insert(contentsOf: defaultIssuers, at: 0)
    }
    return issuers
  }

  func getSelectedIssuer() -> String? {
    return userDefaults.string(forKey: selectedIssuerKey)
  }

  private func getFirstIssuer(storedName: String?, storedUrl: String?, newIssuer: IssuerInfo, defaultIssuer: IssuerInfo) -> Bool {
    let isFreshInstall = storedName == nil && storedUrl == nil
    let isDefaultSelection = newIssuer.name == defaultIssuer.name && newIssuer.url == defaultIssuer.url
    return isFreshInstall && isDefaultSelection
  }

  func setSelectedIssuer(_ name: String) {
    guard let newIssuer = getIssuers().first(where: { $0.name == name }) else { return }

    let defaultIssuer = defaultIssuers[0]

    let storedName = userDefaults.string(forKey: selectedIssuerKey)
    let storedUrl = userDefaults.string(forKey: selectedIssuerUrlKey)

    let currentName = storedName ?? defaultIssuer.name
    let currentUrl = storedUrl ?? defaultIssuer.url

    guard currentName != newIssuer.name || currentUrl != newIssuer.url else { return }

    userDefaults.set(newIssuer.name, forKey: selectedIssuerKey)
    userDefaults.set(newIssuer.url, forKey: selectedIssuerUrlKey)

    if !getFirstIssuer(storedName: storedName, storedUrl: storedUrl, newIssuer: newIssuer, defaultIssuer: defaultIssuer) {
      showIssuerChangedAlert()
    }
  }

  func addIssuer(_ name: String, url: String) {
    var issuers = getIssuers()
    let newIssuer = IssuerInfo(name: name, url: url)

    if !issuers.contains(newIssuer) {
      issuers.append(newIssuer)
      if let encoded = try? JSONEncoder().encode(issuers) {
        userDefaults.set(encoded, forKey: issuersKey)
      }
    }
  }

  func removeIssuer(_ name: String) {
    var issuers = getIssuers()
    issuers.removeAll { $0.name == name }
    if let encoded = try? JSONEncoder().encode(issuers) {
      userDefaults.set(encoded, forKey: issuersKey)
    }
    if getSelectedIssuer() == name {
      setSelectedIssuer(defaultIssuers.first?.name ?? "")
    }
  }

  private func showIssuerChangedAlert() {
    let alert = UIAlertController(
      title: "Issuer Changed",
      message: "The app needs to restart to apply the new issuer configuration. The app will close now, please reopen it.",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
      exit(0)
    })

    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let rootVC = windowScene.windows.first?.rootViewController {
      rootVC.present(alert, animated: true)
    }
  }
}
