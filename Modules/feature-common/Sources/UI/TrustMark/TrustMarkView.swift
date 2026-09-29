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

struct TrustMarkView<Router: RouterHost>: View {

  @State private var viewModel: TrustMarkViewModel<Router>

  init(with viewModel: TrustMarkViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: true,
      navigationTitle: viewModel.viewState.config.isWelcome ? nil : .trustMarkAboutTitle,
      toolbarContent: viewModel.toolbarContent()
    ) {
      ScrollView {
        TrustMarkViewContainer(
          viewState: viewModel.viewState,
          onRetry: viewModel.onRetry,
          onOpenLink: viewModel.onOpenLink
        )
        .padding(Theme.shared.dimension.padding)
      }
      .safeAreaInset(edge: .bottom, spacing: .zero) {
        if viewModel.viewState.config.isWelcome {
          WrapButtonView(
            style: .primary,
            title: .continueButton,
            isEnabled: !viewModel.viewState.isCompleting && !viewModel.viewState.isNavigating,
            onAction: viewModel.onContinue()
          )
          .padding(.horizontal, SPACING_MEDIUM)
          .padding(.top, SPACING_MEDIUM)
          .padding(.bottom, SPACING_LARGE_MEDIUM)
          .background(Theme.shared.color.background)
        }
      }
    }
    .onError(
      show: $viewModel.isBrowserErrorShowing,
      message: LocalizableStringKey.trustMarkBrowserError.toString
    )
    .task {
      await viewModel.initialize()
    }
  }
}

private enum TrustMarkImageState {
  case loading
  case loaded
  case failed
}

private struct TrustMarkViewContainer: View {

  let viewState: TrustMarkState
  let onRetry: () -> Void
  let onOpenLink: (URL) -> Void

  @State private var imageState: TrustMarkImageState = .loading
  @State private var imageAttempt = UUID()
  @State private var imageAspectRatio: CGFloat?

  private let placeholderAspectRatio: CGFloat = 3

  var body: some View {
    VStack(alignment: .leading, spacing: SPACING_LARGE_MEDIUM) {
      heading()

      if viewState.isLoading {
        loadingSection()
      } else if let loadError = viewState.loadError {
        statusSection(message: loadError, onRetry: onRetry)
      } else if let trustMark = viewState.trustMark {
        badge(trustMark)
        linkedParagraph(trustMark.certificationDescription, url: trustMark.certifiedWalletsUrl)
        linkedParagraph(trustMark.certificationInformationDescription, url: trustMark.walletSolutionUrl)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .environment(\.openURL, OpenURLAction { url in
      onOpenLink(url)
      return .handled
    })
  }

  @ViewBuilder
  private func heading() -> some View {
    VStack(alignment: .leading, spacing: .zero) {
      if viewState.config.isWelcome {
        ContentHeaderView(
          config: ContentHeaderConfig(
            appIconAndTextData: AppIconAndTextData(
              appIcon: Theme.shared.image.logoEuDigitalIndentityWallet
            )
          )
        )
      }
      VStack(alignment: .leading, spacing: SPACING_SMALL) {
        if viewState.config.isWelcome {
          Text(.trustMarkWelcomeTitle)
            .typography(Theme.shared.font.titleLarge)
            .fontWeight(.regular)
            .foregroundColor(Theme.shared.color.primaryLabel)
        }
        Text(.trustMarkWalletName)
          .typography(Theme.shared.font.displayLarge)
          .fontWeight(.regular)
          .foregroundColor(Theme.shared.color.primaryLabel)
      }
      .padding(.top, ContentTitleView.TopSpacing.withoutToolbar.rawValue)
    }
  }

  @ViewBuilder
  private func badge(_ trustMark: TrustMarkUIModel) -> some View {
    VStack(alignment: .leading, spacing: SPACING_SMALL) {
      VStack(alignment: .center, spacing: SPACING_MEDIUM) {
        image(url: trustMark.imageUrl)
        if let text = trustMark.text {
          Text(.custom(text))
            .typography(Theme.shared.font.bodyLarge)
            .fontWeight(.regular)
            .foregroundColor(Theme.shared.color.primaryLabel)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
      }
      if trustMark.imageUrl == nil || imageState == .failed {
        statusSection(
          message: LocalizableStringKey.trustMarkImageError.toString,
          onRetry: trustMark.imageUrl == nil ? nil : {
            imageState = .loading
            imageAttempt = UUID()
          }
        )
      }
    }
  }

  @ViewBuilder
  private func image(url: URL?) -> some View {
    if let url, imageState != .failed {
      RemoteImageView(
        url: url,
        icon: nil,
        width: nil,
        height: nil,
        retryFailed: true,
        onSuccess: { size in
          if size.width > 0, size.height > 0 {
            imageAspectRatio = size.width / size.height
          }
          imageState = .loaded
        },
        onFailure: { imageState = .failed }
      )
      .id(imageAttempt)
      .aspectRatio(imageAspectRatio ?? placeholderAspectRatio, contentMode: .fit)
      .frame(maxWidth: .infinity)
      .accessibilityLabel(Text(.trustMarkImageDescription))
    } else {
      Theme.shared.image.infoCircle
        .foregroundColor(Theme.shared.color.primaryLabel)
        .frame(maxWidth: .infinity)
    }
  }

  @ViewBuilder
  private func linkedParagraph(_ paragraph: TrustMarkParagraphUIModel, url: URL?) -> some View {
    paragraphText(paragraph, url: url)
      .typography(Theme.shared.font.bodyLarge)
      .foregroundColor(Theme.shared.color.primaryLabel)
      .frame(maxWidth: .infinity, alignment: .leading)
  }

  private func paragraphText(_ paragraph: TrustMarkParagraphUIModel, url: URL?) -> Text {
    let text = paragraph.text
    guard let range = paragraph.linkRange,
          let lower = text.index(text.startIndex, offsetBy: range.lowerBound, limitedBy: text.endIndex),
          let upper = text.index(text.startIndex, offsetBy: range.upperBound, limitedBy: text.endIndex)
    else {
      return Text(.custom(text))
    }

    let linkColor = url == nil ? Theme.shared.color.secondaryLabel : Theme.shared.color.accent
    var link = AttributedString(String(text[lower..<upper]))
    link.foregroundColor = linkColor
    if let url {
      link.link = url
      link.underlineStyle = Text.LineStyle.single
    }

    return Text(.custom(String(text[..<lower])))
    + Text(link)
    + Text(.custom("\u{00A0}"))
    + Text(Theme.shared.image.arrowUpRightSquare).foregroundColor(linkColor)
    + Text(.custom(String(text[upper...])))
  }

  @ViewBuilder
  private func loadingSection() -> some View {
    VStack(alignment: .leading, spacing: SPACING_SMALL) {
      ContentLoaderView(showLoader: .constant(true))
        .frame(maxWidth: .infinity)
      Text(.trustMarkLoading)
        .typography(Theme.shared.font.bodyLarge)
        .foregroundColor(Theme.shared.color.primaryLabel)
    }
  }

  @ViewBuilder
  private func statusSection(message: String, onRetry: (() -> Void)?) -> some View {
    VStack(alignment: .leading, spacing: SPACING_SMALL) {
      Text(.custom(message))
        .typography(Theme.shared.font.bodyLarge)
        .foregroundColor(Theme.shared.color.primaryLabel)
      if let onRetry {
        Button(action: onRetry) {
          Text(.tryAgain)
            .typography(Theme.shared.font.labelLarge)
            .foregroundColor(Theme.shared.color.accent)
        }
      }
    }
  }
}
