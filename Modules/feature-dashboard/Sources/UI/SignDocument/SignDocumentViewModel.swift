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

@Copyable
struct SignDocumentState: ViewState {
  let listItem: ListItemData
}

final class SignDocumentViewModel<Router: RouterHost>: ViewModel<Router, SignDocumentState> {

  @Published var showFilePicker: Bool = false

  private let interactor: DocumentSignInteractor

  init(
    router: Router,
    interactor: DocumentSignInteractor
  ) {
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        listItem: .init(
          mainText: .selectDocument,
          trailingContent: .icon(Theme.shared.image.plus)
        )
      )
    )
  }

  func pop() {
    router.pop()
  }

  func onFileSelection(with url: URL) {
    Task {
      guard url.startAccessingSecurityScopedResource() else {
        return
      }
      do {
        _ = try Data(contentsOf: url)
        await interactor.initiateSigning(url: url)
      } catch {}
    }
  }

  func onShowFilePicker() {
    showFilePicker = true
  }
}
