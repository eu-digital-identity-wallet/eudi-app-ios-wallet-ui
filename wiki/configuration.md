# How to configure the application

## General configuration

The application allows the configuration of:

1. Verifier API
2. Issuing API

Via the *WalletDemo* and *WalletDemoRelease* xcconfigs inside the Wallet/Config folder.

```
VERIFIER_API_URI = https:/$()/verifier.eudiw.dev
VCI_ISSUER_URL = https:/$()/issuer.eudiw.dev/oidc
VCI_CLIENT_ID = wallet-demo
VCI_REDIRECT_URI = eudi-openid4ci:/$()/authorize/
CORE_USER_AUTH = false
```

3. Trusted certificates

Via the *WalletKitConfig* protocol inside the logic-core module.

```
public protocol WalletKitConfig {
  /**
   * Proximity Configuration
   */
  var proximityConfig: ProximityConfig { get }
}
```

```
public struct ProximityConfig {
  public let trustedCerts: [Data]
}
```

The *WalletKitConfigImpl* implementation of the *WalletKitConfig* protocol can be located inside the logic-core module.

The application's certificates are located here:

https://github.com/niscy-eudiw/eudi-app-ios-wallet-ui/tree/main/Wallet/Sample

You will also find the IACA certificate here. (trusted iaca root certificates).

## Theme configuration

The application allows the configuration of:

1. Colors
2. Images
3. Shape
4. Fonts
5. Dimension

Via the *ThemeConfiguration* struct.

## Pin Storage configuration

The application allows the configuration of the PIN storage. You can configure the following:

1. Where the pin will be stored
2. From where the pin will be retrieved
3. Pin matching and validity

Via the *LogicAuthAssembly* inside the logic-authentication module.

```
public final class LogicAuthAssembly: Assembly {

  public init() {}

  public func assemble(container: Container) {
  }
}
```

You can provide your storage implementation by implementing the *PinStorageProvider* protocol and then providing the implementation inside the Assembly DI Graph *LogicAuthAssembly*

Implementation Example:
```
final class KeychainPinStorageProvider: PinStorageProvider {

  private let keyChainController: KeyChainController

  init(keyChainController: KeyChainController) {
    self.keyChainController = keyChainController
  }

  func retrievePin() -> String? {
    keyChainController.getValue(key: KeychainIdentifier.devicePin)
  }

  func setPin(with pin: String) {
    keyChainController.storeValue(key: KeychainIdentifier.devicePin, value: pin)
  }

  func isPinValid(with pin: String) -> Bool {
    keyChainController.getValue(key: KeychainIdentifier.devicePin) == pin
  }
}
```

Config Example:
```
container.register(PinStorageProvider.self) { r in
  KeychainPinStorageProvider(keyChainController: r.force(KeyChainController.self))
}
.inObjectScope(ObjectScope.graph)
```
