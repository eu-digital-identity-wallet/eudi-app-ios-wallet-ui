/*
 * Copyright (c) 2026 European Commission
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
  func alertView<A: View>(
    isPresented: Binding<Bool>,
    title: LocalizableStringKey,
    message: LocalizableStringKey,
    @ViewBuilder actions: @escaping () -> A,
  ) -> some View {
    self.modifier(
      AlertAlertViewModifier(
        isPresented: isPresented,
        title: title,
        message: message,
        actions: actions
      )
    )
  }
}

private struct AlertAlertViewModifier<A: View>: ViewModifier {
  @Binding var isPresented: Bool
  let title: LocalizableStringKey
  let message: LocalizableStringKey
  let actions: () -> A

  func body(content: Content) -> some View {
    content
      .alert(
        title.toString,
        isPresented: $isPresented,
        actions: actions,
        message: {
          Text(message)
        }
      )
  }
}

private struct PreviewView: View {
  @State private var showAlert = false

  var body: some View {
    VStack {
      Button("Show Alert") {
        showAlert = true
      }
      .padding()
    }
    .alertView(
      isPresented: $showAlert,
      title: .trustedRelyingParty,
      message: .trustedRelyingPartyDescription,
      actions: {
        Button(.okButton, role: .cancel) {}
      }
    )
  }
}

#Preview {
  PreviewView()
}
