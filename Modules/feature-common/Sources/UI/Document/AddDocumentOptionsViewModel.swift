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
import logic_ui
import logic_resources

@Copyable
public struct AddDocumentOptionsViewState: ViewState {
  let isLoading: Bool
  let error: ContentErrorView.Config?
  let config: IssuanceFlowUiConfig
  let title: LocalizableStringKey
}

open class AddDocumentOptionsViewModel<Router: RouterHost>: ViewModel<Router, AddDocumentOptionsViewState> {

  public init(
    router: Router,
    config: any UIConfigType
  ) {
    guard let config = config as? IssuanceFlowUiConfig else {
      fatalError("AddDocumentViewModel:: Invalid configuraton")
    }
    super.init(
      router: router,
      initialState: .init(
        isLoading: false,
        error: nil,
        config: config,
        title: .addDocumentsToWallet
      )
    )
  }

  func onScanClick() {
    router.push(
      with: .featureCommonModule(
        .qrScanner(
          config: ScannerUiConfig(flow: .issuing(viewState.config))
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

  func pop() {
    router.pop()
  }
}
