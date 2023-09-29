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

public struct NoContentView: View {

  private let title: LocalizedStringKey
  private let imageName: String
  private let onClick: (() -> Void)?

  public init(
    title: LocalizedStringKey,
    imageName: String = "exclamationmark.circle",
    onClick: (() -> Void)? = nil
  ) {
    self.title = title
    self.imageName = imageName
    self.onClick = onClick
  }

  public var body: some View {
    VStack(alignment: .center, spacing: SPACING_MEDIUM) {

      Image(systemName: imageName)
        .resizable()
        .scaledToFit()
        .foregroundColor(Theme.shared.color.onSurface)
        .frame(height: 50)

      Text(title)
        .foregroundColor(Theme.shared.color.onSurface)
    }
    .onTapGesture {
      onClick?()
    }
  }
}
