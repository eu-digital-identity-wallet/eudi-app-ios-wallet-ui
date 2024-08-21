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
import Copyable

@Copyable
public struct ItemSingleCopy {

  private(set) var property1: String
  let property2: Int
  private var property3: String

  /// This should not generate a copy function because it's not a stored property.
  var computed1: String {
    get {
      property1
    }
    set {
      property1 = newValue
    }
  }

  /// This should not generate a copy function because it's not a stored property.
  var computed2: String {
    property1.uppercased()
  }

  var property4: String? = "Value" {
    didSet {
      print("value changed to \(property4 ?? "(nil)")")
    }
  }

  init(property1: String, property2: Int, property3: String, property4: String? = nil) {
    self.property1 = property1
    self.property2 = property2
    self.property3 = property3
    self.property4 = property4
  }
}

print("ItemSingleCopy copy with new property2: \(ItemSingleCopy(property1: "Value1", property2: 1, property3: "Value3", property4: "Value3").copy(property2: 2).property2)")

@CopyableCombined
struct ItemCombinedCopy {
  let property1: String
  let property2: Int
}
