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
import Foundation

public typealias RequestConvertibleItems = [String: [String: [String]]]

public protocol RequestItemConvertible {
  func asRequestItems() -> RequestConvertibleItems
}

public struct RequestItemsWrapper: RequestItemConvertible {

  public var requestItems: RequestConvertibleItems

  public init() {
    requestItems = RequestConvertibleItems()
  }

  public init(dictionary: RequestConvertibleItems) {
    self.requestItems = dictionary
  }

  public func asRequestItems() -> RequestConvertibleItems {
    requestItems
  }
}

extension RequestItems: RequestItemConvertible {
  public func asRequestItems() -> RequestConvertibleItems {
    return self
  }
}
