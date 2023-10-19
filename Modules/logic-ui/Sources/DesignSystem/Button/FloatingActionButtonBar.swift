/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import SwiftUI
import logic_resources

public struct FloatingActionButtonBar: View {

  public let isAddEnabled: Bool
  public let isLoading: Bool
  public let addAction: () -> Void
  public let shareAction: () -> Void

  public init(
    isAddEnabled: Bool,
    isLoading: Bool = false,
    addAction: @escaping () -> Void,
    shareAction: @escaping () -> Void
  ) {
    self.isAddEnabled = isAddEnabled
    self.isLoading = isLoading
    self.addAction = addAction
    self.shareAction = shareAction
  }

  public var body: some View {
    VStack(alignment: .center) {
      HStack(spacing: SPACING_MEDIUM) {
        FloatingActionButton(
          title: .addDoc,
          textColor: isAddEnabled ? Theme.shared.color.primaryDark : Theme.shared.color.textDisabledDark,
          backgroundColor: isAddEnabled ? Theme.shared.color.backgroundPaper : Theme.shared.color.grey,
          icon: Theme.shared.image.plus,
          iconColor: isAddEnabled ? Theme.shared.color.textPrimaryDark : Theme.shared.color.textDisabledDark,
          isLoading: isLoading,
          action: addAction
        )
        .disabled(!isAddEnabled)

        FloatingActionButton(
          title: .showQRTap,
          textColor: Theme.shared.color.textPrimaryDark,
          backgroundColor: Theme.shared.color.secondary,
          icon: Theme.shared.image.share,
          iconColor: Theme.shared.color.textPrimaryDark,
          isLoading: isLoading,
          action: shareAction
        )

      }
      .frame(maxWidth: .infinity)
    }
  }
}
