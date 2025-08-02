/*
 * Copyright (c) 2025 European Commission
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
import AlertToast
import PartialSheet
import Shimmer

private let shimmeringGradient = Gradient(
  colors: [
    .black.opacity(0.5),
    .black,
    .black.opacity(0.5)
  ]
)

public extension View {
  /// Adds an animated shimmering effect to any view, typically to show that
  /// an operation is in progress.
  /// - Parameters:
  ///   - isLoading: Convenience parameter to conditionally enable the effect. Defaults to `true`.
  @ViewBuilder func shimmer(
    isLoading: Bool = true
  ) -> some View {
    if isLoading {
      self.redacted(reason: .placeholder)
        .shimmering(gradient: shimmeringGradient)
    } else {
      self
    }
  }
}

public extension View {
  func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCornerShape(radius: radius, corners: corners) )
  }
}

public extension View {
  func eraseToAnyView() -> AnyView {
    return AnyView(self)
  }
}

public extension View {
  @ViewBuilder func `if`<Content: View>(
    _ condition: Bool,
    transform: (Self) -> Content
  ) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }

  func gone(if shouldHide: Bool) -> some View {
      shouldHide ? AnyView(EmptyView()) : AnyView(self)
  }
}

public extension View {
  func getScreenRect() -> CGRect {
    return UIScreen.main.bounds
  }
}

public extension View {
  func onError(show: Binding<Bool>, message: String) -> some View {
    return self
      .toast(
        isPresenting: show,
        alert: {
          AlertToast(
            displayMode: .alert,
            type: .regular,
            title: message,
            style: .style(
              backgroundColor: .red,
              titleColor: .white,
              titleFont: .body
            )
          )
        }
      )
  }
}

public extension View {
  func hideKeyboard() {
    UIApplication.shared.hideKeyboard()
  }
  func onHideKeyboard() -> some View {
    UIApplication.shared.hideKeyboard()
    return self
  }
}

public extension View {
  func onAppearDelayed(
    delay: Int = 250,
    onAppear: @escaping () -> Void
  ) -> some View {
    return self
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) {
          onAppear()
        }
      }
  }
}

public extension View {
  func sheetDialog<Content: View>(isPresented: Binding<Bool>, @ViewBuilder _ content: @escaping () -> Content) -> some View {
    return self.partialSheet(
      isPresented: isPresented,
      iPhoneStyle: SheetStyle.iphoneSheetStyle,
      iPadMacStyle: SheetStyle.IpadMacSheetStyle,
      content: { ContentSheetView(content: content) }
    )
  }
}

public extension View {
  func bottomFade() -> some View {
    return self.mask(
      LinearGradient(
        gradient: Gradient(
          stops: [
            .init(color: .clear, location: 0),
            .init(color: .black, location: 0),
            .init(color: .black, location: 0.85),
            .init(color: .clear, location: 1)
          ]
        ),
        startPoint: .top,
        endPoint: .bottom
      )
    )
  }
}

public extension View {

  func viewDidLoad(action: @escaping () -> Void) -> some View {
    self
      .modifier(ViewDidLoadModifier(action: action))
  }

  func viewDidLoadAsync(action: @escaping () async -> Void) -> some View {
    self
      .modifier(ViewDidLoadAsyncModifier(action: action))
  }
}

struct ViewDidLoadModifier: ViewModifier {
  @State private var viewDidLoad = false
  let action: (() -> Void)?

  func body(content: Content) -> some View {
    content
      .onAppear {
        if viewDidLoad == false {
          viewDidLoad = true
          action?()
        }
      }
  }
}

struct ViewDidLoadAsyncModifier: ViewModifier {
  @State private var viewDidLoad = false
  let action: (() async -> Void)?

  func body(content: Content) -> some View {
    content
      .task {
        if viewDidLoad == false {
          viewDidLoad = true
          await action?()
        }
      }
  }
}

public extension View {
  /// Creates a nearly transparent view with 0.1% opacity in order to create a tappable area
  func nearlyTransparentView(opacity: CGFloat = 0.001) -> some View {
    self.modifier(NearlyTransparentModifier(opacity: opacity))
  }
}

private struct NearlyTransparentModifier: ViewModifier {

  let opacity: CGFloat

  func body(content: Content) -> some View {
    content
      .background(Color.white.opacity(opacity))
  }
}

extension View {
  func lightModePreview() -> some View {
    return self.background(Color.white)
      .environment(\.colorScheme, .light)
      .previewDisplayName("Light Mode")
  }

  func darkModePreview() -> some View {
    return self.background(Color.black)
      .environment(\.colorScheme, .dark)
      .previewDisplayName("Dark Mode")
  }
}
