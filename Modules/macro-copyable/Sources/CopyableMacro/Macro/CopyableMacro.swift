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

public struct CopyableMacro: MemberMacro {

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

    var declSyntax: [DeclSyntax] = []

    let variables = structDeclSyntax.memberBlock.members
      .compactMap { $0.decl.as(VariableDeclSyntax.self) }
      .filter { $0.bindings.allSatisfy { accessorIsAllowed($0.accessorBlock?.accessors) } }

    let bindings = variables.flatMap(\.bindings)

    // Linear copy creation
    declSyntax.append(
      contentsOf: variables.flatMap { variable in

        let variableVisibility = variable.modifiers.visibilityText() ?? structVisibility

        return variable.bindings.compactMap { binding -> DeclSyntax? in

          let propertyName = binding.pattern

          guard let typeName = binding.typeAnnotation?.type else {
            let diagnostic = Diagnostic(node: Syntax(node), message: CopyableDiagnostic.propertyTypeProblem(binding))
            context.diagnose(diagnostic)
            return nil
          }

          return """
                          /// Returns a copy of the caller whose value for `\(propertyName)` is different.
                          \(raw: variableVisibility) func copy(\(propertyName): \(typeName.trimmed)) -> Self {
                              .init(\(raw: bindings.map { "\($0.pattern): \($0.pattern)" }.joined(separator: ", ")))
                          }
                          """
        }
      }
    )

    // Combined copy creation
    let parameterListString = bindings
      .map { binding in "\(binding.pattern): \(binding.typeAnnotation?.type.trimmed ?? "?")? = nil" }
      .joined(separator: ", ")

    declSyntax.append(
                        """
                        /// Returns a copy of the caller whose values are different. All values are optional and the previous value will be used if not set.
                        \(raw: structVisibility) func copy(\(raw: parameterListString)) -> Self {
                            .init(\(raw: bindings.map { "\($0.pattern): \($0.pattern) ?? self.\($0.pattern)" }.joined(separator: ", ")))
                        }
                        """
    )

    return declSyntax
  }
}
