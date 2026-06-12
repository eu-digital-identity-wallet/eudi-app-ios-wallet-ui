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
import logic_ui
import logic_resources

struct GenericSuccessView<Router: RouterHost>: View {

  @State private var viewModel: GenericSuccessViewModel<Router>

  init(
    with viewModel: GenericSuccessViewModel<Router>) {
      self._viewModel = State(wrappedValue: viewModel)
    }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: true
    ) {
      GenericSuccessViewContainer(
        viewState: viewModel.viewState,
        onButtonClicked: { button in
          viewModel.onButtonClicked(with: button)
        }
      )
    }
  }
}

private struct GenericSuccessViewContainer: View {

  let viewState: GenericSuccessState
  let onButtonClicked: (UIConfig.Success.Button) -> Void

  var body: some View {
    content()
  }

  @MainActor
  @ViewBuilder
  private func content() -> some View {
    VStack(spacing: .zero) {
      ContentHeaderView(
        config: ContentHeaderConfig(
          appIconAndTextData: AppIconAndTextData(
            appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet
          )
        )
      )

      VSpacer.jumbo()

      VStack {

        ZStack(alignment: .center) {
          getCenteredIcon()
        }

        VSpacer.large()

        ContentTitleView(
          title: viewState.config.title.value,
          accessibilityTitle: GenericSuccessLocators.successTitle,
          titleFont: Theme.shared.font.displayLarge,
          caption: viewState.config.subtitle,
          titleColor: viewState.config.title.color,
          textAlignment: .center,
          topSpacing: .withoutToolbar
        )

        Spacer()
      }
    }
    .padding(.horizontal, Theme.shared.dimension.padding)
    .safeAreaInset(edge: .bottom) {
      VStack {
        ForEach(viewState.config.buttons, id: \.id) { button in
          WrapButtonView(
            style: button.style == .primary ? .primary : .secondary,
            title: button.title,
            onAction: onButtonClicked(button)
          )
          .ignoreChilrenAccessibility(
            locator: GenericSuccessLocators.successPrimaryButton
          )
        }
      }
      .padding(.horizontal, SPACING_MEDIUM)
      .padding(.bottom, SPACING_LARGE_MEDIUM)
    }
  }

  @MainActor
  @ViewBuilder
  private func getCenteredIcon() -> some View {
    let imageData: (image: Image, color: Color) = switch viewState.config.visualKind {
    case .defaultIcon:
      (Theme.shared.image.checkmarkCircleFill, Theme.shared.color.success)
    case .customIcon(let image, let color):
      (image, color)
    }

    imageData.image
      .resizable()
      .scaledToFit()
      .foregroundColor(imageData.color)
      .frame(height: UIScreen.main.bounds.width / 2.5)
  }
}

#Preview {
  let viewState = GenericSuccessState(
    config: UIConfig.Success(
      title: .init(value: .success),
      subtitle: .issuanceSuccessDeferredCaption(["Name"]),
      buttons: [
        .init(
          title: LocalizableStringKey.okButton,
          style: .primary,
          navigationType: UIConfig.DeepLinkNavigationType.push(screen: .featureDashboardModule(.dashboard))
        )
      ],
      visualKind: .customIcon(Theme.shared.image.clock, Theme.shared.color.pending)
    )
  )

  ContentScreenView {
    GenericSuccessViewContainer(
      viewState: viewState,
      onButtonClicked: { _ in }
    )
  }
}
