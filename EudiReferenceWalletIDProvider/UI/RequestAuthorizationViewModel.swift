import IdentityDocumentServices
import IdentityDocumentServicesUI
import MdocDataModel18013
import WalletStorage
import SwiftUI
import DcApi18013AnnexC
import feature_common

@Copyable
public struct RequestAuthorizationViewState: ViewState {
  public let websiteName: String?
  public let documents: [AuthorizationUIDocument]?
  public let errorMessage: String?
  public let isLoading: Bool
  public let contentHeaderConfig: ContentHeaderConfig
}

@Copyable
public struct AuthorizationUIDocument: Equatable, Identifiable, Hashable {
  public let id: String
  public let documentName: String

  public init(
    id: String = UUID().uuidString,
    documentName: String
  ) {
    self.id = id
    self.documentName = documentName
  }
}

@MainActor
@Observable
open class RequestAuthorizationViewModel<Router: RouterHost>: ViewModel<Router, RequestAuthorizationViewState> {

  private var dcApiHandler: DcApiHandler
  private var context: ISO18013MobileDocumentRequestContext?

  init(
    router: Router,
    context: ISO18013MobileDocumentRequestContext?,
    dcApiHandler: DcApiHandler
  ) {
    self.context = context
    self.dcApiHandler = dcApiHandler
    super.init(
      router: router,
      initialState: .init(
        websiteName: nil,
        documents: nil,
        errorMessage: nil,
        isLoading: true,
        contentHeaderConfig: .init(
          appIconAndTextData: AppIconAndTextData(
            appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
            appText: ThemeManager.shared.image.euditext
          ),
          description: .dataSharingTitle
        )
      )
    )
  }

  func loadRequest() async {
    do {
      guard let context else {
        return
      }

      let (set, _, rn) = try await dcApiHandler.validateRequest(context.request)
      let requestSet = set.requests.map {
        AuthorizationUIDocument(documentName: $0.documentType)
      }
      let websiteName = context.requestingWebsiteOrigin?.absoluteString ?? rn ?? "Website name not available"

      setState {
        $0.copy(
          websiteName: websiteName,
          documents: requestSet,
          isLoading: false,
          contentHeaderConfig: .init(
            appIconAndTextData: AppIconAndTextData(
              appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
              appText: ThemeManager.shared.image.euditext
            ),
            description: .dataSharingTitle,
            mainText: .dataSharingRequest,
            relyingPartyData: RelyingPartyData(
              isVerified: true,
              name: .custom(websiteName),
              description: .requestsTheFollowing
            )
          )
        )
      }
    } catch let error {
      setState {
        $0.copy(
          errorMessage: error.localizedDescription,
          isLoading: false
        )
      }
    }
  }

  func acceptVerification() {
    Task {
      setState {
        $0.copy(
          isLoading: true
        )
      }
      defer {
        setState {
          $0.copy(isLoading: false)
        }
      }

      do {
        guard let context else {
          throw NSError(
            domain: "RequestAuthorizationViewModel",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Context is not available"]
          )
        }

        try await context.sendResponse { rawRequest in
          try await self.dcApiHandler.validateConsistency(
            request: context.request,
            rawRequest: rawRequest
          )
          try await self.dcApiHandler.validateRawRequest(rawRequest: rawRequest)

          let responseData = try await self.dcApiHandler.buildAndEncryptResponse(
            request: context.request,
            rawRequest: rawRequest,
            originUrl: context.requestingWebsiteOrigin?.absoluteString
          )

          return ISO18013MobileDocumentResponse(responseData: responseData)
        }

        router.pop()
      } catch {
        setState {
          $0.copy(
            errorMessage: error.localizedDescription
          )
        }
      }
    }
  }

  func cancelRequest() {
    context?.cancel()
  }

  // MARK: - Helper Methods
  func createBiometryConfig(routerHost: RouterHost) -> UIConfig.Biometry {
    UIConfig.Biometry(
      navigationTitle: .biometryConfirmRequest,
      displayLogo: true,
      caption: .requestDataShareBiometryCaption,
      quickPinOnlyCaption: .requestDataShareQuickPinCaption,
      navigationSuccessType: .pop,
      navigationBackType: .pop,
      isPreAuthorization: true,
      shouldInitializeBiometricOnCreate: true
    )
  }
}
