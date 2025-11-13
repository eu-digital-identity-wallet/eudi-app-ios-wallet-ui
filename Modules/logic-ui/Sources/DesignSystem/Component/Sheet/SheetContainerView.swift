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

struct SheetContainerView<Content: View>: View {

  @Binding var isPresented: Bool
  let backgroundTapToDismiss: Bool
  let content: () -> Content

  @State private var isVisible: Bool = false

  var body: some View {
    GeometryReader { proxy in
      ZStack(alignment: .bottom) {

        if isPresented || isVisible {

          Color.black
            .opacity(isVisible ? 0.35 : 0)
            .ignoresSafeArea()
            .contentShape(Rectangle())
            .allowsHitTesting(isVisible && backgroundTapToDismiss)
            .onTapGesture {
              guard backgroundTapToDismiss else { return }
              withAnimation(.easeInOut(duration: 0.25)) {
                isVisible = false
              }
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                isPresented = false
              }
            }

          VStack(spacing: .zero) {
            content()
              .padding([.top, .horizontal])
              .padding(.bottom, proxy.safeAreaInsets.bottom)
          }
          .background(
            RoundedRectangle(cornerRadius: SPACING_MEDIUM, style: .continuous)
              .fill(Color(.systemBackground))
              .shadow(radius: 10)
          )
          .offset(y: isVisible ? 0 : proxy.size.height)
          .animation(.easeInOut(duration: 0.25), value: isVisible)
        }
      }
      .ignoresSafeArea(edges: .all)
      .onChange(of: isPresented) { _, newValue in
        if newValue {
          isVisible = false
          withAnimation(.easeInOut(duration: 0.25)) {
            isVisible = true
          }
        } else {
          withAnimation(.easeInOut(duration: 0.25)) {
            isVisible = false
          }
        }
      }
      .onAppear {
        if isPresented {
          isVisible = true
        }
      }
    }
  }
}
