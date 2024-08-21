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
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct CopyableCombinedMacro: MemberMacro {

  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {

    guard let structDeclSyntax = declaration as? StructDeclSyntax else {
      let diagnostic = Diagnostic(node: Syntax(node), message: CopyableDiagnostic.notAStruct)
      context.diagnose(diagnostic)
      return []
    }

    let structVisibility = structDeclSyntax.modifiers.visibilityText() ?? "internal"

    let variables = structDeclSyntax.memberBlock.members
      .compactMap { $0.decl.as(VariableDeclSyntax.self) }
      .filter { $0.bindings.allSatisfy { accessorIsAllowed($0.accessorBlock?.accessors) } }

    let bindings = variables.flatMap(\.bindings).filter { accessorIsAllowed($0.accessorBlock?.accessors) }

    let variablesCombi = variables.combinationsWithoutRepetition.filter { !$0.isEmpty }

    let listFormatter = ListFormatter()
    listFormatter.locale = .init(identifier: "en")

    return variablesCombi.compactMap { variableCombi -> DeclSyntax? in

      let bindingsCombi = variableCombi.flatMap { $0.bindings }
      let many = bindingsCombi.count > 1

      let propertyNamesString = listFormatter.string(from: bindingsCombi.map { "`\($0.pattern)`" }) ?? "?"
      let parameterListString = bindingsCombi.map { binding in "\(binding.pattern): \(binding.typeAnnotation?.type.trimmed ?? "?")" }.joined(separator: ", ")

      return """
            /// Returns a copy of the caller whose \(raw: many ? "values" : "value") for \(raw: propertyNamesString) \(raw: many ? "are" : "is") different.
            \(raw: structVisibility) func copy(\(raw: parameterListString)) -> Self {
                .init(\(raw: bindings.map { "\($0.pattern): \($0.pattern)" }.joined(separator: ", ")))
            }
            """
    }
  }
}
