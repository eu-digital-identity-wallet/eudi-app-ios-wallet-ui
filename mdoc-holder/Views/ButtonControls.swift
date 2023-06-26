//
//  Buttons.swift
//  mdoc-holder
//
//  Created by ffeli on 25/06/2023.
//

import SwiftUI

struct DocButton: View {
	let title: String
	let subtitle: String

	var body: some View {
			HStack(spacing: 50) {
				VStack(alignment: .leading, spacing: 4) {
					Text(verbatim: title).font(.title)
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
