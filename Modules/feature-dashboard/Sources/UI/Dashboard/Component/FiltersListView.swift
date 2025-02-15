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

  @State private var isApplied: Bool = false

  var resetFiltersAction: () -> Void
  var applyFiltersAction: () -> Void
  var updateFiltersCallback: ((String, String) -> Void)?
  var revertFilters: () -> Void

  let sections: [FilterUISection]

  init(
    sections: [FilterUISection],
    resetFiltersAction: @escaping () -> Void,
    applyFiltersAction: @escaping () -> Void,
    revertFilters: @escaping () -> Void,
    updateFiltersCallback: ((String, String) -> Void)?
  ) {
    self.sections = sections
    self.resetFiltersAction = resetFiltersAction
    self.applyFiltersAction = applyFiltersAction
    self.updateFiltersCallback = updateFiltersCallback
    self.revertFilters = revertFilters
  }

  var body: some View {
    NavigationView {
      List {
        ForEach(sections) { section in
          FilterSection(
            sectionTitle: section.sectionTitle,
            sectionID: section.id,
            filters: section.filters
          )
        }
      }
      .listStyle(.grouped)
      .scrollIndicators(.hidden)
      .navigationTitle(.filters)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button(.cancelButton) {
            isApplied = true
            revertFilters()
            dismiss()
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(.reset) {
            isApplied = true
            resetFiltersAction()
            dismiss()
          }
        }
      }
      .safeAreaInset(edge: .bottom) {
        WrapButtonView(
          style: .primary,
          title: .showResults,
          onAction: applyFilters()
        )
        .padding(.horizontal, SPACING_MEDIUM)
      }
      .onDisappear {
        if !isApplied {
          revertFilters()
        }
      }
    }
  }

  @ViewBuilder
  func FilterSection(
    sectionTitle: String,
    sectionID: String,
    filters: [FilterUIItem]
  ) -> some View {
    Section(header: Text(sectionTitle)) {
      ForEach(filters.indices, id: \.self) { index in
        HStack {
          Text(filters[index].title)
            .frame(maxWidth: .infinity, alignment: .topLeading)
          if filters[index].selected {
            Theme.shared.image.checkmark
              .foregroundColor(ThemeManager.shared.color.primary)
          }
        }
        .contentShape(Rectangle())
        .frame(maxWidth: .infinity)
        .onTapGesture {
          updateFiltersCallback?(sectionID, filters[index].id)
        }
      }
    }
  }

  private func applyFilters() {
    isApplied = true
    applyFiltersAction()
    dismiss()
  }
}
