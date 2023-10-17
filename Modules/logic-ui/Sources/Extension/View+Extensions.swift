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
import AlertToast
import PartialSheet

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
  func sheetDialog<Content: View>(isPresented: Binding<Bool>, _ content: @escaping () -> ContentSheet<Content>) -> some View {
    return self.partialSheet(
      isPresented: isPresented,
      iPhoneStyle: SheetStyle.iphoneSheetStyle,
      iPadMacStyle: SheetStyle.IpadMacSheetStyle,
      content: content
    )
  }
}
