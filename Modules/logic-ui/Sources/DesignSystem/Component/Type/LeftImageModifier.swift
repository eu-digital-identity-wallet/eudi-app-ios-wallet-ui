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

private struct LeftImageModifier: ViewModifier {
  private let image: Image
  private let size: CGFloat?
  private let spacing: CGFloat

  init(
    image: Image,
    spacing: CGFloat,
    size: CGFloat? = nil
  ) {
    self.image = image
    self.spacing = spacing
    self.size = size
  }

  func body(content: Content) -> some View {
    HStack(alignment: .center, spacing: spacing) {
      if let size {
        image
          .resizable()
          .frame(width: size, height: size)
      } else {
        image
      }

      content
    }
  }
}

public extension View {
  func leftImage(image: Image, spacing: CGFloat = 0, size: CGFloat? = nil) -> some View {
    modifier(LeftImageModifier(image: image, spacing: spacing, size: size))
  }
}

#Preview {
  Text("Title")
    .leftImage(image: Image(systemName: "calendar"))

  Text("Please review carefully before sharing your data.")
    .leftImage(image: Image(systemName: "calendar"))
}
