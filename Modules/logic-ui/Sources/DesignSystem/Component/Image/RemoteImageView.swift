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

public struct RemoteImageView: View {

  let url: URL?
  let icon: Image?
  let size: CGSize

  public init(
    url: URL?,
    icon: Image?,
    size: CGSize = .init(
      width: 50.0,
      height: 50.0
    )
  ) {
    self.url = url
    self.icon = icon
    self.size = size
  }

  public var body: some View {
    AsyncImage(
      url: url
    ) { image in
     image
        .resizable()
        .scaledToFit()
        .frame(
          width: icon == nil ? .zero : size.width,
          height: icon == nil ? .zero : size.height
        )
    } placeholder: {
      if let placeholder = icon {
        placeholder
          .resizable()
          .scaledToFit()
          .frame(
            width: icon == nil ? .zero : size.width,
            height: icon == nil ? .zero : size.height
          )
      }
    }
    .frame(height: icon == nil ? .zero : size.height)
  }
}

public extension RemoteImageView {
  enum ImageContentOption {
    case none
    case remoteImage(URL?, Image?)
    case image(Image)

    public var isNone: Bool {
      switch self {
      case .none:
        return true
      default:
        return false
      }
    }
  }
}
