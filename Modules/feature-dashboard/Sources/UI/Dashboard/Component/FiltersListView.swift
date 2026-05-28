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
  @State private var initialStartDate: Date?
  @State private var initialEndDate: Date?

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

        let computedStartDate = availableDates.compactMap { $0.0 }.min() ?? minStartDate
        let computedEndDate = availableDates.compactMap { $0.1 }.max() ?? maxEndDate

        startDate = computedStartDate
        endDate = computedEndDate

        initialStartDate = initialStartDate ?? computedStartDate
        initialEndDate = initialEndDate ?? computedEndDate
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
          .foregroundStyle(Theme.shared.color.secondaryLabel)
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
      Toggle(
        isOn: Binding(
          get: { filter.selected },
          set: { newValue in
            guard newValue != filter.selected else { return }
            updateFiltersCallback?(sectionID, filter.id)
          }
        )
      ) {
        Text(filter.title)
          .typography(Theme.shared.font.bodyLarge)
          .foregroundStyle(Theme.shared.color.primaryLabel)
          .multilineTextAlignment(.leading)
      }
      .tint(Color.green)

    case .datePicker:
      VStack(alignment: .leading, spacing: .zero) {
        datePickerRow(
          title: .startDate,
          selection: $startDate,
          range: minStartDate...endDate,
          sectionID: sectionID,
          filter: filter
        )

        ListDividerView(spacing: 0)
          .padding(.vertical, SPACING_MEDIUM)

        datePickerRow(
          title: .endDate,
          selection: $endDate,
          range: startDate...maxEndDate,
          sectionID: sectionID,
          filter: filter
        )

        Button {
          resetDates(sectionID: sectionID, filter: filter)
        } label: {
          Text(.resetDates)
            .typography(Theme.shared.font.bodyLarge)
            .foregroundStyle(Theme.shared.color.accent)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .buttonStyle(.plain)
        .padding(.top, SPACING_MEDIUM)
      }
      .onAppear {
        if let date = filter.startDate {
          startDate = date
          initialStartDate = initialStartDate ?? date
        }
        if let date = filter.endDate {
          endDate = date
          initialEndDate = initialEndDate ?? date
        }
      }
    }
  }

  @ViewBuilder
  private func datePickerRow(
    title: LocalizableStringKey,
    selection: Binding<Date>,
    range: ClosedRange<Date>,
    sectionID: String,
    filter: FilterUIItem
  ) -> some View {
    HStack(alignment: .center, spacing: SPACING_MEDIUM) {
      Text(title)
        .typography(Theme.shared.font.bodyLarge)
        .foregroundStyle(Theme.shared.color.primaryLabel)

      Spacer(minLength: SPACING_MEDIUM)

      DatePicker(
        "",
        selection: selection,
        in: range,
        displayedComponents: .date
      )
      .labelsHidden()
      .datePickerStyle(.compact)
      .tint(Theme.shared.color.accent)
      .foregroundStyle(Theme.shared.color.accent)
    }
    .onChange(of: selection.wrappedValue) {
      let baselineDate = title == .startDate ? initialStartDate : initialEndDate
      if let baselineDate,
         !Calendar.current.isDate(selection.wrappedValue, equalTo: baselineDate, toGranularity: .day) {
        showIndicator?()
      }
      updateDateFiltersCallback?(sectionID, filter.id, startDate, endDate)
    }
  }

  private func resetDates(sectionID: String, filter: FilterUIItem) {
    startDate = minStartDate
    endDate = maxEndDate
    if let initialStartDate,
       !Calendar.current.isDate(startDate, equalTo: initialStartDate, toGranularity: .day) {
      showIndicator?()
    } else if let initialEndDate,
              !Calendar.current.isDate(endDate, equalTo: initialEndDate, toGranularity: .day) {
      showIndicator?()
    }
    updateDateFiltersCallback?(sectionID, filter.id, startDate, endDate)
  }

  private func applyFilters() {
    isApplied = true
    applyFiltersAction()
    dismiss()
  }
}
