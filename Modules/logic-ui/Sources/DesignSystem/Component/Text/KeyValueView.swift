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
import Foundation
import logic_resources

public struct KeyValueView: View {

  enum Value {
    case string(LocalizableStringKey)
    case image(Image)
  }

  let title: LocalizableStringKey
  let value: Value
  let alignment: KeyValueView.Alignment
  let isLoading: Bool

  public init(
    title: LocalizableStringKey,
    subTitle: LocalizableStringKey,
    alignment: KeyValueView.Alignment = .start,
    isLoading: Bool = false
  ) {
    self.title = title
    self.value = .string(subTitle)
    self.alignment = alignment
    self.isLoading = isLoading
  }

  public init(
    title: LocalizableStringKey,
    image: Image,
    alignment: KeyValueView.Alignment = .start,
    isLoading: Bool = false
  ) {
    self.title = title
    self.value = .image(image)
    self.alignment = alignment
    self.isLoading = isLoading
  }

  public var body: some View {
    HStack {

      if alignment == .center || alignment == .end {
        Spacer()
      }

      VStack(alignment: .leading, spacing: SPACING_EXTRA_SMALL) {

        Text(title)
          .foregroundColor(Theme.shared.color.secondary)
          .typography(Theme.shared.font.bodyMedium)
          .if(isLoading) { view in
            view
              .lineLimit(1)
          }

        contentValue

        Spacer()

      }

      if alignment == .center || alignment == .start {
        Spacer()
      }
    }
    .shimmer(isLoading: self.isLoading)
  }

  @ViewBuilder
  private var contentValue: some View {
    switch value {
    case .string(let key):
      Text(key)
        .foregroundColor(Theme.shared.color.onSurface)
        .typography(Theme.shared.font.bodyLarge)
        .if(isLoading) { view in
          view
            .lineLimit(1)
        }
    case .image(let image):
      image
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(maxHeight: 50)
    }

  }
}

public extension KeyValueView {
  enum Alignment {
    case start
    case center
    case end
  }

  struct Model: Identifiable {
    public init(title: String, value: String) {
      self.id = UUID().uuidString
      self.title = title
      self.value = value
    }

    public var id: String
    public var title: String
    public var value: String
  }
}

#Preview {
  Group {
    KeyValueView(
      title: .yes,
      image: Image(systemName: "person"),
      alignment: .center,
      isLoading: false
    )

    KeyValueView(
      title: .yes,
      image: Image(systemName: "person"),
      alignment: .center,
      isLoading: false
    )
    .darkModePreview()

    KeyValueView(
      title: .yes,
      image: Image(systemName: "person"),
      alignment: .center,
      isLoading: true
    )
  }
}
