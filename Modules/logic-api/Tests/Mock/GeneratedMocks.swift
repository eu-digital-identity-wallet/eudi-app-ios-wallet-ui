// MARK: - Mocks generated from file: 'Modules/logic-analytics/Sources/Config/AnalyticsConfig.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api

class MockAnalyticsConfig: AnalyticsConfig, Cuckoo.ProtocolMock {
    typealias MocksType = AnalyticsConfig
    typealias Stubbing = __StubbingProxy_AnalyticsConfig
    typealias Verification = __VerificationProxy_AnalyticsConfig

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: AnalyticsConfig?

    func enableDefaultImplementation(_ stub: AnalyticsConfig) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
     var analyticsProviders: [String: AnalyticsProvider] {
        get {
            return cuckoo_manager.getter(
                "analyticsProviders",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.analyticsProviders
            )
        }
    }



    struct __StubbingProxy_AnalyticsConfig: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var analyticsProviders: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAnalyticsConfig,[String: AnalyticsProvider]> {
            return .init(manager: cuckoo_manager, name: "analyticsProviders")
        }
    }

    struct __VerificationProxy_AnalyticsConfig: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        var analyticsProviders: Cuckoo.VerifyReadOnlyProperty<[String: AnalyticsProvider]> {
            return .init(manager: cuckoo_manager, name: "analyticsProviders", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    
    }
}

class AnalyticsConfigStub:AnalyticsConfig {
    
     var analyticsProviders: [String: AnalyticsProvider] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String: AnalyticsProvider]).self)
        }
    }


}




// MARK: - Mocks generated from file: 'Modules/logic-analytics/Sources/Controller/AnalyticsController.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api

public class MockAnalyticsController: AnalyticsController, Cuckoo.ProtocolMock {
    public typealias MocksType = AnalyticsController
    public typealias Stubbing = __StubbingProxy_AnalyticsController
    public typealias Verification = __VerificationProxy_AnalyticsController

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: AnalyticsController?

    public func enableDefaultImplementation(_ stub: AnalyticsController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func initialize() {
        
        return cuckoo_manager.call(
            "initialize()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.initialize()
        )
        
    }
    public func logScreen(screen p0: String, arguments p1: [String: String]) {
        
        return cuckoo_manager.call(
            "logScreen(screen p0: String, arguments p1: [String: String])",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.logScreen(screen: p0, arguments: p1)
        )
        
    }
    public func logEvent(event p0: String, arguments p1: [String: String]) {
        
        return cuckoo_manager.call(
            "logEvent(event p0: String, arguments p1: [String: String])",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.logEvent(event: p0, arguments: p1)
        )
        
    }

    public struct __StubbingProxy_AnalyticsController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func initialize() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAnalyticsController.self,
                method: "initialize()",
                parameterMatchers: matchers
            ))
        }
        
        func logScreen<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(screen p0: M1, arguments p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, [String: String])> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAnalyticsController.self,
                method: "logScreen(screen p0: String, arguments p1: [String: String])",
                parameterMatchers: matchers
            ))
        }
        
        func logEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(event p0: M1, arguments p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, [String: String])> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAnalyticsController.self,
                method: "logEvent(event p0: String, arguments p1: [String: String])",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_AnalyticsController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
    
        
        @discardableResult
        func initialize() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "initialize()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func logScreen<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(screen p0: M1, arguments p1: M2) -> Cuckoo.__DoNotUse<(String, [String: String]), Void> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "logScreen(screen p0: String, arguments p1: [String: String])",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func logEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(event p0: M1, arguments p1: M2) -> Cuckoo.__DoNotUse<(String, [String: String]), Void> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "logEvent(event p0: String, arguments p1: [String: String])",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class AnalyticsControllerStub:AnalyticsController {


    
    public  func initialize() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public  func logScreen(screen p0: String, arguments p1: [String: String]) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public  func logEvent(event p0: String, arguments p1: [String: String]) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-analytics/Sources/Demo/AppCenterProvider.swift'

import Cuckoo
import AppCenter
import AppCenterCrashes
import AppCenterAnalytics
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-analytics/Sources/Provider/AnalyticsProvider.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api

class MockAnalyticsProvider: AnalyticsProvider, Cuckoo.ProtocolMock {
    typealias MocksType = AnalyticsProvider
    typealias Stubbing = __StubbingProxy_AnalyticsProvider
    typealias Verification = __VerificationProxy_AnalyticsProvider

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: AnalyticsProvider?

    func enableDefaultImplementation(_ stub: AnalyticsProvider) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    func initialize(key p0: String) {
        
        return cuckoo_manager.call(
            "initialize(key p0: String)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.initialize(key: p0)
        )
        
    }
    func logScreen(screen p0: String, arguments p1: [String: String]) {
        
        return cuckoo_manager.call(
            "logScreen(screen p0: String, arguments p1: [String: String])",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.logScreen(screen: p0, arguments: p1)
        )
        
    }
    func logEvent(event p0: String, arguments p1: [String: String]) {
        
        return cuckoo_manager.call(
            "logEvent(event p0: String, arguments p1: [String: String])",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.logEvent(event: p0, arguments: p1)
        )
        
    }

