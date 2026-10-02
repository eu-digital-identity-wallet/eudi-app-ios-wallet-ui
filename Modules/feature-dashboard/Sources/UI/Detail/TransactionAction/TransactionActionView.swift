/*
 * Copyright (c) 2026 European Commission
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
import feature_common
import logic_resources
import logic_core

struct TransactionActionView<Router: RouterHost>: View {

  @Environment(\.scenePhase) private var scenePhase

  @State private var viewModel: TransactionActionViewModel<Router>

  init(with viewModel: TransactionActionViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: true,
      errorConfig: viewModel.viewState.error,
      navigationTitle: viewModel.viewState.ui.title,
      isLoading: viewModel.viewState.isLoading,
      toolbarContent: viewModel.toolbarContent()
    ) {
      TransactionActionViewContainer(
        state: viewModel.viewState,
        onContactSelected: { viewModel.onContactSelected($0) }
      )
    }
    .task {
      await viewModel.getContent()
    }
    .onChange(of: scenePhase) {
      viewModel.setPhase(with: scenePhase)
    }
  }
}

private struct TransactionActionViewContainer: View {

  let state: TransactionActionViewState
  let onContactSelected: (TransactionActionContactUi) -> Void

  var body: some View {
    VStack(spacing: .zero) {
      ScrollView {
        VStack(alignment: .leading, spacing: SPACING_LARGE_MEDIUM) {

          switch state.ui.content {
          case .confirmation(let ui):
            confirmation(ui)
          case .contactList(let ui):
            contactList(ui)
          }

          if case .contactList = state.ui.content, state.ui.contacts.isEmpty {
            Text(.transactionDetailsActionUnavailable)
              .typography(Theme.shared.font.bodyMedium)
              .foregroundStyle(Theme.shared.color.secondaryLabel)
              .shimmer(isLoading: state.isLoading)
          }
        }
        .padding(Theme.shared.dimension.padding)
        .padding(.bottom)
      }

      if case .confirmation(let ui) = state.ui.content {
        WrapButtonView(
          style: .primary,
          title: ui.buttonTitle,
          isLoading: state.isLoading,
          isEnabled: ui.contact != nil,
          onAction: selectPreferredContact(ui)
        )
        .padding(.horizontal, Theme.shared.dimension.padding)
        .padding(.bottom, SPACING_LARGE_MEDIUM)
      }
    }
  }

  private func selectPreferredContact(_ ui: TransactionActionUiModel.ConfirmationUi) {
    guard let contact = ui.contact else { return }
    onContactSelected(contact)
  }

  @ViewBuilder
  private func confirmation(_ ui: TransactionActionUiModel.ConfirmationUi) -> some View {
    if let intro = ui.intro {
      WrapCardView(backgroundColor: Theme.shared.color.groupedBackground) {
        Text(intro)
          .typography(Theme.shared.font.bodyMedium)
          .foregroundStyle(Theme.shared.color.primaryLabel)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.all, SPACING_MEDIUM)
      }
      .shimmer(isLoading: state.isLoading)
    }

    VStack(alignment: .leading, spacing: SPACING_MEDIUM) {
      if let notice = ui.notice {
        (Text(ui.noticeBold.toString).fontWeight(.bold) + Text(" " + notice.toString))
          .typography(Theme.shared.font.bodyMedium)
          .foregroundStyle(Theme.shared.color.primaryLabel)
      } else {
        Text(ui.noticeBold)
          .typography(Theme.shared.font.bodyMedium)
          .fontWeight(.bold)
          .foregroundStyle(Theme.shared.color.primaryLabel)
      }

      if let legal = ui.legal {
        Text(legal)
          .typography(Theme.shared.font.bodyMedium)
          .foregroundStyle(Theme.shared.color.primaryLabel)
      }
    }
    .shimmer(isLoading: state.isLoading)
  }

  @ViewBuilder
  private func contactList(_ ui: TransactionActionUiModel.ContactListUi) -> some View {
    if let partyName = ui.partyName {
      WrapCardView(backgroundColor: Theme.shared.color.groupedBackground) {
        VStack(alignment: .leading, spacing: SPACING_EXTRA_SMALL) {
          Text(ui.partyLabel)
            .typography(Theme.shared.font.labelSmall)
            .fontWeight(.semibold)
            .foregroundStyle(Theme.shared.color.secondaryLabel)

          Text(partyName)
            .typography(Theme.shared.font.bodyLarge)
            .fontWeight(.medium)
            .foregroundStyle(Theme.shared.color.primaryLabel)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.all, SPACING_MEDIUM)
      }
      .shimmer(isLoading: state.isLoading)
    }

    VStack(alignment: .leading, spacing: SPACING_MEDIUM) {
      (Text(ui.messageBold.toString).fontWeight(.bold) + Text(" " + ui.message.toString))
        .typography(Theme.shared.font.bodyMedium)
        .foregroundStyle(Theme.shared.color.primaryLabel)

      Text(ui.followUp)
        .typography(Theme.shared.font.bodyMedium)
        .foregroundStyle(Theme.shared.color.primaryLabel)
    }
    .shimmer(isLoading: state.isLoading)

    if !state.ui.contacts.isEmpty {
      VStack(spacing: .zero) {
        ForEach(state.ui.contacts) { contact in
          contactRow(contact)
          if contact.id != state.ui.contacts.last?.id {
            ListDividerView()
          }
        }
      }
      .shimmer(isLoading: state.isLoading)
    }
  }

  @ViewBuilder
  private func contactRow(_ contact: TransactionActionContactUi) -> some View {
    Button {
      onContactSelected(contact)
    } label: {
      HStack(spacing: SPACING_MEDIUM) {
        contact.channel.icon
          .renderingMode(.template)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 20, height: 20)
          .foregroundStyle(Theme.shared.color.primaryLabel)

        Text(contact.label)
          .typography(Theme.shared.font.bodyMedium)
          .foregroundStyle(Theme.shared.color.accent)
          .multilineTextAlignment(.leading)

        Spacer()

        Text(contact.channel.actionTitle)
          .typography(Theme.shared.font.labelSmall)
          .fontWeight(.semibold)
          .foregroundStyle(Theme.shared.color.primaryLabel)

        Theme.shared.image.chevronRight
          .renderingMode(.template)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 16, height: 16)
          .foregroundStyle(Theme.shared.color.accent)
      }
      .padding(.vertical, SPACING_MEDIUM)
    }
    .disabled(state.isLoading)
  }
}
