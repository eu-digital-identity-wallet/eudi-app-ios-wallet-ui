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

public struct BlurProgressView: View {

  let height: CGFloat
  let width: CGFloat

  public init(height: CGFloat = 72, width: CGFloat = 72) {
    self.width = width
    self.height = height
  }

  public var body: some View {
    ZStack {
      ContentLoaderView(
        showLoader: .constant(true),
        width: self.width,
        height: self.height
      )
      .padding([.horizontal, .vertical], 10)
    }
    .background(Blur(style: .regular).cornerRadius(12))
  }
}

extension BlurProgressView {
  struct Blur: UIViewRepresentable {

    var style: UIBlurEffect.Style = .systemMaterial

    func makeUIView(context: Context) -> UIVisualEffectView {
      return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
      uiView.effect = UIBlurEffect(style: style)
    }
  }
}

#Preview {
  Group {
    BlurProgressView().lightModePreview()
    BlurProgressView().darkModePreview()
  }
}
