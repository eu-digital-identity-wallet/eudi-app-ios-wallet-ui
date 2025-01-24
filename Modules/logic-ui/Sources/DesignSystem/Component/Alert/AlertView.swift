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
import logic_resources

struct AlertAlertViewModifier: ViewModifier {
  @Binding var isPresented: Bool
  let title: String
  let message: String
  let buttonText: String
  let onDismiss: (() -> Void)?

  func body(content: Content) -> some View {
    content
      .alert(isPresented: $isPresented) {
        Alert(
          title: Text(title),
          message: Text(message),
          dismissButton: .default(Text(buttonText), action: {
            onDismiss?()
          })
        )
      }
  }
}

public extension View {
  func alertView(
    isPresented: Binding<Bool>,
    title: String,
    message: String,
    buttonText: String = "Close",
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

struct PreviewView: View {
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
      title: "Trusted Relying Party",
      message: "A Relying Party is considered trusted when it meets predefined criteria for security, data protection, compliance, and responsible data handling. Trust is reinforced through assessments, audits, and certifications.",
      buttonText: "Close",
      onDismiss: {
        print("Alert dismissed")
      }
    )
  }
}

#Preview {
  PreviewView()
}
