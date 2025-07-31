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

struct IssuerSelectionView<Router: RouterHost>: View {
  @ObservedObject var viewModel: IssuanceOptionViewModel<Router>
  @State private var newIssuerName: String = ""
  @State private var newIssuerUrl: String = "http://"
  @State private var availableIssuers: [IssuerInfo] = IssuerManager.shared.getIssuers()

  init(viewModel: IssuanceOptionViewModel<Router>) {
    self.viewModel = viewModel
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: false,
      navigationTitle: .selectIssuer,
      toolbarContent: toolbarContent()
    ) {
      VStack(spacing: SPACING_MEDIUM) {
        // MARK: - Add new issuer section
        VStack(alignment: .leading, spacing: SPACING_MEDIUM) {
          Text("Add New Issuer")
            .font(.headline)
            .padding(.horizontal)

          VStack(alignment: .leading, spacing: SPACING_MEDIUM) {
            VStack(alignment: .leading, spacing: 4) {
              Text("Issuer Name")
                .font(.subheadline)
                .foregroundColor(.gray)
              TextField("Enter issuer name", text: $newIssuerName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            VStack(alignment: .leading, spacing: 4) {
              Text("Issuer URL")
                .font(.subheadline)
                .foregroundColor(.gray)
              TextField("Enter issuer URL", text: $newIssuerUrl)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.URL)
                .autocapitalization(.none)

              if !viewModel.isURLValid(newIssuerUrl) {
                Text("Please enter a valid HTTPS URL")
                  .font(.caption)
                  .foregroundColor(Theme.shared.color.error)
              }
            }

            Button(action: {
              if !newIssuerName.isEmpty && viewModel.isURLValid(newIssuerUrl) {
                IssuerManager.shared.addIssuer(newIssuerName, url: newIssuerUrl)
                availableIssuers = IssuerManager.shared.getIssuers()
                newIssuerName = ""
                newIssuerUrl = "http://"
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
              }
            }, label: {
              Text("Add Issuer")
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                  !newIssuerName.isEmpty && viewModel.isURLValid(newIssuerUrl) ?
                  Theme.shared.color.primary : Color.gray.opacity(0.3)
                )
                .foregroundColor(.white)
                .cornerRadius(8)
            })
            .disabled(newIssuerName.isEmpty || newIssuerUrl.isEmpty)
          }
          .padding()
          .background(
            RoundedRectangle(cornerRadius: 12)
              .fill(Theme.shared.color.surfaceContainer)
          )
          .padding(.horizontal)
        }

        // MARK: - List of available issuers
        ScrollView {
          VStack(spacing: SPACING_MEDIUM_SMALL) {
            ForEach(availableIssuers, id: \.name) { issuer in
              Button(action: {
                viewModel.onIssuerSelected(issuer.name)
              }, label: {
                HStack {
                  VStack(alignment: .leading, spacing: 4) {
                    Text(issuer.name)
                      .typography(Theme.shared.font.bodyLarge)
                      .foregroundStyle(Theme.shared.color.primary)
                    Text(issuer.url)
                      .typography(Theme.shared.font.bodyMedium)
                      .foregroundStyle(Theme.shared.color.onSurfaceVariant)
                  }
                  Spacer()

                  if issuer.name == viewModel.viewState.selectedIssuer {
                    Image(systemName: "checkmark.circle.fill")
                      .foregroundStyle(Theme.shared.color.blue)
                  }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(
                  RoundedRectangle(cornerRadius: 12)
                    .fill(Theme.shared.color.surfaceContainer)
                )
              })
              .buttonStyle(PlainButtonStyle())
              .padding(.horizontal)
            }
          }
          .padding(.vertical, SPACING_MEDIUM)
        }
      }
    }
  }

  func toolbarContent() -> ToolBarContent {
    .init(
      trailingActions: [],
      leadingActions: [
        ToolBarContent.Action(image: Theme.shared.image.chevronLeft) {
          viewModel.pop()
        }
      ]
    )
  }
}

struct IssuanceOptionView<Router: RouterHost>: View {

  @StateObject private var viewModel: IssuanceOptionViewModel<Router>

  init(with viewModel: IssuanceOptionViewModel<Router>) {
    self._viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: true,
      navigationTitle: .addDocumentTitle,
      toolbarContent: viewModel.toolbarContent()
    ) {
      content(
        onAddDocumentClick: { viewModel.onAddDocumentClick() },
        onScanClick: { viewModel.onScanClick() }
      )
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  onAddDocumentClick: @escaping () -> Void,
  onScanClick: @escaping () -> Void
) -> some View {
  VStack(spacing: SPACING_LARGE_MEDIUM) {
    Text(.addDocumentsToWallet)
      .typography(Theme.shared.font.bodyLarge)
      .foregroundStyle(Theme.shared.color.onSurface)

    VStack(spacing: SPACING_MEDIUM_SMALL) {
      ActionCard(
        icon: Theme.shared.image.chooseDocumentImage,
        title: .chooseFromList,
        action: {
          onAddDocumentClick()
        }
      )

      ActionCard(
        icon: Theme.shared.image.scanDocumentImage,
        title: .scanQrCode,
        action: {
          onScanClick()
        }
      )
    }
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  .padding(.horizontal, Theme.shared.dimension.padding)
}

#Preview {
  ContentScreenView(
    padding: .zero,
    canScroll: true,
    navigationTitle: .addDocumentTitle
  ) {
    content(onAddDocumentClick: {}, onScanClick: {})
  }
}
