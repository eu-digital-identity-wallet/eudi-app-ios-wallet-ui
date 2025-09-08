/*
 * Copyright (c) 2025 European Commission
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
import Swinject

public protocol DIGraphType: Sendable {
  var resolver: Resolver { get }
  var assembler: Assembler { get }
  func lazyLoad(with assemblies: [Assembly])
}

public final class DIGraph: DIGraphType {

  public let assembler: Assembler

  public var resolver: Resolver {
    assembler.resolver
  }

  private init() {
    self.assembler = Assembler()
  }

  public func lazyLoad(with assemblies: [Assembly]) {
    self.assembler.apply(assemblies: assemblies)
  }
}

public extension DIGraph {
  static let shared: DIGraphType = DIGraph()
}
