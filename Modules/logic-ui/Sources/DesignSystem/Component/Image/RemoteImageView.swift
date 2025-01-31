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
import CachedAsyncImage
import logic_resources

public struct RemoteImageView: View {

  let url: URL?
  let icon: Image?
  let width: Double?
  let height: Double?

  private var getWidth: Double {
    guard let width = self.width else { return .infinity }
    return width
  }

  private var getHeight: Double {
    guard let height = self.height else { return .infinity }
    return height
  }

  public init(
    url: URL?,
    icon: Image?,
    width: Double?,
    height: Double?
  ) {
    self.url = url
    self.icon = icon
    self.width = width
    self.height = height
  }

  public var body: some View {
    CachedAsyncImage(url: url) { phase in
      switch phase {
      case .success(let image):
        image
          .resizable()
          .scaledToFit()
      case .failure:
        if let placeholder = icon {
          placeholder
            .resizable()
            .scaledToFit()
        }
      default:
        ProgressView()
          .tint(Theme.shared.color.primary)
      }
    }
    .if(url != nil || icon != nil) { view in
      view.frame(
        maxWidth: self.getWidth,
        maxHeight: self.getHeight
      )
    }
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
