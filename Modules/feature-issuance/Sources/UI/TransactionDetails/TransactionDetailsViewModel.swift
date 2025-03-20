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
import logic_resources
import logic_business
import feature_common
import logic_core

@Copyable
struct TransactionDetailsViewState: ViewState {
  let title: LocalizableStringKey
  let detailsDataSharedSection: LocalizableStringKey
  let detailsDataSignedSection: LocalizableStringKey
  let transactionDetailsCardData: TransactionDetailsCardData
  let transactionDetailsUi: TransactionDetailsUIModel?
  var isLoading: Bool
  let error: ContentErrorView.Config?
}

final class TransactionDetailsViewModel<Router: RouterHost>: ViewModel<Router, TransactionDetailsViewState> {

  private let interactor: TransactionDetailsInteractor

  init(
    router: Router,
    interactor: TransactionDetailsInteractor
  ) {
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        title: .transactionInformation,
        detailsDataSharedSection: .transactionDetailsDataShare,
        detailsDataSignedSection: .transactionDetailsDataSigned,
        transactionDetailsCardData: TransactionDetailsCardData(
          transactionType: .custom("e-Signature"),
          transactionItemLabel: .custom("File_signed.pdf"),
          relyingPartyName: .custom("Central issuer"),
          transactionDate: .custom("16 February 2024"),
          status: .custom("Completed"),
          isVerified: true,
          isCompleted: true
        ),
        transactionDetailsUi: nil,
        isLoading: false,
        error: nil
      )
    )
  }

  func getTransactionDetails() async {
    self.setState { $0.copy(isLoading: true).copy(error: nil) }

    let state = await Task.detached { () -> TransactionDetailsInteractorPartialState in
      return await self.interactor.getTransactionDetails(transactionId: "transactionId")
    }.value

    switch state {
    case .success(let transactions):
      self.setState {
        $0.copy(
          transactionDetailsUi: transactions.toUiModel(),
          isLoading: false
        )
      }
    case .failure(let error):
      self.setState {
        $0.copy(
          isLoading: false,
          error: .init(
            description: .custom(error),
            cancelAction: self.setState { $0.copy(error: nil) }
          )
        )
      }
    }
  }

  func onReportModal() {}

  func onShowDeleteModal() {}

  func toolbarContent() -> ToolBarContent? {
    .init(
      leadingActions: [
        Action(image: Theme.shared.image.chevronLeft) {
          self.pop()
        }
      ]
    )
  }

  func pop() {
    router.popTo(with: .featureDashboardModule(.dashboard))
  }
}
