//
//  ElementViewModel.swift
//  Iso18013HolderDemo
//
//  Created by ffeli on 04/09/2023.
//  Copyright © 2023 EUDIW. All rights reserved.
//

import Foundation
import MdocDataTransfer18013
import IdentifiedCollections

struct DocElementsViewModel: Identifiable {
	var id: String { docType }
	let docType: String
	var elements: Array<ElementViewModel>
}

extension Array where Element == DocElementsViewModel {
	var docSelectedDictionary: RequestItems { Dictionary(grouping: self, by: \.docType).mapValues { $0.first!.elements.filter(\.isSelected).nsDictionary } }
}

struct ElementViewModel: Identifiable {
	var id: String { elementIdentifier }
	let nameSpace: String
	let elementIdentifier: String
	var isSelected = true
}

extension Array where Element == ElementViewModel {
	var nsDictionary: [String: [String]] { Dictionary(grouping: self, by: \.nameSpace).mapValues { $0.map(\.elementIdentifier)} }
}
