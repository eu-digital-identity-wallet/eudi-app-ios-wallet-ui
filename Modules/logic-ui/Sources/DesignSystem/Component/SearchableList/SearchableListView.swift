/*
 * Copyright (c) 2025 European Commission
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
import logic_resources

public extension View {
  func searchable(
    searchText: Binding<String>,
    placeholder: LocalizableStringKey = .search,
    backgroundColor: Color? = nil,
    onSearchTextChange: ((String) -> Void)? = nil
  ) -> some View {
    modifier(
      SearchableModifier(
        searchText: searchText,
        placeholder: placeholder,
        backgroundColor: backgroundColor,
        onSearchTextChange: onSearchTextChange
      )
    )
  }
}

private struct SearchableModifier: ViewModifier {
  @Binding var searchText: String
  let placeholder: LocalizableStringKey
  let backgroundColor: Color?
  let onSearchTextChange: ((String) -> Void)?

  init(
    searchText: Binding<String>,
    placeholder: LocalizableStringKey,
    backgroundColor: Color?,
    onSearchTextChange: ((String) -> Void)? = nil
  ) {
    self._searchText = searchText
    self.placeholder = placeholder
    self.backgroundColor = backgroundColor
    self.onSearchTextChange = onSearchTextChange
  }

  func body(content: Content) -> some View {
    VStack(spacing: .zero) {
      CustomSearchBar(
        text: $searchText,
        placeholder: placeholder
      )
      .padding(.horizontal, SPACING_SMALL)
      .background(backgroundColor)

      content
        .onChange(of: searchText) { newValue in
          onSearchTextChange?(newValue)
        }
    }
  }
}

private struct CustomSearchBar: UIViewRepresentable {
  @Binding var text: String
  let placeholder: LocalizableStringKey

  class Coordinator: NSObject, UISearchBarDelegate {
    @Binding var text: String

    init(text: Binding<String>) {
      _text = text
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      text = searchText
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
      text = ""
      searchBar.resignFirstResponder()
    }

    @objc func dismissKeyboard() {
      UIApplication.shared.hideKeyboard()
    }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(text: $text)
  }

  func makeUIView(context: Context) -> UISearchBar {
    let searchBar = UISearchBar()
    searchBar.placeholder = placeholder.toString
    searchBar.delegate = context.coordinator
    searchBar.autocapitalizationType = .none

    let toolbar = UIToolbar()
    toolbar.sizeToFit()

    let doneButton = UIBarButtonItem(
      title: LocalizableStringKey.doneButton.toString,
      style: .done,
      target: context.coordinator,
      action: #selector(context.coordinator.dismissKeyboard)
    )
    toolbar.items = [doneButton]

    searchBar.inputAccessoryView = toolbar

    searchBar.backgroundImage = UIImage()
    searchBar.searchTextField.backgroundColor = UIColor(Theme.shared.color.surfaceContainer)

    return searchBar
  }

  func updateUIView(_ uiView: UISearchBar, context: Context) {
    uiView.text = text
  }
}

#Preview {
  NavigationView {
    WrapListItemsView(
      listItems: [
        .init(mainContent: .text(.custom("Family name")), supportingText: .custom("Doe")),
        .init(mainContent: .text(.custom("Given names")), supportingText: .custom("John")),
        .init(mainContent: .text(.custom("Date of birth")), supportingText: .custom("21 Oct 1994")),
        .init(mainContent: .text(.custom("Age over 18")), supportingText: .custom("21 Oct 1994")),
        .init(mainContent: .text(.custom("Date of issue")), supportingText: .custom("21 Oct 1994"))
      ]
    )
    .searchable(
      searchText: .constant(""),
      placeholder: .search
    )
  }
}
