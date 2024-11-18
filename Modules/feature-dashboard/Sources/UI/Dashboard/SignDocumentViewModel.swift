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
import logic_ui
import logic_business
import logic_core
import feature_common
import feature_issuance

@Copyable
struct SignDocumentState: ViewState {
  let isLoading: Bool
  let selectDocumentCard: AddDocumentUIModel
  let title: String
  let subtitle: String
  let error: ContentErrorView.Config?
}

final class SignDocumentViewModel<Router: RouterHost>: ViewModel<Router, SignDocumentState> {
  private let interactor: DocumentSignInteractor

  init(
    router: Router,
    interactor: DocumentSignInteractor
  ) {
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        isLoading: true,
        selectDocumentCard: .init(
          isEnabled: true,
          documentName: .selectDocument,
          type: .GENERIC(docType: "Sign Document")
        ),
        title: "",
        subtitle: "",
        error: nil
      )
    )
  }

  func pop() {
    router.pop()
  }

  func launchRQESSdk() {
    //TO DO: replace url
    let state = interactor.launchRQESSdk(uri: URL(filePath: "test")!)
  }
}
