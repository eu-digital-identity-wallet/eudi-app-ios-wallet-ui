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
  @State private var pendingSortAscending: Bool = true
  @State private var hasSortChanged: Bool = false
  @State private var hasChangesInSort: Bool = false
  @State private var hasChangesInIssuer: Bool = false
  @State private var listHasFiltered: Bool = false
  @State private var hasChangesInExpiry: Bool = false

  @Binding var sortAscending: Bool
  @Binding var showFilterIndicator: Bool
  @Binding var selectedOptions: Set<String>
  @Binding var selectedExpiryOption: String
  @Binding var selectesSorting: String
  @Binding var stateOption: String

  var applyFiltersCallback: () -> Void
  var resetFiltersCallback: () -> Void

  let sections: [FilterSections]

  var onResume: () -> Void

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
            issuerSection(section: section)
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
          .disabled(!showFilterIndicator)
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
              listHasFiltered = true
              sortAscending = pendingSortAscending
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
      pendingSortAscending = sortAscending

      if selectesSorting.isEmpty {
        selectesSorting = LocalizableString.shared.get(with: .defaultLabel).capitalized
      }

      for section in sections {
        selectedOptions.formUnion(section.options)
      }

      updateSelectedCount()
      updateResetButtonState()
    }
    .onChange(of: sortAscending, perform: {  _ in
      showFilterIndicator.toggle()
    })
    .onDisappear {
      updateSelectedCount()

      if isDefaultState() {
        showFilterIndicator = false
      }

      onResume()
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
          hasChangesInExpiry = true
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

  private func issuerSection(section: FilterSections) -> some View {
    Section(header: Text(section.sectionTitle)) {
      if section.hasToggle {
        Toggle(LocalizableString.shared.get(with: .all).capitalized, isOn: Binding(
          get: {
            section.options.allSatisfy { selectedOptions.contains($0) }
          },
          set: { newValue in
            if newValue {
              selectedOptions.formUnion(section.options)
            } else {
              selectedOptions.subtract(section.options)
            }
            hasChangesInIssuer = true
            showFilterIndicator = true
            updateSelectedCount()
          }
        ))
      }

      ForEach(section.options, id: \.self) { issuer in
        ChoosableRow(
          text: issuer,
          isSelected: selectedOptions.contains(issuer)
        ) {
          toggleIssuerSelection(for: issuer, section: section)
          hasChangesInIssuer = true
          showFilterIndicator = true
        }
      }
    }
  }

  private func sortSection(section: FilterSections) -> some View {
    Section(header: Text(section.sectionTitle)) {
      ForEach(section.sorting, id: \.self) { option in
        ChoosableRow(
          text: option,
          isSelected: (option == LocalizableString.shared.get(with: .ascending).capitalized && pendingSortAscending) ||
          (option == LocalizableString.shared.get(with: .descending).capitalized && !pendingSortAscending)
        ) {
          pendingSortAscending = (option == LocalizableString.shared.get(with: .ascending).capitalized)
          hasSortChanged = true
          showFilterIndicator = true
          showCounterRectangle = true
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
          hasChangesInSort = true
          updateSelectedCount()
        }
      }
    }
  }

  private func toggleIssuerSelection(for issuer: String, section: FilterSections) {
    if selectedOptions.contains(issuer) {
      selectedOptions.remove(issuer)
    } else {
      selectedOptions.insert(issuer)
    }

    togglesState[section.sectionTitle] = selectedOptions.count == section.options.count
    updateSelectedCount()
  }

  private func isDefaultState() -> Bool {
    let allOptions = sections.flatMap { $0.options }
    let isAllOptionsSelected = allOptions.allSatisfy { selectedOptions.contains($0) }
    let isSortAscendingDefault = sortAscending == true
    let isSelectedSortingDefault = selectesSorting == LocalizableString.shared.get(with: .defaultLabel).capitalized
    let isExpiryOptionDefault = selectedExpiryOption.isEmpty
    let isStateOptionDefault = stateOption.isEmpty

    return isAllOptionsSelected && isSortAscendingDefault && isSelectedSortingDefault && isExpiryOptionDefault && isStateOptionDefault
  }

  private func resetFilters() {
    selectedOptions.removeAll()
    togglesState.removeAll()
    selectedExpiryOption = ""
    stateOption = ""
    sortAscending = true
    pendingSortAscending = sortAscending
    selectesSorting = LocalizableString.shared.get(with: .defaultLabel).capitalized

    for section in sections {
      selectedOptions.formUnion(section.options)
    }

    hasSortChanged = false
    hasChangesInIssuer = false
    hasChangesInExpiry = false

    updateSelectedCount()

    DispatchQueue.main.async {
      self.updateResetButtonState()
    }
  }

  private func updateResetButtonState() {
    showFilterIndicator = shouldEnableResetButton()
  }

  private func updateSelectedCount() {
    let allOptions = sections.flatMap { $0.options }

    let filteredOptions = selectedOptions.filter { !allOptions.contains($0) }

    filterCounter = filteredOptions.count

    let hasExpirySelected = !selectedExpiryOption.isEmpty
    let hasStateSelected = !stateOption.isEmpty

    let isToggleInactive = !allOptions.allSatisfy { selectedOptions.contains($0) }

    withAnimation {
      if filterCounter == 0 &&
          selectesSorting == LocalizableString.shared.get(with: .defaultLabel).capitalized &&
          !hasExpirySelected &&
          !hasStateSelected &&
          !isToggleInactive {
        showCounterRectangle = false
        showFilterIndicator = false
      } else {
        showCounterRectangle = true
        showFilterIndicator = true
      }
    }
  }

  private func shouldEnableResetButton() -> Bool {
    let isSortingNotAscending = !sortAscending
    let isSortingNotDefault = selectesSorting != LocalizableString.shared.get(with: .defaultLabel).capitalized
    let isToggleInactive = !sections.allSatisfy { section in
      section.options.allSatisfy { selectedOptions.contains($0) }
    }
    let isCategoriesNotAllSelected = !sections.allSatisfy { section in
      section.options.count == selectedOptions.filter { section.options.contains($0) }.count
    }

    return isSortingNotAscending || isSortingNotDefault || isToggleInactive || isCategoriesNotAllSelected
  }
}
