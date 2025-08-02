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
import logic_ui
import logic_resources

struct FiltersListView: View {

  @Environment(\.dismiss) var dismiss

  @State private var isApplied: Bool = false
  @State private var startDate: Date
  @State private var endDate: Date

  private let minStartDate: Date
  private let maxEndDate: Date

  private var resetFiltersAction: () -> Void
  private var applyFiltersAction: () -> Void
  private var showIndicator: (() -> Void)?
  private var updateFiltersCallback: ((String, String) -> Void)?
  private var updateDateFiltersCallback: ((String, String, Date, Date) -> Void)?
  private var revertFilters: () -> Void

  private let sections: [FilterUISection]

  init(
    sections: [FilterUISection],
    minStartDate: Date? = nil,
    maxEndDate: Date? = nil,
    resetFiltersAction: @escaping () -> Void,
    applyFiltersAction: @escaping () -> Void,
    showIndicator: (() -> Void)? = nil,
    revertFilters: @escaping () -> Void,
    updateFiltersCallback: ((String, String) -> Void)?,
    updateDateFiltersCallback: ((String, String, Date, Date) -> Void)? = nil
  ) {
    self.sections = sections
    self.resetFiltersAction = resetFiltersAction
    self.applyFiltersAction = applyFiltersAction
    self.showIndicator = showIndicator
    self.updateFiltersCallback = updateFiltersCallback
    self.updateDateFiltersCallback = updateDateFiltersCallback
    self.revertFilters = revertFilters
    self.minStartDate = minStartDate ?? Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
    self.maxEndDate = maxEndDate ?? Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()
    self.startDate = minStartDate ?? Date()
    self.endDate = maxEndDate ?? Date()
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
      .onAppear {
        let availableDates = sections.flatMap { $0.filters }
          .compactMap { ($0.startDate, $0.endDate) }

        startDate = availableDates.compactMap { $0.0 }.min() ?? minStartDate
        endDate = availableDates.compactMap { $0.1 }.max() ?? maxEndDate
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
        if filters[index].filterSectionType == .radio {
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
        } else if filters[index].filterSectionType == .datePicker {

          DatePicker(selection: $startDate, in: minStartDate...endDate, displayedComponents: .date) {
            Text(.startDate)
          }
          .onAppear {
            if let date = filters[index].startDate {
              startDate = date
            }
          }
          .onChange(of: startDate) { newDate in
            startDate = newDate
            let expectedStartDate = filters[index].startDate ?? Date()
            if !Calendar.current.isDate(startDate, equalTo: expectedStartDate, toGranularity: .day) {
              showIndicator?()
            }
            updateDateFiltersCallback?(sectionID, filters[index].id, newDate, endDate)
          }

          DatePicker(selection: $endDate, in: startDate...maxEndDate, displayedComponents: .date) {
            Text(.endDate)
              .onAppear {
                if let date = filters[index].endDate {
                  endDate = date
                }
              }
              .onChange(of: endDate) { newDate in
                endDate = newDate
                let expectedStartDate = filters[index].endDate ?? Date()
                if !Calendar.current.isDate(startDate, equalTo: expectedStartDate, toGranularity: .day) {
                  showIndicator?()
                }
                updateDateFiltersCallback?(sectionID, filters[index].id, startDate, newDate)
              }
          }
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
