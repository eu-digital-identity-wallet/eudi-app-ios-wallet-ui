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
import logic_resources

public struct WarningAcknowledgementView: View {
  private let message: LocalizableStringKey
  private let acknowledgementText: LocalizableStringKey
  @Binding private var isAcknowledged: Bool

  private var accentColor: Color {
    Theme.shared.color.red
  }
  private var backgroundOpacity: Double { 0.2 }
  private var iconSize: Double { 20 }
  private var foregroundColor: Color {
    Theme.shared.color.primaryLabel
  }

  public init(
    message: LocalizableStringKey,
    acknowledgementText: LocalizableStringKey = .understandRisksAgree,
    isAcknowledged: Binding<Bool>
  ) {
    self.message = message
    self.acknowledgementText = acknowledgementText
    self._isAcknowledged = isAcknowledged
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: SPACING_MEDIUM) {
      HStack(alignment: .center, spacing: SPACING_SMALL) {
        Theme.shared.image.exclamationmarkTriangleFill
          .renderingMode(.template)
          .resizable()
          .scaledToFit()
          .frame(width: iconSize, height: iconSize)
          .foregroundColor(accentColor)

        Text(message)
          .typography(Theme.shared.font.bodyMedium)
          .foregroundColor(foregroundColor)
          .multilineTextAlignment(.leading)
          .fixedSize(horizontal: false, vertical: true)
          .frame(maxWidth: .infinity, alignment: .leading)
      }

      Divider()

      Toggle(isOn: $isAcknowledged) {
        Text(acknowledgementText)
          .typography(Theme.shared.font.bodyMedium)
          .foregroundColor(foregroundColor)
          .multilineTextAlignment(.leading)
          .fixedSize(horizontal: false, vertical: true)
      }
      .padding(.leading, iconSize + SPACING_SMALL)
    }
    .padding(SPACING_MEDIUM)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(accentColor.opacity(backgroundOpacity))
    .clipShape(RoundedRectangle(cornerRadius: SPACING_SMALL))
  }
}

#Preview("Off") {
  StatefulPreviewWrapper(false) { isOn in
    WarningAcknowledgementView(
      message: .relyingPartyNotVerifiedWarning,
      isAcknowledged: isOn
    )
    .padding()
  }
}

#Preview("On") {
  StatefulPreviewWrapper(true) { isOn in
    WarningAcknowledgementView(
      message: .custom(
        "Warning: Some of the requested data are not registered with this interacting party. Review carefully before sharing your data."
      ),
      isAcknowledged: isOn
    )
    .padding()
  }
}

private struct StatefulPreviewWrapper<Content: View>: View {
  @State private var value: Bool
  private let content: (Binding<Bool>) -> Content

  init(_ initialValue: Bool, @ViewBuilder content: @escaping (Binding<Bool>) -> Content) {
    self._value = State(initialValue: initialValue)
    self.content = content
  }

  var body: some View {
    content($value)
  }
}
