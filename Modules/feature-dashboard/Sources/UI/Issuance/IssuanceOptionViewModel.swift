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
import logic_ui
import logic_resources
import feature_common

@Copyable
struct IssuanceOptionViewState: ViewState {
  let error: ContentErrorView.Config?
  let title: LocalizableStringKey
  let selectedIssuer: String
}

class IssuanceOptionViewModel<Router: RouterHost>: ViewModel<Router, IssuanceOptionViewState> {

  init(
    router: Router,
    selectedIssuer: String? = nil
  ) {
    let initialIssuer = IssuerManager.shared.getSelectedIssuer() ?? selectedIssuer ?? IssuerManager.shared.defaultIssuerName

    super.init(
      router: router,
      initialState: .init(
        error: nil,
        title: .addDocumentsToWallet,
        selectedIssuer: initialIssuer
      )
    )
  }

  func onScanClick() {
    router.push(
      with: .featureCommonModule(
        .qrScanner(
          config: ScannerUiConfig(
            flow: .issuing(
              successNavigation: .popTo(
                .featureDashboardModule(
                  .dashboard
                )
              ),
              cancelNavigation: .popTo(
                .featureDashboardModule(
                  .issuanceOption
                )
              )
            )
          )
        )
      )
    )
  }

  func onAddDocumentClick() {
    router.push(
      with: .featureIssuanceModule(
        .issuanceAddDocument(
          config: IssuanceFlowUiConfig(flow: .extraDocument)
        )
      )
    )
  }

  func toolbarContent() -> ToolBarContent {
    .init(
      trailingActions: [
        ToolBarContent.Action(image: Theme.shared.image.plus) {
          self.showIssuerSelection()
        }
      ],
      leadingActions: [
        .init(image: Theme.shared.image.chevronLeft) {
          self.router.pop()
        }
      ]
    )
  }

  // MARK: - Show IssuerSelectionView
  func showIssuerSelection() {
    router.push(
      with: .featureDashboardModule(
        .issuerSelection(
          viewState.selectedIssuer
        )
      )
    )
  }

  func onIssuerSelected(_ issuer: String) {
    IssuerManager.shared.setSelectedIssuer(issuer)
    setState {
      $0.copy(selectedIssuer: issuer)
    }
  }

  func pop() {
    router.pop()
  }

  func isURLValid(_ urlString: String) -> Bool {
    guard let url = URL(string: urlString),
          url.scheme == "http" || url.scheme == "https",
          url.host != nil else {
      return false
    }
    return true
  }
}
