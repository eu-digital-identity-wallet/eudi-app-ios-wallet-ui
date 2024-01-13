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
import Foundation
import SwiftUI
import logic_ui
import logic_resources
import CodeScanner

public struct ScannerView: View {

  @State var errorMessage = ""
  @State var displayError = false

  @Binding var dismiss: Bool
  let action: (String) -> Void

  public init(
    dismiss: Binding<Bool>,
    action: @escaping (String) -> Void
  ) {
    _dismiss = dismiss
    self.action = action
  }

  public var body: some View {
    ZStack(alignment: .top) {

      CodeScannerView(
        codeTypes: [.qr],
        showViewfinder: true
      ) { response in
        switch response {
        case .success(let result):
          dismiss.toggle()
          action(result.string)
        case .failure(let error):
          displayError.toggle()
          errorMessage = error.localizedDescription
        }
      }
      .preferredColorScheme(.dark)

      ContentHeader(
        dismissIcon: Theme.shared.image.xmark,
        foregroundColor: Theme.shared.color.white
      ) {
        dismiss.toggle()
      }
      .nearlyTransparentView()
      .ignoresSafeArea(edges: .horizontal)
      .padding()

    }
    .onError(
      show: $displayError,
      message: errorMessage
    )
    .background(Theme.shared.color.black)
    .edgesIgnoringSafeArea(.bottom)
  }
}