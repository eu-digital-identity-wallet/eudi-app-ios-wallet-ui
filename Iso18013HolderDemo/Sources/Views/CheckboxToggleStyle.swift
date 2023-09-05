//
//  CheckboxToggleStyle.swift
//  Iso18013HolderDemo
//
//  Created by ffeli on 05/09/2023.
//  Copyright © 2023 EUDIW. All rights reserved.
//

import Foundation
import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
	func makeBody(configuration: Configuration) -> some View {
		return HStack {
			Image(systemName: configuration.isOn ? "checkmark.square" : "square")
				.resizable().frame(width: 22, height: 22)
			configuration.label
			Spacer()
		}
		.onTapGesture { configuration.isOn.toggle() }
	}
}
