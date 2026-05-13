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
    NavigationStack {
      ScrollView {
        LazyVStack(spacing: SPACING_MEDIUM) {
          ForEach(sections) { section in
            filterSectionCard(
              sectionTitle: section.sectionTitle,
              sectionID: section.id,
              filters: section.filters
            )
          }
        }
        .padding(.horizontal, SPACING_MEDIUM)
        .padding(.vertical, SPACING_SMALL)
      }
      .scrollIndicators(.hidden)
      .background(Theme.shared.color.background)
      .navigationTitle(.filters)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            isApplied = true
            revertFilters()
            dismiss()
          } label: {
            Theme.shared.image.xmark
          }
          .accessibilityLabel(Text(.cancelButton))
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: applyFilters) {
            Theme.shared.image.checkmark
          }
          .buttonStyle(.borderedProminent)
          .accessibilityLabel(Text(.showResults))
        }
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
    .presentationDragIndicator(.visible)
  }

  @ViewBuilder
  private func filterSectionCard(
    sectionTitle: String,
    sectionID: String,
    filters: [FilterUIItem]
  ) -> some View {
    WrapCardView {
      VStack(alignment: .leading, spacing: .zero) {
        Text(sectionTitle)
          .typography(Theme.shared.font.labelLarge)
          .fontWeight(.semibold)
          .foregroundStyle(Theme.shared.color.onSurfaceVariant)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal, SPACING_MEDIUM)
          .padding(.top, SPACING_MEDIUM)

        ForEach(Array(filters.enumerated()), id: \.element.id) { index, filter in
          if index > 0 {
            ListDividerView(spacing: SPACING_LARGE)
          }
          filterRow(
            sectionID: sectionID,
            filter: filter
          )
          .padding(.horizontal, SPACING_LARGE)
          .padding(.vertical, SPACING_MEDIUM)
        }
      }
    }
  }

  @ViewBuilder
  private func filterRow(
    sectionID: String,
    filter: FilterUIItem
  ) -> some View {
    switch filter.filterSectionType {
    case .radio:
      HStack(alignment: .center, spacing: .zero) {
        Text(filter.title)
          .typography(Theme.shared.font.bodyLarge)
          .foregroundStyle(Theme.shared.color.onSurface)
          .multilineTextAlignment(.leading)
        Spacer(minLength: SPACING_MEDIUM)
        Toggle(
          "",
          isOn: Binding(
            get: { filter.selected },
            set: { newValue in
              guard newValue != filter.selected else { return }
              updateFiltersCallback?(sectionID, filter.id)
            }
          )
        )
        .labelsHidden()
        .tint(Color.green)
      }

    case .datePicker:
      VStack(alignment: .leading, spacing: SPACING_SMALL) {
        DatePicker(selection: $startDate, in: minStartDate...endDate, displayedComponents: .date) {
          Text(.startDate)
        }
        .tint(Theme.shared.color.primary)
        .onAppear {
          if let date = filter.startDate {
            startDate = date
          }
        }
        .onChange(of: startDate) {
          let expectedStartDate = filter.startDate ?? Date()
          if !Calendar.current.isDate(startDate, equalTo: expectedStartDate, toGranularity: .day) {
            showIndicator?()
          }
          updateDateFiltersCallback?(sectionID, filter.id, startDate, endDate)
        }
        .tint(Theme.shared.color.primary)

        DatePicker(selection: $endDate, in: startDate...maxEndDate, displayedComponents: .date) {
          Text(.endDate)
            .onAppear {
              if let date = filter.endDate {
                endDate = date
              }
            }
            .onChange(of: endDate) {
              let expectedStartDate = filter.endDate ?? Date()
              if !Calendar.current.isDate(startDate, equalTo: expectedStartDate, toGranularity: .day) {
                showIndicator?()
              }
              updateDateFiltersCallback?(sectionID, filter.id, startDate, endDate)
            }
        }
        .tint(Theme.shared.color.primary)
      }
    }
  }

  private func applyFilters() {
    isApplied = true
    applyFiltersAction()
    dismiss()
  }
}
