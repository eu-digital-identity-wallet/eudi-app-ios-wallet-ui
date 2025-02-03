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
import Foundation
import logic_resources

struct FiltersListView: View {

  @Environment(\.dismiss) var dismiss

  var resetFiltersAction: () -> Void
  var applyFiltersAction: () -> Void
  var updateFiltersCallback: ((String, String) -> Void)?

  let sections: [FilterUISection]

  init(
    sections: [FilterUISection],
    resetFiltersAction: @escaping () -> Void,
    applyFiltersAction: @escaping () -> Void,
    updateFiltersCallback: ((String, String) -> Void)?
  ) {
    self.sections = sections
    self.resetFiltersAction = resetFiltersAction
    self.applyFiltersAction = applyFiltersAction
    self.updateFiltersCallback = updateFiltersCallback
  }

  var body: some View {
    NavigationView {
      List {
        ForEach(sections) { section in
          FilterSection(
            sectionTitle: section.sectionTitle,
            sectionID: section.id.uuidString,
            filters: section.filters
          )
        }
      }
      .listStyle(.grouped)
      .navigationTitle(LocalizableString.shared.get(with: .filters).capitalized)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button(LocalizableString.shared.get(with: .cancelButton).capitalized) {
            dismiss()
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(LocalizableString.shared.get(with: .reset).capitalized) { }
          .disabled(true)
        }
      }
      .overlay {
        withAnimation {
          Text(LocalizableString.shared.get(with: .showResults).capitalized)
            .font(.body.bold())
            .foregroundStyle(Theme.shared.color.white)
            .frame(maxWidth: .infinity)
            .padding(SPACING_MEDIUM_SMALL)
            .background(RoundedRectangle(cornerRadius: 8))
            .foregroundStyle(Theme.shared.color.primary)
            .padding(.horizontal, SPACING_MEDIUM)
            .onTapGesture {
              applyFiltersAction()
              dismiss()
            }
        }
      }
    }
  }

  @ViewBuilder
  func FilterSection(sectionTitle: String, sectionID: String, filters: [FilterUIItem]) -> some View {
    Section(header: Text(sectionTitle)) {
      ForEach(filters.indices, id: \.self) { index in
        HStack {
          Text(filters[index].title)
            .frame(maxWidth: .infinity, alignment: .topLeading)
          if filters[index].selected {
            Image(systemName: "checkmark")
              .foregroundColor(ThemeManager.shared.color.primary)
          }
        }
        .contentShape(Rectangle())
        .frame(maxWidth: .infinity)
        .onTapGesture {
          updateFiltersCallback?(sectionID, filters[index].id.uuidString)
        }
      }
    }
  }
}
