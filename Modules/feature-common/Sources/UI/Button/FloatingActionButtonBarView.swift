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

public struct FloatingActionButtonBarView: View {

  @Environment(\.colorScheme) var colorScheme

  public let isLoading: Bool
  public let backgroundColor: Color
  public let edgeInsets: EdgeInsets
  public let addAction: () -> Void
  public let shareAction: () -> Void

  public init(
    isLoading: Bool = false,
    backgroundColor: Color = .clear,
    edgeInsets: EdgeInsets = .init(),
    addAction: @escaping @autoclosure () -> Void,
    shareAction: @escaping @autoclosure () -> Void
  ) {
    self.isLoading = isLoading
    self.backgroundColor = backgroundColor
    self.edgeInsets = edgeInsets
    self.addAction = addAction
    self.shareAction = shareAction
  }

  public var body: some View {
    HStack(spacing: SPACING_MEDIUM) {

      FloatingActionButtonView(
        title: .addDoc,
        textColor: Theme.shared.color.textPrimaryDark,
        backgroundColor: colorScheme == .dark
        ? Theme.shared.color.backgroundDefault
        : Theme.shared.color.backgroundPaper,
        icon: Theme.shared.image.plus,
        iconColor: Theme.shared.color.textPrimaryDark,
        isLoading: isLoading,
        action: addAction
      )

      FloatingActionButtonView(
        title: .showQRTap,
        textColor: Theme.shared.color.white,
        backgroundColor: Theme.shared.color.primary,
        icon: Theme.shared.image.share,
        iconColor: Theme.shared.color.white,
        isLoading: isLoading,
        action: shareAction
      )

    }
    .padding(edgeInsets)
    .frame(maxWidth: .infinity)
    .background(backgroundColor)
  }
}

#Preview {
  FloatingActionButtonBarView(
    isLoading: false,
    addAction: {}(),
    shareAction: {}()
  )
}