    struct __StubbingProxy_AnalyticsProvider: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func initialize<M1: Cuckoo.Matchable>(key p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAnalyticsProvider.self,
                method: "initialize(key p0: String)",
                parameterMatchers: matchers
            ))
        }
        
        func logScreen<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(screen p0: M1, arguments p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, [String: String])> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAnalyticsProvider.self,
                method: "logScreen(screen p0: String, arguments p1: [String: String])",
                parameterMatchers: matchers
            ))
        }
        
        func logEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(event p0: M1, arguments p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, [String: String])> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAnalyticsProvider.self,
                method: "logEvent(event p0: String, arguments p1: [String: String])",
                parameterMatchers: matchers
            ))
        }
    }

    struct __VerificationProxy_AnalyticsProvider: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
    
        
        @discardableResult
        func initialize<M1: Cuckoo.Matchable>(key p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "initialize(key p0: String)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func logScreen<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(screen p0: M1, arguments p1: M2) -> Cuckoo.__DoNotUse<(String, [String: String]), Void> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "logScreen(screen p0: String, arguments p1: [String: String])",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func logEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(event p0: M1, arguments p1: M2) -> Cuckoo.__DoNotUse<(String, [String: String]), Void> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "logEvent(event p0: String, arguments p1: [String: String])",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

class AnalyticsProviderStub:AnalyticsProvider {


    
     func initialize(key p0: String) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func logScreen(screen p0: String, arguments p1: [String: String]) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func logEvent(event p0: String, arguments p1: [String: String]) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-api/Sources/Api/SampleApi.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-api/Sources/Core/NetworkManager.swift'

import Cuckoo
import Foundation
import Alamofire
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api

class MockNetworkManager: NetworkManager, Cuckoo.ProtocolMock {
    typealias MocksType = NetworkManager
    typealias Stubbing = __StubbingProxy_NetworkManager
    typealias Verification = __VerificationProxy_NetworkManager

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: NetworkManager?

    func enableDefaultImplementation(_ stub: NetworkManager) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    func execute<R: NetworkRequest, T: Decodable> (with p0: R, parameters p1: [NetworkParameter]?) async throws -> T {
        
        return try await cuckoo_manager.callThrows(
            "execute<R: NetworkRequest, T: Decodable> (with p0: R, parameters p1: [NetworkParameter]?) async throws -> T",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.execute(with: p0, parameters: p1)
        )
        
    }
    func prepare<R: NetworkRequest> (request p0: R, parameters p1: [NetworkParameter]?, baseHost p2: String) async -> URLRequest {
        
        return await cuckoo_manager.call(
            "prepare<R: NetworkRequest> (request p0: R, parameters p1: [NetworkParameter]?, baseHost p2: String) async -> URLRequest",
            parameters: (p0, p1, p2),
            escapingParameters: (p0, p1, p2),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.prepare(request: p0, parameters: p1, baseHost: p2)
        )
        
    }
    func log(request p0: URLRequest, responseData p1: Data?) {
        
        return cuckoo_manager.call(
            "log(request p0: URLRequest, responseData p1: Data?)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.log(request: p0, responseData: p1)
        )
        
    }

    struct __StubbingProxy_NetworkManager: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func execute<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, R: NetworkRequest, T: Decodable>(with p0: M1, parameters p1: M2) -> Cuckoo.ProtocolStubThrowingFunction<(R, [NetworkParameter]?), T> where M1.MatchedType == R, M2.OptionalMatchedType == [NetworkParameter] {
            let matchers: [Cuckoo.ParameterMatcher<(R, [NetworkParameter]?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockNetworkManager.self,
                method: "execute<R: NetworkRequest, T: Decodable> (with p0: R, parameters p1: [NetworkParameter]?) async throws -> T",
                parameterMatchers: matchers
            ))
        }
        
        func prepare<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, R: NetworkRequest>(request p0: M1, parameters p1: M2, baseHost p2: M3) -> Cuckoo.ProtocolStubFunction<(R, [NetworkParameter]?, String), URLRequest> where M1.MatchedType == R, M2.OptionalMatchedType == [NetworkParameter], M3.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(R, [NetworkParameter]?, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockNetworkManager.self,
                method: "prepare<R: NetworkRequest> (request p0: R, parameters p1: [NetworkParameter]?, baseHost p2: String) async -> URLRequest",
                parameterMatchers: matchers
            ))
        }
        
        func log<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(request p0: M1, responseData p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(URLRequest, Data?)> where M1.MatchedType == URLRequest, M2.OptionalMatchedType == Data {
            let matchers: [Cuckoo.ParameterMatcher<(URLRequest, Data?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockNetworkManager.self,
                method: "log(request p0: URLRequest, responseData p1: Data?)",
                parameterMatchers: matchers
            ))
        }
    }

    struct __VerificationProxy_NetworkManager: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
    
        
        @discardableResult
        func execute<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, R: NetworkRequest, T: Decodable>(with p0: M1, parameters p1: M2) -> Cuckoo.__DoNotUse<(R, [NetworkParameter]?), T> where M1.MatchedType == R, M2.OptionalMatchedType == [NetworkParameter] {
            let matchers: [Cuckoo.ParameterMatcher<(R, [NetworkParameter]?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "execute<R: NetworkRequest, T: Decodable> (with p0: R, parameters p1: [NetworkParameter]?) async throws -> T",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func prepare<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, R: NetworkRequest>(request p0: M1, parameters p1: M2, baseHost p2: M3) -> Cuckoo.__DoNotUse<(R, [NetworkParameter]?, String), URLRequest> where M1.MatchedType == R, M2.OptionalMatchedType == [NetworkParameter], M3.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(R, [NetworkParameter]?, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return cuckoo_manager.verify(
                "prepare<R: NetworkRequest> (request p0: R, parameters p1: [NetworkParameter]?, baseHost p2: String) async -> URLRequest",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func log<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(request p0: M1, responseData p1: M2) -> Cuckoo.__DoNotUse<(URLRequest, Data?), Void> where M1.MatchedType == URLRequest, M2.OptionalMatchedType == Data {
            let matchers: [Cuckoo.ParameterMatcher<(URLRequest, Data?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "log(request p0: URLRequest, responseData p1: Data?)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

class NetworkManagerStub:NetworkManager {


    
     func execute<R: NetworkRequest, T: Decodable> (with p0: R, parameters p1: [NetworkParameter]?) async throws -> T {
        return DefaultValueRegistry.defaultValue(for: (T).self)
    }
    
     func prepare<R: NetworkRequest> (request p0: R, parameters p1: [NetworkParameter]?, baseHost p2: String) async -> URLRequest {
        return DefaultValueRegistry.defaultValue(for: (URLRequest).self)
    }
    
     func log(request p0: URLRequest, responseData p1: Data?) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-api/Sources/Core/NetworkParameter.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-api/Sources/Core/NetworkRequest.swift'

import Cuckoo
import struct Foundation.Data
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api

class MockNetworkRequest<Response>: NetworkRequest, Cuckoo.ProtocolMock {
    typealias MocksType = DefaultImplCaller
    typealias Stubbing = __StubbingProxy_NetworkRequest
    typealias Verification = __VerificationProxy_NetworkRequest

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    class DefaultImplCaller: NetworkRequest {
        private let reference: Any
    
        private let _getter_storage$$method: () -> NetworkMethod
        var method: NetworkMethod {
            get { return _getter_storage$$method() }
        }
    
        private let _getter_storage$$path: () -> String
        var path: String {
            get { return _getter_storage$$path() }
        }
    
        private let _getter_storage$$additionalHeaders: () -> [String: String]
        var additionalHeaders: [String: String] {
            get { return _getter_storage$$additionalHeaders() }
        }
    
        private let _getter_storage$$body: () -> Data?
        var body: Data? {
            get { return _getter_storage$$body() }
        }
    
        
        init<_CUCKOO$$GENERIC: NetworkRequest>(from defaultImpl: UnsafeMutablePointer<_CUCKOO$$GENERIC>, keeping reference: @escaping @autoclosure () -> Any?) where _CUCKOO$$GENERIC.Response == Response {
            self.reference = reference
    
            _getter_storage$$method = { defaultImpl.pointee.method }
            _getter_storage$$path = { defaultImpl.pointee.path }
            _getter_storage$$additionalHeaders = { defaultImpl.pointee.additionalHeaders }
            _getter_storage$$body = { defaultImpl.pointee.body }
        }
    
    }

    private var __defaultImplStub: DefaultImplCaller?

    func enableDefaultImplementation<_CUCKOO$$GENERIC: NetworkRequest>(_ stub: _CUCKOO$$GENERIC) where _CUCKOO$$GENERIC.Response == Response {
        var mutableStub = stub
        __defaultImplStub = DefaultImplCaller(from: &mutableStub, keeping: mutableStub)
        cuckoo_manager.enableDefaultStubImplementation()
    }

    func enableDefaultImplementation<_CUCKOO$$GENERIC: NetworkRequest>(mutating stub: UnsafeMutablePointer<_CUCKOO$$GENERIC>) where _CUCKOO$$GENERIC.Response == Response {
        __defaultImplStub = DefaultImplCaller(from: stub, keeping: nil)
        cuckoo_manager.enableDefaultStubImplementation()
    }
     var method: NetworkMethod {
        get {
            return cuckoo_manager.getter(
                "method",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.method
            )
        }
    }
     var path: String {
        get {
            return cuckoo_manager.getter(
                "path",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.path
            )
        }
    }
     var additionalHeaders: [String: String] {
        get {
            return cuckoo_manager.getter(
                "additionalHeaders",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.additionalHeaders
            )
        }
    }
     var body: Data? {
        get {
            return cuckoo_manager.getter(
                "body",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.body
            )
        }
    }



    struct __StubbingProxy_NetworkRequest: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var method: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockNetworkRequest,NetworkMethod> {
            return .init(manager: cuckoo_manager, name: "method")
        }
        
        var path: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockNetworkRequest,String> {
            return .init(manager: cuckoo_manager, name: "path")
        }
        
        var additionalHeaders: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockNetworkRequest,[String: String]> {
            return .init(manager: cuckoo_manager, name: "additionalHeaders")
        }
        
        var body: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockNetworkRequest,Data?> {
            return .init(manager: cuckoo_manager, name: "body")
        }
    }

    struct __VerificationProxy_NetworkRequest: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        var method: Cuckoo.VerifyReadOnlyProperty<NetworkMethod> {
            return .init(manager: cuckoo_manager, name: "method", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        var path: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "path", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        var additionalHeaders: Cuckoo.VerifyReadOnlyProperty<[String: String]> {
            return .init(manager: cuckoo_manager, name: "additionalHeaders", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        var body: Cuckoo.VerifyReadOnlyProperty<Data?> {
            return .init(manager: cuckoo_manager, name: "body", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    
    }
}

class NetworkRequestStub<Response>:NetworkRequest {
    
     var method: NetworkMethod {
        get {
            return DefaultValueRegistry.defaultValue(for: (NetworkMethod).self)
        }
    }
    
     var path: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }
    
     var additionalHeaders: [String: String] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String: String]).self)
        }
    }
    
     var body: Data? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Data?).self)
        }
    }


}




// MARK: - Mocks generated from file: 'Modules/logic-api/Sources/Model/Request/SampleRequestDTO.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-api/Sources/Model/Response/SampleResponseDTO.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-api/Sources/Repository/SampleRepository.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api

public class MockSampleRepository: SampleRepository, Cuckoo.ProtocolMock {
    public typealias MocksType = SampleRepository
    public typealias Stubbing = __StubbingProxy_SampleRepository
    public typealias Verification = __VerificationProxy_SampleRepository

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: SampleRepository?

    public func enableDefaultImplementation(_ stub: SampleRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func sampleCall() async throws -> SampleResponseDTO {
        
        return try await cuckoo_manager.callThrows(
            "sampleCall() async throws -> SampleResponseDTO",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.sampleCall()
        )
        
    }

    public struct __StubbingProxy_SampleRepository: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func sampleCall() -> Cuckoo.ProtocolStubThrowingFunction<(), SampleResponseDTO> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSampleRepository.self,
                method: "sampleCall() async throws -> SampleResponseDTO",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_SampleRepository: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
    
        
        @discardableResult
        func sampleCall() -> Cuckoo.__DoNotUse<(), SampleResponseDTO> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "sampleCall() async throws -> SampleResponseDTO",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class SampleRepositoryStub:SampleRepository {


    
    public  func sampleCall() async throws -> SampleResponseDTO {
        return DefaultValueRegistry.defaultValue(for: (SampleResponseDTO).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Config/ConfigLogic.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api

public class MockConfigLogic: ConfigLogic, Cuckoo.ProtocolMock {
    public typealias MocksType = ConfigLogic
    public typealias Stubbing = __StubbingProxy_ConfigLogic
    public typealias Verification = __VerificationProxy_ConfigLogic

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: ConfigLogic?

    public func enableDefaultImplementation(_ stub: ConfigLogic) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    public  var walletHostUrl: String {
        get {
            return cuckoo_manager.getter(
                "walletHostUrl",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.walletHostUrl
            )
        }
    }
    public  var appBuildType: AppBuildType {
        get {
            return cuckoo_manager.getter(
                "appBuildType",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.appBuildType
            )
        }
    }
    public  var appVersion: String {
        get {
            return cuckoo_manager.getter(
                "appVersion",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.appVersion
            )
        }
    }



    public struct __StubbingProxy_ConfigLogic: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var walletHostUrl: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigLogic,String> {
            return .init(manager: cuckoo_manager, name: "walletHostUrl")
        }
        
        var appBuildType: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigLogic,AppBuildType> {
            return .init(manager: cuckoo_manager, name: "appBuildType")
        }
        
        var appVersion: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigLogic,String> {
            return .init(manager: cuckoo_manager, name: "appVersion")
        }
    }

    public struct __VerificationProxy_ConfigLogic: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        var walletHostUrl: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "walletHostUrl", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        var appBuildType: Cuckoo.VerifyReadOnlyProperty<AppBuildType> {
            return .init(manager: cuckoo_manager, name: "appBuildType", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        var appVersion: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "appVersion", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    
    }
}

public class ConfigLogicStub:ConfigLogic {
    
    public  var walletHostUrl: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }
    
    public  var appBuildType: AppBuildType {
        get {
            return DefaultValueRegistry.defaultValue(for: (AppBuildType).self)
        }
    }
    
    public  var appVersion: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }


}




// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Controller/KeyChainController.swift'

import Cuckoo
import Foundation
import KeychainAccess
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api

public class MockKeychainWrapper: KeychainWrapper, Cuckoo.ProtocolMock {
    public typealias MocksType = KeychainWrapper
    public typealias Stubbing = __StubbingProxy_KeychainWrapper
    public typealias Verification = __VerificationProxy_KeychainWrapper

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: KeychainWrapper?

    public func enableDefaultImplementation(_ stub: KeychainWrapper) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    public  var value: String {
        get {
            return cuckoo_manager.getter(
                "value",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.value
            )
        }
    }



    public struct __StubbingProxy_KeychainWrapper: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var value: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockKeychainWrapper,String> {
            return .init(manager: cuckoo_manager, name: "value")
        }
    }

    public struct __VerificationProxy_KeychainWrapper: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        var value: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "value", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    
    }
}

public class KeychainWrapperStub:KeychainWrapper {
    
    public  var value: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }


}


public class MockKeyChainController: KeyChainController, Cuckoo.ProtocolMock {
    public typealias MocksType = KeyChainController
    public typealias Stubbing = __StubbingProxy_KeyChainController
    public typealias Verification = __VerificationProxy_KeyChainController

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: KeyChainController?

    public func enableDefaultImplementation(_ stub: KeyChainController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func storeValue(key p0: KeychainWrapper, value p1: String) {
        
        return cuckoo_manager.call(
            "storeValue(key p0: KeychainWrapper, value p1: String)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.storeValue(key: p0, value: p1)
        )
        
    }
    public func getValue(key p0: KeychainWrapper) -> String? {
        
        return cuckoo_manager.call(
            "getValue(key p0: KeychainWrapper) -> String?",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getValue(key: p0)
        )
        
    }
    public func removeObject(key p0: KeychainWrapper) {
        
        return cuckoo_manager.call(
            "removeObject(key p0: KeychainWrapper)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.removeObject(key: p0)
        )
        
    }
    public func validateKeyChainBiometry() throws {
        
        return try cuckoo_manager.callThrows(
            "validateKeyChainBiometry() throws",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.validateKeyChainBiometry()
        )
        
    }
    public func clearKeyChainBiometry() {
        
        return cuckoo_manager.call(
            "clearKeyChainBiometry()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.clearKeyChainBiometry()
        )
        
    }
    public func clear() {
        
        return cuckoo_manager.call(
            "clear()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.clear()
        )
        
    }

    public struct __StubbingProxy_KeyChainController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func storeValue<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(key p0: M1, value p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(KeychainWrapper, String)> where M1.MatchedType == KeychainWrapper, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(KeychainWrapper, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self,
                method: "storeValue(key p0: KeychainWrapper, value p1: String)",
                parameterMatchers: matchers
            ))
        }
        
        func getValue<M1: Cuckoo.Matchable>(key p0: M1) -> Cuckoo.ProtocolStubFunction<(KeychainWrapper), String?> where M1.MatchedType == KeychainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeychainWrapper)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self,
                method: "getValue(key p0: KeychainWrapper) -> String?",
                parameterMatchers: matchers
            ))
        }
        
        func removeObject<M1: Cuckoo.Matchable>(key p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(KeychainWrapper)> where M1.MatchedType == KeychainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeychainWrapper)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self,
                method: "removeObject(key p0: KeychainWrapper)",
                parameterMatchers: matchers
            ))
        }
        
        func validateKeyChainBiometry() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self,
                method: "validateKeyChainBiometry() throws",
                parameterMatchers: matchers
            ))
        }
        
        func clearKeyChainBiometry() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self,
                method: "clearKeyChainBiometry()",
                parameterMatchers: matchers
            ))
        }
        
        func clear() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self,
                method: "clear()",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_KeyChainController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
    
        
        @discardableResult
        func storeValue<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(key p0: M1, value p1: M2) -> Cuckoo.__DoNotUse<(KeychainWrapper, String), Void> where M1.MatchedType == KeychainWrapper, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(KeychainWrapper, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "storeValue(key p0: KeychainWrapper, value p1: String)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func getValue<M1: Cuckoo.Matchable>(key p0: M1) -> Cuckoo.__DoNotUse<(KeychainWrapper), String?> where M1.MatchedType == KeychainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeychainWrapper)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "getValue(key p0: KeychainWrapper) -> String?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func removeObject<M1: Cuckoo.Matchable>(key p0: M1) -> Cuckoo.__DoNotUse<(KeychainWrapper), Void> where M1.MatchedType == KeychainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeychainWrapper)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "removeObject(key p0: KeychainWrapper)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func validateKeyChainBiometry() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "validateKeyChainBiometry() throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func clearKeyChainBiometry() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "clearKeyChainBiometry()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func clear() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "clear()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class KeyChainControllerStub:KeyChainController {


    
    public  func storeValue(key p0: KeychainWrapper, value p1: String) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public  func getValue(key p0: KeychainWrapper) -> String? {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    public  func removeObject(key p0: KeychainWrapper) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public  func validateKeyChainBiometry() throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public  func clearKeyChainBiometry() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public  func clear() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Controller/PrefsController.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api

public class MockPrefsController: PrefsController, Cuckoo.ProtocolMock {
    public typealias MocksType = PrefsController
    public typealias Stubbing = __StubbingProxy_PrefsController
    public typealias Verification = __VerificationProxy_PrefsController

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: PrefsController?

    public func enableDefaultImplementation(_ stub: PrefsController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func setValue(_ p0: Any?, forKey p1: Prefs.Key) {
        
        return cuckoo_manager.call(
            "setValue(_ p0: Any?, forKey p1: Prefs.Key)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setValue(p0, forKey: p1)
        )
        
    }
    public func getString(forKey p0: Prefs.Key) -> String? {
        
        return cuckoo_manager.call(
            "getString(forKey p0: Prefs.Key) -> String?",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getString(forKey: p0)
        )
        
    }
    public func getOptionalString(forKey p0: Prefs.Key) -> String {
        
        return cuckoo_manager.call(
            "getOptionalString(forKey p0: Prefs.Key) -> String",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getOptionalString(forKey: p0)
        )
        
    }
    public func getBool(forKey p0: Prefs.Key) -> Bool {
        
        return cuckoo_manager.call(
            "getBool(forKey p0: Prefs.Key) -> Bool",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getBool(forKey: p0)
        )
        
    }
    public func getFloat(forKey p0: Prefs.Key) -> Float {
        
        return cuckoo_manager.call(
            "getFloat(forKey p0: Prefs.Key) -> Float",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getFloat(forKey: p0)
        )
        
    }
    public func getInt(forKey p0: Prefs.Key) -> Int {
        
        return cuckoo_manager.call(
            "getInt(forKey p0: Prefs.Key) -> Int",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getInt(forKey: p0)
        )
        
    }
    public func remove(forKey p0: Prefs.Key) {
        
        return cuckoo_manager.call(
            "remove(forKey p0: Prefs.Key)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.remove(forKey: p0)
        )
        
    }
    public func getValue(forKey p0: Prefs.Key) -> Any? {
        
        return cuckoo_manager.call(
            "getValue(forKey p0: Prefs.Key) -> Any?",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getValue(forKey: p0)
        )
        
    }
    public func getUserLocale() -> String {
        
        return cuckoo_manager.call(
            "getUserLocale() -> String",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getUserLocale()
        )
        
    }

    public struct __StubbingProxy_PrefsController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func setValue<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable>(_ p0: M1, forKey p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(Any?, Prefs.Key)> where M1.OptionalMatchedType == Any, M2.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Any?, Prefs.Key)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsController.self,
                method: "setValue(_ p0: Any?, forKey p1: Prefs.Key)",
                parameterMatchers: matchers
            ))
        }
        
        func getString<M1: Cuckoo.Matchable>(forKey p0: M1) -> Cuckoo.ProtocolStubFunction<(Prefs.Key), String?> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsController.self,
                method: "getString(forKey p0: Prefs.Key) -> String?",
                parameterMatchers: matchers
            ))
        }
        
        func getOptionalString<M1: Cuckoo.Matchable>(forKey p0: M1) -> Cuckoo.ProtocolStubFunction<(Prefs.Key), String> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsController.self,
                method: "getOptionalString(forKey p0: Prefs.Key) -> String",
                parameterMatchers: matchers
            ))
        }
        
        func getBool<M1: Cuckoo.Matchable>(forKey p0: M1) -> Cuckoo.ProtocolStubFunction<(Prefs.Key), Bool> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsController.self,
                method: "getBool(forKey p0: Prefs.Key) -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func getFloat<M1: Cuckoo.Matchable>(forKey p0: M1) -> Cuckoo.ProtocolStubFunction<(Prefs.Key), Float> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsController.self,
                method: "getFloat(forKey p0: Prefs.Key) -> Float",
                parameterMatchers: matchers
            ))
        }
        
        func getInt<M1: Cuckoo.Matchable>(forKey p0: M1) -> Cuckoo.ProtocolStubFunction<(Prefs.Key), Int> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsController.self,
                method: "getInt(forKey p0: Prefs.Key) -> Int",
                parameterMatchers: matchers
            ))
        }
        
        func remove<M1: Cuckoo.Matchable>(forKey p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Prefs.Key)> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsController.self,
                method: "remove(forKey p0: Prefs.Key)",
                parameterMatchers: matchers
            ))
        }
        
        func getValue<M1: Cuckoo.Matchable>(forKey p0: M1) -> Cuckoo.ProtocolStubFunction<(Prefs.Key), Any?> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsController.self,
                method: "getValue(forKey p0: Prefs.Key) -> Any?",
                parameterMatchers: matchers
            ))
        }
        
        func getUserLocale() -> Cuckoo.ProtocolStubFunction<(), String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsController.self,
                method: "getUserLocale() -> String",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_PrefsController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
    
        
        @discardableResult
        func setValue<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable>(_ p0: M1, forKey p1: M2) -> Cuckoo.__DoNotUse<(Any?, Prefs.Key), Void> where M1.OptionalMatchedType == Any, M2.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Any?, Prefs.Key)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "setValue(_ p0: Any?, forKey p1: Prefs.Key)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func getString<M1: Cuckoo.Matchable>(forKey p0: M1) -> Cuckoo.__DoNotUse<(Prefs.Key), String?> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "getString(forKey p0: Prefs.Key) -> String?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func getOptionalString<M1: Cuckoo.Matchable>(forKey p0: M1) -> Cuckoo.__DoNotUse<(Prefs.Key), String> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "getOptionalString(forKey p0: Prefs.Key) -> String",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func getBool<M1: Cuckoo.Matchable>(forKey p0: M1) -> Cuckoo.__DoNotUse<(Prefs.Key), Bool> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "getBool(forKey p0: Prefs.Key) -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func getFloat<M1: Cuckoo.Matchable>(forKey p0: M1) -> Cuckoo.__DoNotUse<(Prefs.Key), Float> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "getFloat(forKey p0: Prefs.Key) -> Float",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func getInt<M1: Cuckoo.Matchable>(forKey p0: M1) -> Cuckoo.__DoNotUse<(Prefs.Key), Int> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "getInt(forKey p0: Prefs.Key) -> Int",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func remove<M1: Cuckoo.Matchable>(forKey p0: M1) -> Cuckoo.__DoNotUse<(Prefs.Key), Void> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "remove(forKey p0: Prefs.Key)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func getValue<M1: Cuckoo.Matchable>(forKey p0: M1) -> Cuckoo.__DoNotUse<(Prefs.Key), Any?> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "getValue(forKey p0: Prefs.Key) -> Any?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func getUserLocale() -> Cuckoo.__DoNotUse<(), String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getUserLocale() -> String",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class PrefsControllerStub:PrefsController {


    
    public  func setValue(_ p0: Any?, forKey p1: Prefs.Key) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public  func getString(forKey p0: Prefs.Key) -> String? {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    public  func getOptionalString(forKey p0: Prefs.Key) -> String {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
    
    public  func getBool(forKey p0: Prefs.Key) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public  func getFloat(forKey p0: Prefs.Key) -> Float {
        return DefaultValueRegistry.defaultValue(for: (Float).self)
    }
    
    public  func getInt(forKey p0: Prefs.Key) -> Int {
        return DefaultValueRegistry.defaultValue(for: (Int).self)
    }
    
    public  func remove(forKey p0: Prefs.Key) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public  func getValue(forKey p0: Prefs.Key) -> Any? {
        return DefaultValueRegistry.defaultValue(for: (Any?).self)
    }
    
    public  func getUserLocale() -> String {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Controller/ReachabilityController.swift'

import Cuckoo
import Foundation
import Combine
import Network
import BluetoothKit
import UIKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api

public class MockReachabilityController: ReachabilityController, Cuckoo.ProtocolMock {
    public typealias MocksType = ReachabilityController
    public typealias Stubbing = __StubbingProxy_ReachabilityController
    public typealias Verification = __VerificationProxy_ReachabilityController

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: ReachabilityController?

    public func enableDefaultImplementation(_ stub: ReachabilityController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    public  var networkPath: NWPath {
        get {
            return cuckoo_manager.getter(
                "networkPath",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.networkPath
            )
        }
    }


    public func getBleAvailibity() -> AnyPublisher<Reachability.BleAvailibity, Never> {
        
        return cuckoo_manager.call(
            "getBleAvailibity() -> AnyPublisher<Reachability.BleAvailibity, Never>",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getBleAvailibity()
        )
        
    }
    public func openBleSettings() {
        
        return cuckoo_manager.call(
            "openBleSettings()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.openBleSettings()
        )
        
    }

    public struct __StubbingProxy_ReachabilityController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var networkPath: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockReachabilityController,NWPath> {
            return .init(manager: cuckoo_manager, name: "networkPath")
        }
        
        func getBleAvailibity() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<Reachability.BleAvailibity, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockReachabilityController.self,
                method: "getBleAvailibity() -> AnyPublisher<Reachability.BleAvailibity, Never>",
                parameterMatchers: matchers
            ))
        }
        
        func openBleSettings() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockReachabilityController.self,
                method: "openBleSettings()",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_ReachabilityController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        var networkPath: Cuckoo.VerifyReadOnlyProperty<NWPath> {
            return .init(manager: cuckoo_manager, name: "networkPath", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    
        
        @discardableResult
        func getBleAvailibity() -> Cuckoo.__DoNotUse<(), AnyPublisher<Reachability.BleAvailibity, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getBleAvailibity() -> AnyPublisher<Reachability.BleAvailibity, Never>",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func openBleSettings() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "openBleSettings()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class ReachabilityControllerStub:ReachabilityController {
    
    public  var networkPath: NWPath {
        get {
            return DefaultValueRegistry.defaultValue(for: (NWPath).self)
        }
    }


    
    public  func getBleAvailibity() -> AnyPublisher<Reachability.BleAvailibity, Never> {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Reachability.BleAvailibity, Never>).self)
    }
    
    public  func openBleSettings() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/DI/DIGraph.swift'

import Cuckoo
import Swinject
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api

public class MockDIGraphType: DIGraphType, Cuckoo.ProtocolMock {
    public typealias MocksType = DIGraphType
    public typealias Stubbing = __StubbingProxy_DIGraphType
    public typealias Verification = __VerificationProxy_DIGraphType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: DIGraphType?

    public func enableDefaultImplementation(_ stub: DIGraphType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    public  var assembler: Assembler {
        get {
            return cuckoo_manager.getter(
                "assembler",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.assembler
            )
        }
    }


    public func lazyLoad(with p0: [Assembly]) {
        
        return cuckoo_manager.call(
            "lazyLoad(with p0: [Assembly])",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.lazyLoad(with: p0)
        )
        
    }

    public struct __StubbingProxy_DIGraphType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var assembler: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockDIGraphType,Assembler> {
            return .init(manager: cuckoo_manager, name: "assembler")
        }
        
        func lazyLoad<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<([Assembly])> where M1.MatchedType == [Assembly] {
            let matchers: [Cuckoo.ParameterMatcher<([Assembly])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDIGraphType.self,
                method: "lazyLoad(with p0: [Assembly])",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_DIGraphType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        var assembler: Cuckoo.VerifyReadOnlyProperty<Assembler> {
            return .init(manager: cuckoo_manager, name: "assembler", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    
        
        @discardableResult
        func lazyLoad<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<([Assembly]), Void> where M1.MatchedType == [Assembly] {
            let matchers: [Cuckoo.ParameterMatcher<([Assembly])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "lazyLoad(with p0: [Assembly])",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class DIGraphTypeStub:DIGraphType {
    
    public  var assembler: Assembler {
        get {
            return DefaultValueRegistry.defaultValue(for: (Assembler).self)
        }
    }


    
    public  func lazyLoad(with p0: [Assembly]) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Error/RuntimeError.swift'

import Cuckoo
import Foundation
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Array+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Data+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Encodable+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Error+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Locale+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/NSNotification+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Publisher+Extensions.swift'

import Cuckoo
import Foundation
import Combine
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/String+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Task+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/TimeInterval+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/URL+Extensions.swift'

import Cuckoo
import Foundation
import UIKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Functions/ConfigLogic+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Validator/FormValidator.swift'

import Cuckoo
import Foundation
import Combine
import Peppermint
import libPhoneNumber
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api

public class MockFormValidator: FormValidator, Cuckoo.ProtocolMock {
    public typealias MocksType = FormValidator
    public typealias Stubbing = __StubbingProxy_FormValidator
    public typealias Verification = __VerificationProxy_FormValidator

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: FormValidator?

    public func enableDefaultImplementation(_ stub: FormValidator) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func validateForm(form p0: ValidatableForm) -> AnyPublisher<FormValidationResult, Never> {
        
        return cuckoo_manager.call(
            "validateForm(form p0: ValidatableForm) -> AnyPublisher<FormValidationResult, Never>",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.validateForm(form: p0)
        )
        
    }
    public func validateForms(forms p0: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never> {
        
        return cuckoo_manager.call(
            "validateForms(forms p0: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never>",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.validateForms(forms: p0)
        )
        
    }

    public struct __StubbingProxy_FormValidator: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func validateForm<M1: Cuckoo.Matchable>(form p0: M1) -> Cuckoo.ProtocolStubFunction<(ValidatableForm), AnyPublisher<FormValidationResult, Never>> where M1.MatchedType == ValidatableForm {
            let matchers: [Cuckoo.ParameterMatcher<(ValidatableForm)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFormValidator.self,
                method: "validateForm(form p0: ValidatableForm) -> AnyPublisher<FormValidationResult, Never>",
                parameterMatchers: matchers
            ))
        }
        
        func validateForms<M1: Cuckoo.Matchable>(forms p0: M1) -> Cuckoo.ProtocolStubFunction<([ValidatableForm]), AnyPublisher<FormsValidationResult, Never>> where M1.MatchedType == [ValidatableForm] {
            let matchers: [Cuckoo.ParameterMatcher<([ValidatableForm])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFormValidator.self,
                method: "validateForms(forms p0: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never>",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_FormValidator: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
    
        
        @discardableResult
        func validateForm<M1: Cuckoo.Matchable>(form p0: M1) -> Cuckoo.__DoNotUse<(ValidatableForm), AnyPublisher<FormValidationResult, Never>> where M1.MatchedType == ValidatableForm {
            let matchers: [Cuckoo.ParameterMatcher<(ValidatableForm)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "validateForm(form p0: ValidatableForm) -> AnyPublisher<FormValidationResult, Never>",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func validateForms<M1: Cuckoo.Matchable>(forms p0: M1) -> Cuckoo.__DoNotUse<([ValidatableForm]), AnyPublisher<FormsValidationResult, Never>> where M1.MatchedType == [ValidatableForm] {
            let matchers: [Cuckoo.ParameterMatcher<([ValidatableForm])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "validateForms(forms p0: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never>",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class FormValidatorStub:FormValidator {


    
    public  func validateForm(form p0: ValidatableForm) -> AnyPublisher<FormValidationResult, Never> {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<FormValidationResult, Never>).self)
    }
    
    public  func validateForms(forms p0: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never> {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<FormsValidationResult, Never>).self)
    }
}


public class MockFormValidatorInteractor: FormValidatorInteractor, Cuckoo.ProtocolMock {
    public typealias MocksType = FormValidatorInteractor
    public typealias Stubbing = __StubbingProxy_FormValidatorInteractor
    public typealias Verification = __VerificationProxy_FormValidatorInteractor

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: FormValidatorInteractor?

    public func enableDefaultImplementation(_ stub: FormValidatorInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func validateForm(form p0: ValidatableForm) -> AnyPublisher<FormValidationResult, Never> {
        
        return cuckoo_manager.call(
            "validateForm(form p0: ValidatableForm) -> AnyPublisher<FormValidationResult, Never>",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.validateForm(form: p0)
        )
        
    }
    public func validateForms(forms p0: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never> {
        
        return cuckoo_manager.call(
            "validateForms(forms p0: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never>",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.validateForms(forms: p0)
        )
        
    }

    public struct __StubbingProxy_FormValidatorInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func validateForm<M1: Cuckoo.Matchable>(form p0: M1) -> Cuckoo.ProtocolStubFunction<(ValidatableForm), AnyPublisher<FormValidationResult, Never>> where M1.MatchedType == ValidatableForm {
            let matchers: [Cuckoo.ParameterMatcher<(ValidatableForm)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFormValidatorInteractor.self,
                method: "validateForm(form p0: ValidatableForm) -> AnyPublisher<FormValidationResult, Never>",
                parameterMatchers: matchers
            ))
        }
        
        func validateForms<M1: Cuckoo.Matchable>(forms p0: M1) -> Cuckoo.ProtocolStubFunction<([ValidatableForm]), AnyPublisher<FormsValidationResult, Never>> where M1.MatchedType == [ValidatableForm] {
            let matchers: [Cuckoo.ParameterMatcher<([ValidatableForm])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFormValidatorInteractor.self,
                method: "validateForms(forms p0: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never>",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_FormValidatorInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
    
        
        @discardableResult
        func validateForm<M1: Cuckoo.Matchable>(form p0: M1) -> Cuckoo.__DoNotUse<(ValidatableForm), AnyPublisher<FormValidationResult, Never>> where M1.MatchedType == ValidatableForm {
            let matchers: [Cuckoo.ParameterMatcher<(ValidatableForm)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "validateForm(form p0: ValidatableForm) -> AnyPublisher<FormValidationResult, Never>",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func validateForms<M1: Cuckoo.Matchable>(forms p0: M1) -> Cuckoo.__DoNotUse<([ValidatableForm]), AnyPublisher<FormsValidationResult, Never>> where M1.MatchedType == [ValidatableForm] {
            let matchers: [Cuckoo.ParameterMatcher<([ValidatableForm])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "validateForms(forms p0: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never>",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class FormValidatorInteractorStub:FormValidatorInteractor {


    
    public  func validateForm(form p0: ValidatableForm) -> AnyPublisher<FormValidationResult, Never> {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<FormValidationResult, Never>).self)
    }
    
    public  func validateForms(forms p0: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never> {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<FormsValidationResult, Never>).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Wrapper/EquatableNoop.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Config/WalletKitConfig.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api

class MockWalletKitConfig: WalletKitConfig, Cuckoo.ProtocolMock {
    typealias MocksType = WalletKitConfig
    typealias Stubbing = __StubbingProxy_WalletKitConfig
    typealias Verification = __VerificationProxy_WalletKitConfig

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: WalletKitConfig?

    func enableDefaultImplementation(_ stub: WalletKitConfig) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
     var verifierConfig: VerifierConfig {
        get {
            return cuckoo_manager.getter(
                "verifierConfig",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.verifierConfig
            )
        }
    }
     var vciConfig: VciConfig {
        get {
            return cuckoo_manager.getter(
                "vciConfig",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.vciConfig
            )
        }
    }
     var proximityConfig: ProximityConfig {
        get {
            return cuckoo_manager.getter(
                "proximityConfig",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.proximityConfig
            )
        }
    }
     var userAuthenticationRequired: Bool {
        get {
            return cuckoo_manager.getter(
                "userAuthenticationRequired",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.userAuthenticationRequired
            )
        }
    }



    struct __StubbingProxy_WalletKitConfig: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var verifierConfig: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,VerifierConfig> {
            return .init(manager: cuckoo_manager, name: "verifierConfig")
        }
        
        var vciConfig: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,VciConfig> {
            return .init(manager: cuckoo_manager, name: "vciConfig")
        }
        
        var proximityConfig: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,ProximityConfig> {
            return .init(manager: cuckoo_manager, name: "proximityConfig")
        }
        
        var userAuthenticationRequired: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,Bool> {
            return .init(manager: cuckoo_manager, name: "userAuthenticationRequired")
        }
    }

    struct __VerificationProxy_WalletKitConfig: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        var verifierConfig: Cuckoo.VerifyReadOnlyProperty<VerifierConfig> {
            return .init(manager: cuckoo_manager, name: "verifierConfig", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        var vciConfig: Cuckoo.VerifyReadOnlyProperty<VciConfig> {
            return .init(manager: cuckoo_manager, name: "vciConfig", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        var proximityConfig: Cuckoo.VerifyReadOnlyProperty<ProximityConfig> {
            return .init(manager: cuckoo_manager, name: "proximityConfig", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        var userAuthenticationRequired: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "userAuthenticationRequired", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    
    }
}

class WalletKitConfigStub:WalletKitConfig {
    
     var verifierConfig: VerifierConfig {
        get {
            return DefaultValueRegistry.defaultValue(for: (VerifierConfig).self)
        }
    }
    
     var vciConfig: VciConfig {
        get {
            return DefaultValueRegistry.defaultValue(for: (VciConfig).self)
        }
    }
    
     var proximityConfig: ProximityConfig {
        get {
            return DefaultValueRegistry.defaultValue(for: (ProximityConfig).self)
        }
    }
    
     var userAuthenticationRequired: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
    }


}




// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Controller/WalletKitController.swift'

import Cuckoo
import Foundation
import Combine
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api

public class MockWalletKitController: WalletKitController, Cuckoo.ProtocolMock {
    public typealias MocksType = WalletKitController
    public typealias Stubbing = __StubbingProxy_WalletKitController
    public typealias Verification = __VerificationProxy_WalletKitController

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: WalletKitController?

    public func enableDefaultImplementation(_ stub: WalletKitController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    public  var wallet: EudiWallet {
        get {
            return cuckoo_manager.getter(
                "wallet",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.wallet
            )
        }
    }
    public  var activeCoordinator: PresentationSessionCoordinator? {
        get {
            return cuckoo_manager.getter(
                "activeCoordinator",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.activeCoordinator
            )
        }
    }


    public func startProximityPresentation() -> PresentationSessionCoordinator {
        
        return cuckoo_manager.call(
            "startProximityPresentation() -> PresentationSessionCoordinator",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.startProximityPresentation()
        )
        
    }
    public func startSameDevicePresentation(deepLink p0: URLComponents) -> PresentationSessionCoordinator {
        
        return cuckoo_manager.call(
            "startSameDevicePresentation(deepLink p0: URLComponents) -> PresentationSessionCoordinator",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.startSameDevicePresentation(deepLink: p0)
        )
        
    }
    public func startCrossDevicePresentation(urlString p0: String) -> PresentationSessionCoordinator {
        
        return cuckoo_manager.call(
            "startCrossDevicePresentation(urlString p0: String) -> PresentationSessionCoordinator",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.startCrossDevicePresentation(urlString: p0)
        )
        
    }
    public func stopPresentation() {
        
        return cuckoo_manager.call(
            "stopPresentation()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.stopPresentation()
        )
        
    }
    public func fetchDocuments() -> [MdocDecodable] {
        
        return cuckoo_manager.call(
            "fetchDocuments() -> [MdocDecodable]",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.fetchDocuments()
        )
        
    }
    public func fetchDocuments(with p0: DocumentTypeIdentifier) -> [MdocDecodable] {
        
        return cuckoo_manager.call(
            "fetchDocuments(with p0: DocumentTypeIdentifier) -> [MdocDecodable]",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.fetchDocuments(with: p0)
        )
        
    }
    public func fetchDocuments(excluded p0: [DocumentTypeIdentifier]) -> [MdocDecodable] {
        
        return cuckoo_manager.call(
            "fetchDocuments(excluded p0: [DocumentTypeIdentifier]) -> [MdocDecodable]",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.fetchDocuments(excluded: p0)
        )
        
    }
    public func fetchMainPidDocument() -> MdocDecodable? {
        
        return cuckoo_manager.call(
            "fetchMainPidDocument() -> MdocDecodable?",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.fetchMainPidDocument()
        )
        
    }
    public func fetchDocument(with p0: String) -> MdocDecodable? {
        
        return cuckoo_manager.call(
            "fetchDocument(with p0: String) -> MdocDecodable?",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.fetchDocument(with: p0)
        )
        
    }
    public func loadSampleData(dataFiles p0: [String]) async throws {
        
        return try await cuckoo_manager.callThrows(
            "loadSampleData(dataFiles p0: [String]) async throws",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.loadSampleData(dataFiles: p0)
        )
        
    }
    public func clearDocuments() async throws {
        
        return try await cuckoo_manager.callThrows(
            "clearDocuments() async throws",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.clearDocuments()
        )
        
    }
    public func deleteDocument(with p0: String) async throws {
        
        return try await cuckoo_manager.callThrows(
            "deleteDocument(with p0: String) async throws",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.deleteDocument(with: p0)
        )
        
    }
    public func loadDocuments() async throws {
        
        return try await cuckoo_manager.callThrows(
            "loadDocuments() async throws",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.loadDocuments()
        )
        
    }
    public func issueDocument(docType p0: String, format p1: DataFormat) async throws -> WalletStorage.Document {
        
        return try await cuckoo_manager.callThrows(
            "issueDocument(docType p0: String, format p1: DataFormat) async throws -> WalletStorage.Document",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.issueDocument(docType: p0, format: p1)
        )
        
    }
    public func resolveOfferUrlDocTypes(uriOffer p0: String) async throws -> [OfferedDocModel] {
        
        return try await cuckoo_manager.callThrows(
            "resolveOfferUrlDocTypes(uriOffer p0: String) async throws -> [OfferedDocModel]",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.resolveOfferUrlDocTypes(uriOffer: p0)
        )
        
    }
    public func issueDocumentsByOfferUrl(offerUri p0: String, docTypes p1: [OfferedDocModel], format p2: DataFormat) async throws -> [WalletStorage.Document] {
        
        return try await cuckoo_manager.callThrows(
            "issueDocumentsByOfferUrl(offerUri p0: String, docTypes p1: [OfferedDocModel], format p2: DataFormat) async throws -> [WalletStorage.Document]",
            parameters: (p0, p1, p2),
            escapingParameters: (p0, p1, p2),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.issueDocumentsByOfferUrl(offerUri: p0, docTypes: p1, format: p2)
        )
        
    }
    public func valueForElementIdentifier(for p0: DocumentTypeIdentifier, with p1: String, elementIdentifier p2: String, parser p3: (String) -> String) -> MdocValue {
        			return withoutActuallyEscaping(p3, do: { (p3: @escaping (String) -> String) -> MdocValue in

        return cuckoo_manager.call(
            "valueForElementIdentifier(for p0: DocumentTypeIdentifier, with p1: String, elementIdentifier p2: String, parser p3: (String) -> String) -> MdocValue",
            parameters: (p0, p1, p2, p3),
            escapingParameters: (p0, p1, p2, { _ in fatalError("This is a stub! It's not supposed to be called!") }),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.valueForElementIdentifier(for: p0, with: p1, elementIdentifier: p2, parser: p3)
        )
        			})

    }
    public func mandatoryFields(for p0: DocumentTypeIdentifier) -> [String] {
        
        return cuckoo_manager.call(
            "mandatoryFields(for p0: DocumentTypeIdentifier) -> [String]",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.mandatoryFields(for: p0)
        )
        
    }

    public struct __StubbingProxy_WalletKitController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var wallet: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitController,EudiWallet> {
            return .init(manager: cuckoo_manager, name: "wallet")
        }
        
        var activeCoordinator: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitController,PresentationSessionCoordinator?> {
            return .init(manager: cuckoo_manager, name: "activeCoordinator")
        }
        
        func startProximityPresentation() -> Cuckoo.ProtocolStubFunction<(), PresentationSessionCoordinator> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "startProximityPresentation() -> PresentationSessionCoordinator",
                parameterMatchers: matchers
            ))
        }
        
        func startSameDevicePresentation<M1: Cuckoo.Matchable>(deepLink p0: M1) -> Cuckoo.ProtocolStubFunction<(URLComponents), PresentationSessionCoordinator> where M1.MatchedType == URLComponents {
            let matchers: [Cuckoo.ParameterMatcher<(URLComponents)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "startSameDevicePresentation(deepLink p0: URLComponents) -> PresentationSessionCoordinator",
                parameterMatchers: matchers
            ))
        }
        
        func startCrossDevicePresentation<M1: Cuckoo.Matchable>(urlString p0: M1) -> Cuckoo.ProtocolStubFunction<(String), PresentationSessionCoordinator> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "startCrossDevicePresentation(urlString p0: String) -> PresentationSessionCoordinator",
                parameterMatchers: matchers
            ))
        }
        
        func stopPresentation() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "stopPresentation()",
                parameterMatchers: matchers
            ))
        }
        
        func fetchDocuments() -> Cuckoo.ProtocolStubFunction<(), [MdocDecodable]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "fetchDocuments() -> [MdocDecodable]",
                parameterMatchers: matchers
            ))
        }
        
        func fetchDocuments<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubFunction<(DocumentTypeIdentifier), [MdocDecodable]> where M1.MatchedType == DocumentTypeIdentifier {
            let matchers: [Cuckoo.ParameterMatcher<(DocumentTypeIdentifier)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "fetchDocuments(with p0: DocumentTypeIdentifier) -> [MdocDecodable]",
                parameterMatchers: matchers
            ))
        }
        
        func fetchDocuments<M1: Cuckoo.Matchable>(excluded p0: M1) -> Cuckoo.ProtocolStubFunction<([DocumentTypeIdentifier]), [MdocDecodable]> where M1.MatchedType == [DocumentTypeIdentifier] {
            let matchers: [Cuckoo.ParameterMatcher<([DocumentTypeIdentifier])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "fetchDocuments(excluded p0: [DocumentTypeIdentifier]) -> [MdocDecodable]",
                parameterMatchers: matchers
            ))
        }
        
        func fetchMainPidDocument() -> Cuckoo.ProtocolStubFunction<(), MdocDecodable?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "fetchMainPidDocument() -> MdocDecodable?",
                parameterMatchers: matchers
            ))
        }
        
        func fetchDocument<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubFunction<(String), MdocDecodable?> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "fetchDocument(with p0: String) -> MdocDecodable?",
                parameterMatchers: matchers
            ))
        }
        
        func loadSampleData<M1: Cuckoo.Matchable>(dataFiles p0: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<([String])> where M1.MatchedType == [String] {
            let matchers: [Cuckoo.ParameterMatcher<([String])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "loadSampleData(dataFiles p0: [String]) async throws",
                parameterMatchers: matchers
            ))
        }
        
        func clearDocuments() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "clearDocuments() async throws",
                parameterMatchers: matchers
            ))
        }
        
        func deleteDocument<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "deleteDocument(with p0: String) async throws",
                parameterMatchers: matchers
            ))
        }
        
        func loadDocuments() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "loadDocuments() async throws",
                parameterMatchers: matchers
            ))
        }
        
        func issueDocument<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(docType p0: M1, format p1: M2) -> Cuckoo.ProtocolStubThrowingFunction<(String, DataFormat), WalletStorage.Document> where M1.MatchedType == String, M2.MatchedType == DataFormat {
            let matchers: [Cuckoo.ParameterMatcher<(String, DataFormat)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "issueDocument(docType p0: String, format p1: DataFormat) async throws -> WalletStorage.Document",
                parameterMatchers: matchers
            ))
        }
        
        func resolveOfferUrlDocTypes<M1: Cuckoo.Matchable>(uriOffer p0: M1) -> Cuckoo.ProtocolStubThrowingFunction<(String), [OfferedDocModel]> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "resolveOfferUrlDocTypes(uriOffer p0: String) async throws -> [OfferedDocModel]",
                parameterMatchers: matchers
            ))
        }
        
        func issueDocumentsByOfferUrl<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(offerUri p0: M1, docTypes p1: M2, format p2: M3) -> Cuckoo.ProtocolStubThrowingFunction<(String, [OfferedDocModel], DataFormat), [WalletStorage.Document]> where M1.MatchedType == String, M2.MatchedType == [OfferedDocModel], M3.MatchedType == DataFormat {
            let matchers: [Cuckoo.ParameterMatcher<(String, [OfferedDocModel], DataFormat)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "issueDocumentsByOfferUrl(offerUri p0: String, docTypes p1: [OfferedDocModel], format p2: DataFormat) async throws -> [WalletStorage.Document]",
                parameterMatchers: matchers
            ))
        }
        
        func valueForElementIdentifier<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(for p0: M1, with p1: M2, elementIdentifier p2: M3, parser p3: M4) -> Cuckoo.ProtocolStubFunction<(DocumentTypeIdentifier, String, String, (String) -> String), MdocValue> where M1.MatchedType == DocumentTypeIdentifier, M2.MatchedType == String, M3.MatchedType == String, M4.MatchedType == (String) -> String {
            let matchers: [Cuckoo.ParameterMatcher<(DocumentTypeIdentifier, String, String, (String) -> String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "valueForElementIdentifier(for p0: DocumentTypeIdentifier, with p1: String, elementIdentifier p2: String, parser p3: (String) -> String) -> MdocValue",
                parameterMatchers: matchers
            ))
        }
        
        func mandatoryFields<M1: Cuckoo.Matchable>(for p0: M1) -> Cuckoo.ProtocolStubFunction<(DocumentTypeIdentifier), [String]> where M1.MatchedType == DocumentTypeIdentifier {
            let matchers: [Cuckoo.ParameterMatcher<(DocumentTypeIdentifier)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "mandatoryFields(for p0: DocumentTypeIdentifier) -> [String]",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_WalletKitController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        var wallet: Cuckoo.VerifyReadOnlyProperty<EudiWallet> {
            return .init(manager: cuckoo_manager, name: "wallet", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        var activeCoordinator: Cuckoo.VerifyReadOnlyProperty<PresentationSessionCoordinator?> {
            return .init(manager: cuckoo_manager, name: "activeCoordinator", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    
        
        @discardableResult
        func startProximityPresentation() -> Cuckoo.__DoNotUse<(), PresentationSessionCoordinator> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "startProximityPresentation() -> PresentationSessionCoordinator",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func startSameDevicePresentation<M1: Cuckoo.Matchable>(deepLink p0: M1) -> Cuckoo.__DoNotUse<(URLComponents), PresentationSessionCoordinator> where M1.MatchedType == URLComponents {
            let matchers: [Cuckoo.ParameterMatcher<(URLComponents)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "startSameDevicePresentation(deepLink p0: URLComponents) -> PresentationSessionCoordinator",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func startCrossDevicePresentation<M1: Cuckoo.Matchable>(urlString p0: M1) -> Cuckoo.__DoNotUse<(String), PresentationSessionCoordinator> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "startCrossDevicePresentation(urlString p0: String) -> PresentationSessionCoordinator",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func stopPresentation() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stopPresentation()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func fetchDocuments() -> Cuckoo.__DoNotUse<(), [MdocDecodable]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "fetchDocuments() -> [MdocDecodable]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func fetchDocuments<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(DocumentTypeIdentifier), [MdocDecodable]> where M1.MatchedType == DocumentTypeIdentifier {
            let matchers: [Cuckoo.ParameterMatcher<(DocumentTypeIdentifier)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "fetchDocuments(with p0: DocumentTypeIdentifier) -> [MdocDecodable]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func fetchDocuments<M1: Cuckoo.Matchable>(excluded p0: M1) -> Cuckoo.__DoNotUse<([DocumentTypeIdentifier]), [MdocDecodable]> where M1.MatchedType == [DocumentTypeIdentifier] {
            let matchers: [Cuckoo.ParameterMatcher<([DocumentTypeIdentifier])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "fetchDocuments(excluded p0: [DocumentTypeIdentifier]) -> [MdocDecodable]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func fetchMainPidDocument() -> Cuckoo.__DoNotUse<(), MdocDecodable?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "fetchMainPidDocument() -> MdocDecodable?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func fetchDocument<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(String), MdocDecodable?> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "fetchDocument(with p0: String) -> MdocDecodable?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func loadSampleData<M1: Cuckoo.Matchable>(dataFiles p0: M1) -> Cuckoo.__DoNotUse<([String]), Void> where M1.MatchedType == [String] {
            let matchers: [Cuckoo.ParameterMatcher<([String])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "loadSampleData(dataFiles p0: [String]) async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func clearDocuments() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "clearDocuments() async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func deleteDocument<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "deleteDocument(with p0: String) async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func loadDocuments() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "loadDocuments() async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func issueDocument<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(docType p0: M1, format p1: M2) -> Cuckoo.__DoNotUse<(String, DataFormat), WalletStorage.Document> where M1.MatchedType == String, M2.MatchedType == DataFormat {
            let matchers: [Cuckoo.ParameterMatcher<(String, DataFormat)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "issueDocument(docType p0: String, format p1: DataFormat) async throws -> WalletStorage.Document",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func resolveOfferUrlDocTypes<M1: Cuckoo.Matchable>(uriOffer p0: M1) -> Cuckoo.__DoNotUse<(String), [OfferedDocModel]> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "resolveOfferUrlDocTypes(uriOffer p0: String) async throws -> [OfferedDocModel]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func issueDocumentsByOfferUrl<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(offerUri p0: M1, docTypes p1: M2, format p2: M3) -> Cuckoo.__DoNotUse<(String, [OfferedDocModel], DataFormat), [WalletStorage.Document]> where M1.MatchedType == String, M2.MatchedType == [OfferedDocModel], M3.MatchedType == DataFormat {
            let matchers: [Cuckoo.ParameterMatcher<(String, [OfferedDocModel], DataFormat)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return cuckoo_manager.verify(
                "issueDocumentsByOfferUrl(offerUri p0: String, docTypes p1: [OfferedDocModel], format p2: DataFormat) async throws -> [WalletStorage.Document]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func valueForElementIdentifier<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(for p0: M1, with p1: M2, elementIdentifier p2: M3, parser p3: M4) -> Cuckoo.__DoNotUse<(DocumentTypeIdentifier, String, String, (String) -> String), MdocValue> where M1.MatchedType == DocumentTypeIdentifier, M2.MatchedType == String, M3.MatchedType == String, M4.MatchedType == (String) -> String {
            let matchers: [Cuckoo.ParameterMatcher<(DocumentTypeIdentifier, String, String, (String) -> String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }]
            return cuckoo_manager.verify(
                "valueForElementIdentifier(for p0: DocumentTypeIdentifier, with p1: String, elementIdentifier p2: String, parser p3: (String) -> String) -> MdocValue",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func mandatoryFields<M1: Cuckoo.Matchable>(for p0: M1) -> Cuckoo.__DoNotUse<(DocumentTypeIdentifier), [String]> where M1.MatchedType == DocumentTypeIdentifier {
            let matchers: [Cuckoo.ParameterMatcher<(DocumentTypeIdentifier)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "mandatoryFields(for p0: DocumentTypeIdentifier) -> [String]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class WalletKitControllerStub:WalletKitController {
    
    public  var wallet: EudiWallet {
        get {
            return DefaultValueRegistry.defaultValue(for: (EudiWallet).self)
        }
    }
    
    public  var activeCoordinator: PresentationSessionCoordinator? {
        get {
            return DefaultValueRegistry.defaultValue(for: (PresentationSessionCoordinator?).self)
        }
    }


    
    public  func startProximityPresentation() -> PresentationSessionCoordinator {
        return DefaultValueRegistry.defaultValue(for: (PresentationSessionCoordinator).self)
    }
    
    public  func startSameDevicePresentation(deepLink p0: URLComponents) -> PresentationSessionCoordinator {
        return DefaultValueRegistry.defaultValue(for: (PresentationSessionCoordinator).self)
    }
    
    public  func startCrossDevicePresentation(urlString p0: String) -> PresentationSessionCoordinator {
        return DefaultValueRegistry.defaultValue(for: (PresentationSessionCoordinator).self)
    }
    
    public  func stopPresentation() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public  func fetchDocuments() -> [MdocDecodable] {
        return DefaultValueRegistry.defaultValue(for: ([MdocDecodable]).self)
    }
    
    public  func fetchDocuments(with p0: DocumentTypeIdentifier) -> [MdocDecodable] {
        return DefaultValueRegistry.defaultValue(for: ([MdocDecodable]).self)
    }
    
    public  func fetchDocuments(excluded p0: [DocumentTypeIdentifier]) -> [MdocDecodable] {
        return DefaultValueRegistry.defaultValue(for: ([MdocDecodable]).self)
    }
    
    public  func fetchMainPidDocument() -> MdocDecodable? {
        return DefaultValueRegistry.defaultValue(for: (MdocDecodable?).self)
    }
    
    public  func fetchDocument(with p0: String) -> MdocDecodable? {
        return DefaultValueRegistry.defaultValue(for: (MdocDecodable?).self)
    }
    
    public  func loadSampleData(dataFiles p0: [String]) async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public  func clearDocuments() async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public  func deleteDocument(with p0: String) async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public  func loadDocuments() async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public  func issueDocument(docType p0: String, format p1: DataFormat) async throws -> WalletStorage.Document {
        return DefaultValueRegistry.defaultValue(for: (WalletStorage.Document).self)
    }
    
    public  func resolveOfferUrlDocTypes(uriOffer p0: String) async throws -> [OfferedDocModel] {
        return DefaultValueRegistry.defaultValue(for: ([OfferedDocModel]).self)
    }
    
    public  func issueDocumentsByOfferUrl(offerUri p0: String, docTypes p1: [OfferedDocModel], format p2: DataFormat) async throws -> [WalletStorage.Document] {
        return DefaultValueRegistry.defaultValue(for: ([WalletStorage.Document]).self)
    }
    
    public  func valueForElementIdentifier(for p0: DocumentTypeIdentifier, with p1: String, elementIdentifier p2: String, parser p3: (String) -> String) -> MdocValue {
        return DefaultValueRegistry.defaultValue(for: (MdocValue).self)
    }
    
    public  func mandatoryFields(for p0: DocumentTypeIdentifier) -> [String] {
        return DefaultValueRegistry.defaultValue(for: ([String]).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Coordinator/PresentationSessionCoordinator.swift'

import Cuckoo
import Foundation
import Combine
import logic_resources
import UIKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api

public class MockPresentationSessionCoordinator: PresentationSessionCoordinator, Cuckoo.ProtocolMock {
    public typealias MocksType = PresentationSessionCoordinator
    public typealias Stubbing = __StubbingProxy_PresentationSessionCoordinator
    public typealias Verification = __VerificationProxy_PresentationSessionCoordinator

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: PresentationSessionCoordinator?

    public func enableDefaultImplementation(_ stub: PresentationSessionCoordinator) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    public  var presentationStateSubject: CurrentValueSubject<PresentationState, Never> {
        get {
            return cuckoo_manager.getter(
                "presentationStateSubject",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.presentationStateSubject
            )
        }
    }

    public required init(session p0: PresentationSession) {}

    public func initialize() async {
        
        return await cuckoo_manager.call(
            "initialize() async",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.initialize()
        )
        
    }
    public func startQrEngagement() async throws -> UIImage {
        
        return try await cuckoo_manager.callThrows(
            "startQrEngagement() async throws -> UIImage",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.startQrEngagement()
        )
        
    }
    public func requestReceived() async throws -> PresentationRequest {
        
        return try await cuckoo_manager.callThrows(
            "requestReceived() async throws -> PresentationRequest",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.requestReceived()
        )
        
    }
    public func sendResponse(response p0: RequestItemConvertible, onSuccess p1: ((URL?) -> Void)?, onCancel p2: (() -> Void)?) async throws {
        
        return try await cuckoo_manager.callThrows(
            "sendResponse(response p0: RequestItemConvertible, onSuccess p1: ((URL?) -> Void)?, onCancel p2: (() -> Void)?) async throws",
            parameters: (p0, p1, p2),
            escapingParameters: (p0, p1, p2),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.sendResponse(response: p0, onSuccess: p1, onCancel: p2)
        )
        
    }
    public func onSuccess(completion p0: () -> Void) {
        return withoutActuallyEscaping(p0, do: { (p0: @escaping () -> Void) in

        return cuckoo_manager.call(
            "onSuccess(completion p0: () -> Void)",
            parameters: (p0),
            escapingParameters: ({ () in fatalError("This is a stub! It's not supposed to be called!") }),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.onSuccess(completion: p0)
        )
        })

    }
    public func getState() async -> PresentationState {
        
        return await cuckoo_manager.call(
            "getState() async -> PresentationState",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getState()
        )
        
    }
    public func setState(presentationState p0: PresentationState) {
        
        return cuckoo_manager.call(
            "setState(presentationState p0: PresentationState)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setState(presentationState: p0)
        )
        
    }

    public struct __StubbingProxy_PresentationSessionCoordinator: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var presentationStateSubject: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockPresentationSessionCoordinator,CurrentValueSubject<PresentationState, Never>> {
            return .init(manager: cuckoo_manager, name: "presentationStateSubject")
        }
        
        func initialize() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinator.self,
                method: "initialize() async",
                parameterMatchers: matchers
            ))
        }
        
        func startQrEngagement() -> Cuckoo.ProtocolStubThrowingFunction<(), UIImage> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinator.self,
                method: "startQrEngagement() async throws -> UIImage",
                parameterMatchers: matchers
            ))
        }
        
        func requestReceived() -> Cuckoo.ProtocolStubThrowingFunction<(), PresentationRequest> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinator.self,
                method: "requestReceived() async throws -> PresentationRequest",
                parameterMatchers: matchers
            ))
        }
        
        func sendResponse<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.OptionalMatchable>(response p0: M1, onSuccess p1: M2, onCancel p2: M3) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(RequestItemConvertible, ((URL?) -> Void)?, (() -> Void)?)> where M1.MatchedType == RequestItemConvertible, M2.OptionalMatchedType == ((URL?) -> Void), M3.OptionalMatchedType == (() -> Void) {
            let matchers: [Cuckoo.ParameterMatcher<(RequestItemConvertible, ((URL?) -> Void)?, (() -> Void)?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinator.self,
                method: "sendResponse(response p0: RequestItemConvertible, onSuccess p1: ((URL?) -> Void)?, onCancel p2: (() -> Void)?) async throws",
                parameterMatchers: matchers
            ))
        }
        
        func onSuccess<M1: Cuckoo.Matchable>(completion p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(() -> Void)> where M1.MatchedType == () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinator.self,
                method: "onSuccess(completion p0: () -> Void)",
                parameterMatchers: matchers
            ))
        }
        
        func getState() -> Cuckoo.ProtocolStubFunction<(), PresentationState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinator.self,
                method: "getState() async -> PresentationState",
                parameterMatchers: matchers
            ))
        }
        
        func setState<M1: Cuckoo.Matchable>(presentationState p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(PresentationState)> where M1.MatchedType == PresentationState {
            let matchers: [Cuckoo.ParameterMatcher<(PresentationState)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinator.self,
                method: "setState(presentationState p0: PresentationState)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_PresentationSessionCoordinator: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        var presentationStateSubject: Cuckoo.VerifyReadOnlyProperty<CurrentValueSubject<PresentationState, Never>> {
            return .init(manager: cuckoo_manager, name: "presentationStateSubject", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    
        
        @discardableResult
        func initialize() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "initialize() async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func startQrEngagement() -> Cuckoo.__DoNotUse<(), UIImage> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "startQrEngagement() async throws -> UIImage",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func requestReceived() -> Cuckoo.__DoNotUse<(), PresentationRequest> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "requestReceived() async throws -> PresentationRequest",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func sendResponse<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.OptionalMatchable>(response p0: M1, onSuccess p1: M2, onCancel p2: M3) -> Cuckoo.__DoNotUse<(RequestItemConvertible, ((URL?) -> Void)?, (() -> Void)?), Void> where M1.MatchedType == RequestItemConvertible, M2.OptionalMatchedType == ((URL?) -> Void), M3.OptionalMatchedType == (() -> Void) {
            let matchers: [Cuckoo.ParameterMatcher<(RequestItemConvertible, ((URL?) -> Void)?, (() -> Void)?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return cuckoo_manager.verify(
                "sendResponse(response p0: RequestItemConvertible, onSuccess p1: ((URL?) -> Void)?, onCancel p2: (() -> Void)?) async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func onSuccess<M1: Cuckoo.Matchable>(completion p0: M1) -> Cuckoo.__DoNotUse<(() -> Void), Void> where M1.MatchedType == () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "onSuccess(completion p0: () -> Void)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func getState() -> Cuckoo.__DoNotUse<(), PresentationState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getState() async -> PresentationState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        @discardableResult
        func setState<M1: Cuckoo.Matchable>(presentationState p0: M1) -> Cuckoo.__DoNotUse<(PresentationState), Void> where M1.MatchedType == PresentationState {
            let matchers: [Cuckoo.ParameterMatcher<(PresentationState)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setState(presentationState p0: PresentationState)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class PresentationSessionCoordinatorStub:PresentationSessionCoordinator {
    
    public  var presentationStateSubject: CurrentValueSubject<PresentationState, Never> {
        get {
            return DefaultValueRegistry.defaultValue(for: (CurrentValueSubject<PresentationState, Never>).self)
        }
    }

    
    public required init(session p0: PresentationSession) {}

    
    public  func initialize() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public  func startQrEngagement() async throws -> UIImage {
        return DefaultValueRegistry.defaultValue(for: (UIImage).self)
    }
    
    public  func requestReceived() async throws -> PresentationRequest {
        return DefaultValueRegistry.defaultValue(for: (PresentationRequest).self)
    }
    
    public  func sendResponse(response p0: RequestItemConvertible, onSuccess p1: ((URL?) -> Void)?, onCancel p2: (() -> Void)?) async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public  func onSuccess(completion p0: () -> Void) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public  func getState() async -> PresentationState {
        return DefaultValueRegistry.defaultValue(for: (PresentationState).self)
    }
    
    public  func setState(presentationState p0: PresentationState) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Error/WalletCoreError.swift'

import Cuckoo
import Foundation
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Extension/MdocDecodable+Extensions.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Extension/NameValue+Extensions.swift'

import Cuckoo
import Foundation
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Extension/String+Extensions.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Extension/URLComponents+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Extension/WalletKitConfig+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Model/DocumentIdentifier.swift'

import Cuckoo
import Foundation
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Model/MdocValue.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Model/RequestItemConvertible.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_api

public class MockRequestItemConvertible: RequestItemConvertible, Cuckoo.ProtocolMock {
    public typealias MocksType = RequestItemConvertible
    public typealias Stubbing = __StubbingProxy_RequestItemConvertible
    public typealias Verification = __VerificationProxy_RequestItemConvertible

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: RequestItemConvertible?

    public func enableDefaultImplementation(_ stub: RequestItemConvertible) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func asRequestItems() -> RequestConvertibleItems {
        
        return cuckoo_manager.call(
            "asRequestItems() -> RequestConvertibleItems",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.asRequestItems()
        )
        
    }

    public struct __StubbingProxy_RequestItemConvertible: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func asRequestItems() -> Cuckoo.ProtocolStubFunction<(), RequestConvertibleItems> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRequestItemConvertible.self,
                method: "asRequestItems() -> RequestConvertibleItems",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_RequestItemConvertible: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
    
        
        @discardableResult
        func asRequestItems() -> Cuckoo.__DoNotUse<(), RequestConvertibleItems> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "asRequestItems() -> RequestConvertibleItems",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class RequestItemConvertibleStub:RequestItemConvertible {


    
    public  func asRequestItems() -> RequestConvertibleItems {
        return DefaultValueRegistry.defaultValue(for: (RequestConvertibleItems).self)
    }
}


