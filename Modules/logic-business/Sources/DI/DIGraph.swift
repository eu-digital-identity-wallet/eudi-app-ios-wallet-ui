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
@preconcurrency import Swinject

public protocol DIGraphType: ThreadSafeProtocol {
  var assembler: Assembler { get }
  func lazyLoad(with assemblies: [Assembly])
}

public final class DIGraph: DIGraphType {

  public let assembler: Assembler

  private init() {
    self.assembler = Assembler()
  }

  public func lazyLoad(with assemblies: [Assembly]) {
    self.assembler.apply(assemblies: assemblies)
  }
}

public extension DIGraph {

  static let resolver: Resolver = shared.assembler.resolver

  static func lazyLoad(with assemblies: [Assembly]) {
    DIGraph.shared.lazyLoad(with: assemblies)
  }
}

private extension DIGraph {
  static let shared: DIGraphType = DIGraph()
}

public extension Resolver {

  func force<Service>(_ serviceType: Service.Type) -> Service {
    resolve(serviceType)!
  }

  func force<Service>(_ serviceType: Service.Type, name: String?) -> Service {
    resolve(serviceType, name: name)!
  }

  func force<Service, Arg1>(
    _ serviceType: Service.Type,
    argument: Arg1
  ) -> Service {
    resolve(serviceType, argument: argument)!
  }

  func force<Service, Arg1>(
    _ serviceType: Service.Type,
    name: String?,
    argument: Arg1
  ) -> Service {
    resolve(serviceType, name: name, argument: argument)!
  }
}
