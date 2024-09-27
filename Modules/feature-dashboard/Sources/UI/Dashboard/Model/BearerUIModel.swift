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
import logic_core
import UIKit
import logic_business

public struct BearerUIModel: Identifiable, Equatable {

  @EquatableNoop
  public var id: String

  public let value: Value

  public init(id: String, value: Value) {
    self.id = id
    self.value = value
  }
}

public extension BearerUIModel {

  struct Value: Equatable {

    public let name: String

    @EquatableNoop
    public var image: Image
  }

  static func mock(name: String = "") -> BearerUIModel {
    .init(
      id: UUID().uuidString,
      value: .init(
        name: name,
        image: Theme.shared.image.user
      )
    )
  }

  static func transformToBearerUi(
    walletKitController: WalletKitController
  ) -> BearerUIModel {

    let storageDocuments = walletKitController.fetchIssuedDocuments(
      excluded: [DocumentTypeIdentifier.PID]
    )

    var name = walletKitController.fetchMainPidDocument()?.getBearersName()?.first
    var image: Image?

    for item in storageDocuments {

      guard name == nil || image == nil else {
        break
      }

      if name == nil, let bearerName = item.getBearersName() {
        name = bearerName.first
      }

      if image == nil, let tempImage = item.getPortrait() {
        image = tempImage
      }
    }

    return .init(
      id: UUID().uuidString,
      value: .init(
        name: name.orEmpty,
        image: image ?? Theme.shared.image.user
      )
    )
  }
}
