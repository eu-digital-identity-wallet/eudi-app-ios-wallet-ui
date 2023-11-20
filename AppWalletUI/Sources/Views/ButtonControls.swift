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
import MdocDataModel18013

struct DocButton: View {
	let title: String
	let subtitle: String

	var body: some View {
			HStack(spacing: 20) {
				VStack(alignment: .leading, spacing: 4) {
					Text(verbatim: title).minimumScaleFactor(0.5).font(.headline)
					Text(verbatim: subtitle).font(.caption2)
				}
				Spacer()
				Image(systemName: "arrowtriangle.forward").scaleEffect(1.5)
			}.padding()
			.overlay() {
				RoundedRectangle(cornerRadius: 6).stroke(lineWidth: 2)
			}.background(Color("CardColor")).foregroundColor(.black).padding()
    }
}
