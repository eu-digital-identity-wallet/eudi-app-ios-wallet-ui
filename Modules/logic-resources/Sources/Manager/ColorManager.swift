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
import UIKit

public protocol ColorManagerProtocol: Sendable {

  // MARK: - System palette (SwiftUI)

  var blue: Color { get }
  var green: Color { get }
  var indigo: Color { get }
  var orange: Color { get }
  var pink: Color { get }
  var purple: Color { get }
  var red: Color { get }
  var teal: Color { get }
  var yellow: Color { get }
  var mint: Color { get }
  var cyan: Color { get }
  var brown: Color { get }
  var black: Color { get }
  var white: Color { get }
  var gray: Color { get }

  // MARK: - Brand

  var success: Color { get }
  var successBackground: Color { get }
  var pending: Color { get }
  var warning: Color { get }
  var groupedBackground: Color { get }
  var groupedElevatedBackground: Color { get }
  var separator: Color { get }

  // MARK: - Semantic (UIKit)

  var primaryLabel: Color { get }
  var secondaryLabel: Color { get }
  var tertiaryLabel: Color { get }
  var quaternaryLabel: Color { get }
  var background: Color { get }
  var secondaryBackground: Color { get }
  var tertiaryBackground: Color { get }
  var secondaryGroupedBackground: Color { get }
  var tertiaryGroupedBackground: Color { get }
  var opaqueSeparator: Color { get }
  var fill: Color { get }
  var secondaryFill: Color { get }
  var tertiaryFill: Color { get }
  var quaternaryFill: Color { get }
  var accent: Color { get }
}

final class ColorManager: ColorManagerProtocol {

  let bundle: Bundle

  enum SystemColors: String, CaseIterable {
    case blue
    case green
    case indigo
    case orange
    case pink
    case purple
    case red
    case teal
    case yellow
    case mint
    case cyan
    case brown
    case black
    case white
    case gray
  }

  enum BrandColors: String, CaseIterable {
    case success
    case successBackground
    case pending
    case warning
    case groupedBackground
    case groupedElevatedBackground
    case separator
  }

  enum SemanticColors: String, CaseIterable {
    case primaryLabel
    case secondaryLabel
    case tertiaryLabel
    case quaternaryLabel
    case background
    case secondaryBackground
    case tertiaryBackground
    case secondaryGroupedBackground
    case tertiaryGroupedBackground
    case opaqueSeparator
    case fill
    case secondaryFill
    case tertiaryFill
    case quaternaryFill
    case accent
  }

  // MARK: - System palette

  public var blue: Color { color(for: .blue) }
  public var green: Color { color(for: .green) }
  public var indigo: Color { color(for: .indigo) }
  public var orange: Color { color(for: .orange) }
  public var pink: Color { color(for: .pink) }
  public var purple: Color { color(for: .purple) }
  public var red: Color { color(for: .red) }
  public var teal: Color { color(for: .teal) }
  public var yellow: Color { color(for: .yellow) }
  public var mint: Color { color(for: .mint) }
  public var cyan: Color { color(for: .cyan) }
  public var brown: Color { color(for: .brown) }
  public var black: Color { color(for: .black) }
  public var white: Color { color(for: .white) }
  public var gray: Color { color(for: .gray) }

  // MARK: - Brand

  public var success: Color { color(for: .success) }
  public var successBackground: Color { color(for: .successBackground) }
  public var pending: Color { color(for: .pending) }
  public var warning: Color { color(for: .warning) }
  public var groupedBackground: Color { color(for: .groupedBackground) }
  public var groupedElevatedBackground: Color { color(for: .groupedElevatedBackground) }
  public var separator: Color { color(for: .separator) }

  // MARK: - Semantic

