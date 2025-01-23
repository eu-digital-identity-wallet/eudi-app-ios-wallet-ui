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

struct FilterListView: View {
  @Environment(\.dismiss) var dismiss

  @State private var filterCounter: Int = 0
  @State private var showCounterRectangle: Bool = false
  @State private var togglesState: [String: Bool] = [:]

  @Binding var sortAscending: Bool
  @Binding var showFilterIndicator: Bool
  @Binding var selectedOptions: Set<String>
  @Binding var selectedExpiryOption: String
  @Binding var selectesSorting: String
  @Binding var stateOption: String

  var applyFiltersCallback: () -> Void
  var resetFiltersCallback: () -> Void

  let sections: [FilterSections]

  var body: some View {
    NavigationView {
      List {
        ForEach(sections, id: \.sectionTitle) { section in
          switch section {
          case .issuedSortingDate:
            sortSection(section: section)
          case .sortBy:
            sortBySection(section: section)
          case .issuer:
            categorySection(section: section)
          case .expiryPeriod:
            expiryPeriodSection(section: section)
          case .state:
            stateSection(section: section)
          }
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
          Button(LocalizableString.shared.get(with: .reset).capitalized) {
            showFilterIndicator = false
            resetFiltersCallback()
            resetFilters()
          }
          .disabled(selectedOptions.isEmpty && sortAscending && selectesSorting == LocalizableString.shared.get(with: .defaultLabel).capitalized)
        }
      }
      .overlay(alignment: .bottom) {
        if showCounterRectangle {
          Text(LocalizableString.shared.get(with: .showResults).capitalized)
            .font(.body.bold())
            .foregroundStyle(Theme.shared.color.white)
            .frame(maxWidth: .infinity)
            .padding(SPACING_MEDIUM_SMALL)
            .background(RoundedRectangle(cornerRadius: 8))
            .foregroundStyle(Theme.shared.color.primary)
            .padding(.horizontal, SPACING_MEDIUM)
            .onTapGesture {
              applyFiltersCallback()
              dismiss()
            }
        }
      }
    }
    .onChange(of: selectedOptions) { _ in
      updateSelectedCount()
    }
    .onChange(of: selectedExpiryOption) { _ in
      updateSelectedCount()
    }
    .onAppear {
      if selectesSorting.isEmpty {
        selectesSorting = LocalizableString.shared.get(with: .defaultLabel).capitalized
      }
      updateSelectedCount()
    }
    .onChange(of: sortAscending, perform: {  _ in
      showFilterIndicator.toggle()
    })
    .onDisappear {
      updateSelectedCount()
    }
  }

  private func expiryPeriodSection(section: FilterSections) -> some View {
    Section(header: Text(section.sectionTitle)) {
      ForEach(section.options, id: \.self) { expiry in
        ChoosableRow(
          text: expiry,
          isSelected: selectedExpiryOption == expiry
        ) {
          if selectedExpiryOption == expiry {
            selectedExpiryOption = ""
            selectedOptions.remove(expiry)
          } else {
            selectedExpiryOption = expiry
            selectedOptions.insert(expiry)
          }
          updateSelectedCount()
        }
      }
    }
  }

  private func stateSection(section: FilterSections) -> some View {
    Section(header: Text(section.sectionTitle)) {
      ForEach(section.options, id: \.self) { state in
        ChoosableRow(
          text: state,
          isSelected: stateOption == state
        ) {
          if stateOption == state {
            stateOption = ""
            selectedOptions.remove(state)
          } else {
            stateOption = state
            selectedOptions.insert(state)
          }
          updateSelectedCount()
        }
      }
    }
  }

  private func categorySection(section: FilterSections) -> some View {
    Section(header: Text(section.sectionTitle)) {
      if section.hasToggle {
        Toggle(LocalizableString.shared.get(with: .all).capitalized, isOn: Binding(
          get: {
            return section.options.allSatisfy { selectedOptions.contains($0) }
          },
          set: { newValue in
            if newValue {
              selectedOptions.formUnion(section.options)
            } else {
              selectedOptions.subtract(section.options)
            }
            updateSelectedCount()
          }
        ))
      }

      ForEach(section.options, id: \.self) { category in
        ChoosableRow(
          text: category,
          isSelected: selectedOptions.contains(category)
        ) {
          toggleCategorySelection(for: category, section: section)
        }
      }
    }
  }

  private func sortSection(section: FilterSections) -> some View {
    Section(header: Text(section.sectionTitle)) {
      ForEach(section.sorting, id: \.self) { option in
        ChoosableRow(
          text: option,
          isSelected: (option == LocalizableString.shared.get(with: .ascending).capitalized && sortAscending) || (option == LocalizableString.shared.get(with: .descending).capitalized && !sortAscending)
        ) {
          sortAscending = (option == LocalizableString.shared.get(with: .ascending).capitalized)
          updateSelectedCount()
        }
      }
    }
  }

  private func sortBySection(section: FilterSections) -> some View {
    Section(header: Text(section.sectionTitle)) {
      ForEach(section.options, id: \.self) { sortBy in
        ChoosableRow(
          text: sortBy,
          isSelected: selectesSorting == sortBy
        ) {
          if sortBy == LocalizableString.shared.get(with: .defaultLabel).capitalized {
            selectesSorting = LocalizableString.shared.get(with: .defaultLabel).capitalized
            selectedOptions = selectedOptions.filter { !section.options.contains($0) }
            showCounterRectangle = false
          } else {
            selectesSorting = sortBy
            selectedOptions.insert(sortBy)
            showCounterRectangle = true
          }
          updateSelectedCount()
        }
      }
    }
  }

  private func toggleCategorySelection(for category: String, section: FilterSections) {
    if selectedOptions.contains(category) {
      selectedOptions.remove(category)
    } else {
      selectedOptions.insert(category)
    }

    togglesState[section.sectionTitle] = selectedOptions.count == section.options.count
    updateSelectedCount()
  }

  private func resetFilters() {
    selectedOptions.removeAll()
    togglesState.removeAll()
    selectedExpiryOption = ""
    stateOption = ""
    sortAscending = true
    selectesSorting = LocalizableString.shared.get(with: .defaultLabel).capitalized
    updateSelectedCount()
  }

  private func updateSelectedCount() {
    filterCounter = selectedOptions.filter { $0 != LocalizableString.shared.get(with: .defaultLabel).capitalized }.count
    withAnimation {
      if filterCounter == 0 && selectesSorting == LocalizableString.shared.get(with: .defaultLabel).capitalized {
        showCounterRectangle = false
        showFilterIndicator = false
      } else {
        showCounterRectangle = true
        showFilterIndicator = true
      }
    }
  }
}

struct ChoosableRow: View {
  let text: String
  let isSelected: Bool
  let onTap: () -> Void

  var body: some View {
    HStack {
      Text(text)
        .typography(Theme.shared.font.bodyLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
      if isSelected {
        ThemeManager.shared.image.checkmark
          .foregroundColor(.blue)
      }
    }
    .contentShape(Rectangle())
    .onTapGesture(perform: onTap)
  }
}
