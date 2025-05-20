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
import logic_resources

public struct ListDividerView: View {

  private let backgroundColor: Color
  private let height: CGFloat
  private let spacing: CGFloat

  public init(
    backgroundColor: Color = Theme.shared.color.onSurfaceVariant.opacity(0.2),
    height: CGFloat = 1,
    spacing: CGFloat = SPACING_MEDIUM
  ) {
    self.backgroundColor = backgroundColor
    self.height = height
    self.spacing = spacing
  }

  public var body: some View {
    Rectangle()
      .fill(backgroundColor)
      .frame(height: height)
      .padding(.horizontal, spacing)
  }
}

#Preview {
  ListDividerView()
}
