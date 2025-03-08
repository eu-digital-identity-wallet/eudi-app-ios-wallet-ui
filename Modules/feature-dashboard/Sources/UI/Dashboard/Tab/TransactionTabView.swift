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
import logic_ui
import logic_resources

public struct TransactionTabView: View {
    public var body: some View {
      contentUnavailableView()
    }
    
    @ViewBuilder
    private func contentUnavailableView() -> some View {
        VStack(spacing: SPACING_SMALL) {
            Theme.shared.image.clockIndicator
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48, height: 48)
                .foregroundStyle(Theme.shared.color.onSurfaceVariant)
                .padding(.bottom, SPACING_SMALL)
            
            Text(.noTransactions)
                .typography(Theme.shared.font.titleLarge)
                .fontWeight(.bold)
            
            Text(.noTransactionsDescription)
                .typography(Theme.shared.font.bodyLarge)
                .foregroundStyle(Theme.shared.color.onSurface)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding(.horizontal, SPACING_MEDIUM)
    }
}

#Preview {
  TransactionTabView()
}
