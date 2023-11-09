/*
Copyright (c) 2023 European Commission

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
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
