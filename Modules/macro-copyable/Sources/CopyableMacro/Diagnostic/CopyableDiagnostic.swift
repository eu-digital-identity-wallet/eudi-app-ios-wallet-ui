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
import SwiftSyntax
import SwiftDiagnostics

enum CopyableDiagnostic: DiagnosticMessage {

  case notAStruct
  case propertyTypeProblem(PatternBindingListSyntax.Element)

  var severity: DiagnosticSeverity {
    switch self {
    case .notAStruct: .error
    case .propertyTypeProblem: .warning
    }
  }

  var message: String {
    switch self {
    case .notAStruct:
      "'@Copyable' can only be applied to a 'struct'"
    case .propertyTypeProblem(let binding):
      "Type error for property '\(binding.pattern)': \(binding)"
    }
  }

  var diagnosticID: MessageID {
    switch self {
    case .notAStruct:
        .init(domain: "CopyableMacros", id: "notAStruct")
    case .propertyTypeProblem(let binding):
        .init(domain: "CopyableMacros", id: "propertyTypeProblem(\(binding.pattern))")
    }
  }
}
