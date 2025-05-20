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

struct HomeTabView<Router: RouterHost>: View {

  @Environment(\.scenePhase) private var scenePhase

  @ObservedObject private var viewModel: HomeTabViewModel<Router>

  init(with viewModel: HomeTabViewModel<Router>) {
    self.viewModel = viewModel
  }

  var body: some View {
    content(
      viewState: viewModel.viewState,
      isAuthenticateAlertShowing: $viewModel.isAuthenticateAlertShowing,
      isSignDocumentAlertShowing: $viewModel.isSignDocumentAlertShowing,
      toggleAuthenticateAlert: viewModel.toggleAuthenticateAlert(),
      toggleAuthenticateModal: viewModel.toggleAuthenticateModal(),
      openSignDocument: viewModel.openSignDocument(),
      toggleSignDocumentAlert: viewModel.toggleSignDocumentAlert()
    )
    .onChange(of: viewModel.isAuthenticateModalShowing) { showOnline in
        guard showOnline else { return }
        viewModel.onShowScanner()
    }
    .confirmationDialog(
      .bleDisabledModalTitle,
      isPresented: $viewModel.isBleModalShowing,
      titleVisibility: .visible
    ) {
      Button(.cancelButton, role: .cancel) {}
      Button(.bleDisabledModalButton) {
        viewModel.onBleSettings()
      }
    } message: {
      Text(.bleDisabledModalCaption)
    }
    .onChange(of: scenePhase) { phase in
      self.viewModel.setPhase(with: phase)
    }
    .onAppear {
      viewModel.onCreate()
    }
    .background(Theme.shared.color.background)
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: HomeTabState,
  isAuthenticateAlertShowing: Binding<Bool>,
  isSignDocumentAlertShowing: Binding<Bool>,
  toggleAuthenticateAlert: @autoclosure @escaping () -> Void,
  toggleAuthenticateModal: @autoclosure @escaping () -> Void,
  openSignDocument: @autoclosure @escaping () -> Void,
  toggleSignDocumentAlert: @autoclosure @escaping () -> Void
) -> some View {
  ScrollView {
    VStack(alignment: .leading, spacing: SPACING_MEDIUM) {
      ContentHeader(
        config: viewState.contentHeaderConfig
      )

      Text(.welcomeBack([viewState.username]))
        .font(Theme.shared.font.titleMedium.font)
        .foregroundStyle(Theme.shared.color.onSurface)

      HomeCardView(
        text: LocalizableStringKey.authenticateAuthoriseTransactions,
        buttonText: LocalizableStringKey.authenticate,
        illustration: Theme.shared.image.homeIdentity,
        learnMoreText: LocalizableStringKey.learnMore,
        learnMoreAction: {
          toggleAuthenticateAlert()
        },
        action: toggleAuthenticateModal()
      )
      .alertView(
        isPresented: isAuthenticateAlertShowing,
        title: .alertAccessOnlineServices,
        message: .alertAccessOnlineServicesMessage,
        buttonText: .okButton,
        onDismiss: nil
      )
    }
    .padding(.horizontal, SPACING_MEDIUM)
  }
  .clipped()
  .background(Theme.shared.color.background)
}

#Preview {
  let state = HomeTabState(
    username: "Eudi User",
    contentHeaderConfig: .init(
      appIconAndTextData: AppIconAndTextData(
        appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
        appText: ThemeManager.shared.image.euditext
      )
    ),
    phase: .active,
    pendingBleModalAction: false
  )
  content(
    viewState: state,
    isAuthenticateAlertShowing: .constant(false),
    isSignDocumentAlertShowing: .constant(false),
    toggleAuthenticateAlert: {}(),
    toggleAuthenticateModal: {}(),
    openSignDocument: {}(),
    toggleSignDocumentAlert: {}()
  )
}