  public var primaryLabel: Color { color(for: .primaryLabel) }
  public var secondaryLabel: Color { color(for: .secondaryLabel) }
  public var tertiaryLabel: Color { color(for: .tertiaryLabel) }
  public var quaternaryLabel: Color { color(for: .quaternaryLabel) }
  public var background: Color { color(for: .background) }
  public var secondaryBackground: Color { color(for: .secondaryBackground) }
  public var tertiaryBackground: Color { color(for: .tertiaryBackground) }
  public var secondaryGroupedBackground: Color { color(for: .secondaryGroupedBackground) }
  public var tertiaryGroupedBackground: Color { color(for: .tertiaryGroupedBackground) }
  public var opaqueSeparator: Color { color(for: .opaqueSeparator) }
  public var fill: Color { color(for: .fill) }
  public var secondaryFill: Color { color(for: .secondaryFill) }
  public var tertiaryFill: Color { color(for: .tertiaryFill) }
  public var quaternaryFill: Color { color(for: .quaternaryFill) }
  public var accent: Color { color(for: .accent) }

  // MARK: - Lifecycle

  init(bundle: Bundle = .assetsBundle) {
    self.bundle = bundle
  }

  // MARK: - Resolution

  private func uiColor(_ color: UIColor) -> Color {
    Color(uiColor: color)
  }

  func color(for system: SystemColors) -> Color {
    switch system {
    case .blue: .blue
    case .green: .green
    case .indigo: .indigo
    case .orange: .orange
    case .pink: .pink
    case .purple: .purple
    case .red: .red
    case .teal: .teal
    case .yellow: .yellow
    case .mint: .mint
    case .cyan: .cyan
    case .brown: .brown
    case .black: .black
    case .white: .white
    case .gray: .gray
    }
  }

  func color(for brand: BrandColors) -> Color {
    Color(brand.rawValue, bundle: bundle)
  }

  func color(for semantic: SemanticColors) -> Color {
    switch semantic {
    case .primaryLabel: uiColor(.label)
    case .secondaryLabel: uiColor(.secondaryLabel)
    case .tertiaryLabel: uiColor(.tertiaryLabel)
    case .quaternaryLabel: uiColor(.quaternaryLabel)
    case .background: uiColor(.systemBackground)
    case .secondaryBackground: uiColor(.secondarySystemBackground)
    case .tertiaryBackground: uiColor(.tertiarySystemBackground)
    case .secondaryGroupedBackground: uiColor(.secondarySystemGroupedBackground)
    case .tertiaryGroupedBackground: uiColor(.tertiarySystemGroupedBackground)
    case .opaqueSeparator: uiColor(.opaqueSeparator)
    case .fill: uiColor(.systemFill)
    case .secondaryFill: uiColor(.secondarySystemFill)
    case .tertiaryFill: uiColor(.tertiarySystemFill)
    case .quaternaryFill: uiColor(.quaternarySystemFill)
    case .accent: uiColor(.systemBlue)
    }
  }
}

struct ColorDescr: Identifiable {
  var id = UUID()
  var color: Color
  var description: String
}

struct ColorsPreview: View {
  private let colorManager = ColorManager(bundle: .assetsBundle)

  func systemColors() -> [ColorDescr] {
    ColorManager.SystemColors.allCases.map { colorEnum in
      ColorDescr(
        color: colorManager.color(for: colorEnum),
        description: colorEnum.rawValue
      )
    }
  }

  func brandColors() -> [ColorDescr] {
    ColorManager.BrandColors.allCases.map { colorEnum in
      ColorDescr(
        color: colorManager.color(for: colorEnum),
        description: colorEnum.rawValue
      )
    }
  }

  func semanticColors() -> [ColorDescr] {
    ColorManager.SemanticColors.allCases.map { colorEnum in
      ColorDescr(
        color: colorManager.color(for: colorEnum),
        description: colorEnum.rawValue
      )
    }
  }

  var body: some View {
    ScrollView {
      VStack {
        Text("System colors")
          .font(.title)
        ForEach(systemColors()) { item in
          ZStack {
            item.color
            Text(item.description).foregroundColor(Color.black)
          }
        }
        Text("Brand colors")
          .font(.title)
        ForEach(brandColors()) { item in
          ZStack {
            item.color
            Text(item.description).foregroundColor(Color.black)
          }
        }
        Text("Semantic colors")
          .font(.title)
        ForEach(semanticColors()) { item in
          ZStack {
            item.color
            Text(item.description).foregroundColor(Color.black)
          }
        }
      }
    }
  }
}

#Preview {
  ColorsPreview()
}
