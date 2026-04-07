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
import IdentityDocumentServices
import IdentityDocumentServicesUI
import feature_common
import Observation

@Copyable
struct RequestAuthorizationViewState: ViewState {
  let items: [AuthorizationUIRequestItem]
  let errorMessage: String?
  let isLoading: Bool
  let contentHeaderConfig: ContentHeaderConfig
}

@MainActor
@Observable
final class RequestAuthorizationViewModel: ViewModel<RequestAuthorizationViewState> {
  var showBiometryView: Bool = false

  private var context: ISO18013MobileDocumentRequestContext?
  private var interactor: RequestAuthorizationInteractor = DIGraph.shared.resolver.force(
    RequestAuthorizationInteractor.self
  )

  init(
    context: ISO18013MobileDocumentRequestContext?,
  ) {
    self.context = context
    super.init(
      initialState: .init(
        items: [],
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

      let uiModel = try await interactor.loadRequestData(context: context)

      setState {
        $0.copy(
          items: uiModel.document.toRequestItems(),
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
              name: .custom(uiModel.issuerName),
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

  func acceptVerification() async {
    setState {
      $0.copy(
        isLoading: true
      )
    }

    do {
      guard let context else {
        return
      }

      try await interactor.acceptVerification(context: context)
    } catch {
      setState {
        $0.copy(
          errorMessage: error.localizedDescription
        )
      }
    }
  }

  func cancelRequest() {
    context?.cancel()
  }

  func onSelectionChanged(id: String) {}

  func createBiometryConfig() -> UIConfig.AuthorizeAction {
    UIConfig.AuthorizeAction(
      displayLogo: true,
      caption: .requestDataShareBiometryCaption,
      quickPinOnlyCaption: .requestDataShareQuickPinCaption,
      navigationBackType: .pop,
      onAuthResult: { [weak self] result in
        guard let self = self else { return }

        switch result {
        case .success:
          Task {
            await self.acceptVerification()
          }
        case .cancelled, .error:
          break
        }
      }
    )
  }
}
