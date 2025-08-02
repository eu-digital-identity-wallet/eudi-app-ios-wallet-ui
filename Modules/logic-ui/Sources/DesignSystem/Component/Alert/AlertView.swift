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
  func alertView(
    isPresented: Binding<Bool>,
    title: LocalizableStringKey,
    message: LocalizableStringKey,
    buttonText: LocalizableStringKey = .close,
    onDismiss: (() -> Void)? = nil
  ) -> some View {
    self.modifier(
      AlertAlertViewModifier(
        isPresented: isPresented,
        title: title,
        message: message,
        buttonText: buttonText,
        onDismiss: onDismiss
      )
    )
  }
}

private struct AlertAlertViewModifier: ViewModifier {
  @Binding var isPresented: Bool
  let title: LocalizableStringKey
  let message: LocalizableStringKey
  let buttonText: LocalizableStringKey
  let onDismiss: (() -> Void)?

  func body(content: Content) -> some View {
    content
      .alert(isPresented: $isPresented) {
        Alert(
          title: Text(title),
          message: Text(message),
          dismissButton: .default(
            Text(buttonText),
            action: {
              onDismiss?()
            }
          )
        )
      }
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
      buttonText: .close,
      onDismiss: {
        print("Alert dismissed")
      }
    )
  }
}

#Preview {
  PreviewView()
}
