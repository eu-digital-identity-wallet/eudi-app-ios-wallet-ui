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
import logic_resources

public extension View {

  @ViewBuilder
  func dialogCompat<A: View, M: View>(
    _ key: LocalizableStringKey,
    isPresented: Binding<Bool>,
    titleVisibility: Visibility = .automatic,
    @ViewBuilder actions: @escaping () -> A,
    @ViewBuilder message: @escaping () -> M
  ) -> some View {
    modifier(
      DialogCompatModifier(
        isPresented: isPresented,
        key: key,
        titleVisibility: titleVisibility,
        actions: actions,
        message: message
      )
    )
  }
}

private struct DialogCompatModifier<A: View, M: View>: ViewModifier {

  @Binding var isPresented: Bool

  let key: LocalizableStringKey
  let titleVisibility: Visibility
  let actions: () -> A
  let message: () -> M

  func body(content: Content) -> some View {
    if #available(iOS 26, *) {
      content.alert(
        key.toString,
        isPresented: $isPresented,
        actions: actions,
        message: message
      )
    } else {
      content.confirmationDialog(
        key.toString,
        isPresented: $isPresented,
        titleVisibility: titleVisibility,
        actions: actions,
        message: message
      )
    }
  }
}
