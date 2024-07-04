# How to configure the application

## Table of contents

* [General configuration](#general-configuration)
* [DeepLink Schemas configuration](#deeplink-schemas-configuration)
* [Scoped Issuance Document Configuration](#scoped-issuance-document-configuration)
* [How to work with self-signed certificates](#how-to-work-with-self-signed-certificates)
* [Theme configuration](#theme-configuration)
* [Pin Storage configuration](#pin-storage-configuration)
* [Analytics configuration](#analytics-configuration)

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
   * Reader Configuration
   */
  var readerConfig: ReaderConfig { get }
}
```

```
public struct ReaderConfig {
  public let trustedCerts: [Data]
}
```

The *WalletKitConfigImpl* implementation of the *WalletKitConfig* protocol can be located inside the logic-core module.

The application's IACA certificates are located [here](https://github.com/eu-digital-identity-wallet/eudi-app-ios-wallet-ui/tree/main/Wallet/Sample):

```
  var readerConfigConfig: ReaderConfig {
    guard let cert = Data(name: "eudi_pid_issuer_ut", ext: "der") else {
      return .init(trustedCerts: [])
    }
    return .init(trustedCerts: [cert])
  }
```

## DeepLink Schemas configuration

According to the specifications issuance and presentation require deep-linking for the same device flows.

If you want to change or add your own you can do it by adjusting the *Wallet.plist* file.

```
<array>
	<dict>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>CFBundleURLName</key>
		<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>eudi-openid4vp</string>
			<string>mdoc-openid4vp</string>
			<string>openid4vp</string>
			<string>openid-credential-offer</string>
		</array>
	</dict>
</array>
```

Let's assume you want to add a new one for the credential offer (e.g. custom-my-offer://) the *Wallet.plist* should look like this:

```
<array>
	<dict>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>CFBundleURLName</key>
		<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>eudi-openid4vp</string>
			<string>mdoc-openid4vp</string>
			<string>openid4vp</string>
			<string>openid-credential-offer</string>
			<string>custom-my-offer</string>
		</array>
	</dict>
</array>
```

After the *Wallet.plist* adjustment, you must also adjust the *DeepLinkController* inside the logic-ui module.

Current Implementation:

```
public extension DeepLink {
  enum Action: String, Equatable {

    case openid4vp
    case credential_offer
    case external

    static func parseType(
      with scheme: String,
      and urlSchemaController: UrlSchemaController
    ) -> Action? {
      switch scheme {
      case _ where openid4vp.getSchemas(with: urlSchemaController).contains(scheme):
        return .openid4vp
      case _ where credential_offer.getSchemas(with: urlSchemaController).contains(scheme):
        return .credential_offer
      default:
        return .external
      }
    }
  }
}
```

Adjusted with the new schema:

```
public extension DeepLink {
  enum Action: String, Equatable {

    case openid4vp
    case credential_offer
    case custom_my_offer
    case external

    static func parseType(
      with scheme: String,
      and urlSchemaController: UrlSchemaController
    ) -> Action? {
      switch scheme {
      case _ where openid4vp.getSchemas(with: urlSchemaController).contains(scheme):
        return .openid4vp
      case _ where credential_offer.getSchemas(with: urlSchemaController).contains(scheme):
        return .credential_offer
      case _ where custom_my_offer.getSchemas(with: urlSchemaController).contains(scheme):
        return .credential_offer
      default:
        return .external
      }
    }
  }
}
```

## Scoped Issuance Document Configuration

Currently, the application supports specific docTypes for scoped issuance (On the Add Document screen the pre-configured buttons like *National ID*, *Driving License*, and *Age verification*).

The supported list and user interface are not configurable because, with the credential offer, you can issue any format-supported document.

To extend the supported list and display a new button for your document, please follow the instructions below.

In *LocalizableString.swift* and *Localizable.xcstrings*, inside logic-resources module, add a new string for document title localization

*Localizable.xcstrings* Example:

```
"age_verification" : {
   "extractionState" : "manual",
   "localizations" : {
     "en" : {
	"stringUnit" : {
	"state" : "translated",
	"value" : "Age Verification"
	}
     }
   }
},
"your_own_document_title" : {
   "extractionState" : "manual",
   "localizations" : {
     "en" : {
	"stringUnit" : {
	"state" : "translated",
	"value" : "Your Document Title"
	}
     }
   }
},
```

*LocalizableString.swift* Example:

```
public extension LocalizableString {
  enum Key: Equatable {
   case yourOwn
  }
}

public func get(with key: Key) -> String {
  return switch key {
    case .ageVerification:
      bundle.localizedString(forKey: "your_own_document_title")
  }
}
```

In *DocumentIdentifier*, inside the logic-core module, you must add a new case to the enum with your doctype.

Example:

```
public enum DocumentTypeIdentifier: RawRepresentable, Equatable {

  case PID
  case MDL
  case AGE
  case YOUR_OWN
  case GENERIC(docType: String)

  public var localizedTitle: String {
    return switch self {
    case .PID:
      LocalizableString.shared.get(with: .pid)
    case .MDL:
      LocalizableString.shared.get(with: .mdl)
    case .AGE:
      LocalizableString.shared.get(with: .ageVerification)
    case .YOUR_OWN:
      LocalizableString.shared.get(with: .yourOwn)
    case .GENERIC(let docType):
      LocalizableString.shared.get(with: .dynamic(key: docType))
    }
  }

  public var rawValue: String {
    return switch self {
    case .PID:
      Self.pidDocType
    case .MDL:
      Self.mdlDocType
    case .AGE:
      Self.ageDocType
    case .YOUR_OWN:
      Self.yourOwnDocType
    case .GENERIC(let docType):
      docType
    }
  }

  public var isSupported: Bool {
    return switch self {
    case .PID, .MDL, .AGE, .YOUR_OWN: true
    case .GENERIC: false
    }
  }

  public init(rawValue: String) {
    switch rawValue {
    case Self.pidDocType:
      self = .PID
    case Self.mdlDocType:
      self = .MDL
    case Self.ageDocType:
      self = .AGE
    case Self.yourOwnDocType:
      self = .YOUR_OWN
    default:
      self = .GENERIC(docType: rawValue)
    }
  }
}

private extension DocumentTypeIdentifier {
  static let pidDocType = "eu.europa.ec.eudi.pid.1"
  static let mdlDocType = "org.iso.18013.5.1.mDL"
  static let ageDocType = "eu.europa.ec.eudi.pseudonym.age_over_18.1"
  static let yourOwnDocType = "your_own_doctype"
}
```

In *RequestDataUIModel*, inside feature-common module, add a new *RequestDataSection.Type*

Example:

```
public extension RequestDataSection {
  enum `Type`: Equatable {
    case id
    case mdl
    case age
    case yourown
    case custom(String)

    public init(docType: DocumentTypeIdentifier) {
      switch docType {
      case .PID:
        self = .id
      case .MDL:
        self = .mdl
      case .AGE:
        self = .age
      case .YOUR_OWN:
        self = .yourown
      case .GENERIC(docType: let docType):
        self = .custom(docType)
      }
    }
  }
}
```

In *AddDocumentUIModel*, inside feature-issuance module, please adjust the *AddDocumentUIModel.items* extension variable to add your new document.

```
public extension AddDocumentUIModel {

  static var items: [AddDocumentUIModel] {
    [
      .init(
        isEnabled: true,
        documentName: .pid,
        image: Theme.shared.image.id,
        isLoading: false,
        type: .PID
      ),
      .init(
        isEnabled: true,
        documentName: .mdl,
        image: Theme.shared.image.id,
        isLoading: false,
        type: .MDL
      ),
      .init(
        isEnabled: true,
        documentName: .ageVerification,
        image: Theme.shared.image.id,
        isLoading: false,
        type: .AGE
      ),
      .init(
        isEnabled: true,
        documentName: .yourOwn,
        image: Theme.shared.image.id,
        isLoading: false,
        type: .YOUR_OWN
      )
    ]
  }
```

In *AddDocumentInteractor*, inside feature-issuance module, please adjust the *fetchStoredDocuments* function to add your new document.

Example:

```
let types = AddDocumentUIModel.items.map({
  var item = $0
  switch item.type {
    case .PID:
      item.isEnabled = true
    case .MDL:
      item.isEnabled = flow == .extraDocument
    case .AGE:
      item.isEnabled = flow == .extraDocument
    case .YOUR_OWN:
      item.isEnabled = flow == .extraDocument
    case .GENERIC:
      break
    }
  return item
})
```

## How to work with self-signed certificates

This section describes configuring the application to interact with services utilizing self-signed certificates.

Add these lines of code to the top of the file *WalletKitController*, inside the logic-core module, just below the import statements. 

```
class SelfSignedDelegate: NSObject, URLSessionDelegate {
  func urlSession(
    _ session: URLSession,
    didReceive challenge: URLAuthenticationChallenge,
    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
  ) {
    // Check if the challenge is for a self-signed certificate
    if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
       let trust = challenge.protectionSpace.serverTrust {
      // Create a URLCredential with the self-signed certificate
      let credential = URLCredential(trust: trust)
      // Call the completion handler with the credential to accept the self-signed certificate
      completionHandler(.useCredential, credential)
    } else {
      // For other authentication methods, call the completion handler with a nil credential to reject the request
      completionHandler(.cancelAuthenticationChallenge, nil)
    }
  }
}

let walletSession: URLSession = {
  let delegate = SelfSignedDelegate()
  let configuration = URLSessionConfiguration.default
  return URLSession(
    configuration: configuration,
    delegate: delegate,
    delegateQueue: nil
  )
}()
```

Once the above is in place add the following:

```
wallet.urlSession = walletSession
```

in the initializer. This change will allow the app to interact with web services that rely on self-signed certificates.

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

## Analytics configuration

The application allows the configuration of multiple analytics providers. You can configure the following:

1. Initializing the provider (e.g. Firebase, Appcenter, etc...)
2. Screen logging
3. Event logging

Via the *AnalyticsConfig* and *LogicAnalyticsAssembly* inside the logic-analytics module.

```
protocol AnalyticsConfig {
  /**
   * Supported Analytics Provider, e.g. Firebase
   */
  var analyticsProviders: [String: AnalyticsProvider] { get }
}
```

You can provide your implementation by implementing the *AnalyticsProvider* protocol and then adding it to your *AnalyticsConfigImpl* analyticsProviders variable.
You will also need the provider's token/key, thus requiring a [String: AnalyticsProvider] configuration.
The project utilizes Dependency Injection (DI), thus requiring adjustment of the *LogicAnalyticsAssembly* graph to provide the configuration.

Implementation Example:
```
struct AppCenterProvider: AnalyticsProvider {
 
  func initialize(key: String) {
    AppCenter.start(
      withAppSecret: key,
      services: [
        Analytics.self
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
```

Config Example:
```
struct AnalyticsConfigImpl: AnalyticsConfig {
  var analyticsProviders: [String: AnalyticsProvider] {
    return ["YOUR_OWN_KEY": AppCenterProvider()]
  }
}
```

Config Construction via DI Graph Example:
```
container.register(AnalyticsConfig.self) { _ in
 AnalyticsConfigImpl()
}
.inObjectScope(ObjectScope.graph)
```
