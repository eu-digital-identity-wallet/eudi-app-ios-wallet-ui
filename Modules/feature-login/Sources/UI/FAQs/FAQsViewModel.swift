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

@Copyable
struct FAQState: ViewState {
  let isLoading: Bool
  let searchText: String
  let models: [FAQUIModel]
  let filteredModels: [FAQUIModel]
}

final class FAQsViewModel<Router: RouterHost>: BaseViewModel<Router, FAQState> {

  private let interactor: FAQsInteractor
  @Published var searchText = ""

  init(router: Router, interactor: FAQsInteractor) {
    self.interactor = interactor

    super.init(
      router: router,
      initialState: .init(
        isLoading: true,
        searchText: "",
        models: FAQUIModel.mocks(),
        filteredModels: FAQUIModel.mocks()
      )
    )

    subscribeToSearchedText()
  }

  private func subscribeToSearchedText() {
    $searchText
      .dropFirst()
      .map { [weak self] text -> [FAQUIModel] in
        guard let self = self else { return [] }
        return viewState.models.filter { model in
          return text.isEmpty || model.value.title.localizedCaseInsensitiveContains(text)
        }
      }
      .sink(receiveValue: { [weak self] models in
        guard let self = self else { return }
        self.setState { $0.copy(filteredModels: models) }
      })
      .store(in: &cancellables)
  }

  func fetchFAQs() async {

    defer {
      setState { $0.copy(isLoading: false) }
    }

    switch await interactor.fetchFAQs() {
    case .success(let faqs):
      setState {
        $0.copy(isLoading: true, models: faqs)
      }
    case .failure:
      setState {
        $0.copy(isLoading: false, models: [])
      }
    }
  }

  func goBack() {
    router.pop(animated: true)
  }
}
