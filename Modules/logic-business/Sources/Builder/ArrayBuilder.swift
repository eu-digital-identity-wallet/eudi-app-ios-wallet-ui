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

@resultBuilder
public struct ArrayBuilder<T> {

  public enum Component {
    case array([T]), element(T), nothing
  }

  public static func buildExpression(_ expression: T) -> Component {
    .element(expression)
  }

  public static func buildBlock(_ components: Component...) -> Component {
    buildArray(components)
  }

  public static func buildArray(_ components: [Component]) -> Component {
    var array = [T]()
    for component in components {
      switch component {
      case .array(let a): array.append(contentsOf: a)
      case .element(let t): array.append(t)
      default: break
      }
    }
    return .array(array)
  }

  public static func buildOptional(_ component: Component?) -> Component {
    component ?? .nothing
  }

  public static func buildEither(first component: Component) -> Component {
    component
  }

  public static func buildEither(second component: Component) -> Component {
    component
  }

  public static func buildFinalResult(_ component: Component) -> [T] {
    switch component {
    case .array(let a): return a
    case .element(let t): return [t]
    default: return []
    }
  }
}

public func buildArray<T>(_ type: T.Type = T.self, @ArrayBuilder<T> block: () -> [T]) -> [T] {
  block()
}
