// MARK: - Mocks generated from file: 'Modules/logic-analytics/Sources/Config/AnalyticsConfig.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication

class MockAnalyticsConfig: AnalyticsConfig, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = AnalyticsConfig
    typealias Stubbing = __StubbingProxy_AnalyticsConfig
    typealias Verification = __VerificationProxy_AnalyticsConfig

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any AnalyticsConfig)?

    func enableDefaultImplementation(_ stub: any AnalyticsConfig) {
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

class AnalyticsConfigStub:AnalyticsConfig, @unchecked Sendable {
    
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
@testable import logic_authentication

public class MockAnalyticsController: AnalyticsController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = AnalyticsController
    public typealias Stubbing = __StubbingProxy_AnalyticsController
    public typealias Verification = __VerificationProxy_AnalyticsController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any AnalyticsController)?

    public func enableDefaultImplementation(_ stub: any AnalyticsController) {
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

public class AnalyticsControllerStub:AnalyticsController, @unchecked Sendable {


    
    public func initialize() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func logScreen(screen p0: String, arguments p1: [String: String]) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func logEvent(event p0: String, arguments p1: [String: String]) {
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
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-analytics/Sources/Provider/AnalyticsProvider.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication

class MockAnalyticsProvider: AnalyticsProvider, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = AnalyticsProvider
    typealias Stubbing = __StubbingProxy_AnalyticsProvider
    typealias Verification = __VerificationProxy_AnalyticsProvider

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any AnalyticsProvider)?

    func enableDefaultImplementation(_ stub: any AnalyticsProvider) {
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

class AnalyticsProviderStub:AnalyticsProvider, @unchecked Sendable {


    
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




// MARK: - Mocks generated from file: 'Modules/logic-authentication/Sources/Controller/PinStorageController.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication

public class MockPinStorageController: PinStorageController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = PinStorageController
    public typealias Stubbing = __StubbingProxy_PinStorageController
    public typealias Verification = __VerificationProxy_PinStorageController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any PinStorageController)?

    public func enableDefaultImplementation(_ stub: any PinStorageController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    
    public func retrievePin() -> String? {
        return cuckoo_manager.call(
            "retrievePin() -> String?",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.retrievePin()
        )
    }
    
    public func setPin(with p0: String) {
        return cuckoo_manager.call(
            "setPin(with p0: String)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setPin(with: p0)
        )
    }
    
    public func isPinValid(with p0: String) -> Bool {
        return cuckoo_manager.call(
            "isPinValid(with p0: String) -> Bool",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.isPinValid(with: p0)
        )
    }

    public struct __StubbingProxy_PinStorageController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func retrievePin() -> Cuckoo.ProtocolStubFunction<(), String?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPinStorageController.self,
                method: "retrievePin() -> String?",
                parameterMatchers: matchers
            ))
        }
        
        func setPin<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPinStorageController.self,
                method: "setPin(with p0: String)",
                parameterMatchers: matchers
            ))
        }
        
        func isPinValid<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubFunction<(String), Bool> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPinStorageController.self,
                method: "isPinValid(with p0: String) -> Bool",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_PinStorageController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func retrievePin() -> Cuckoo.__DoNotUse<(), String?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "retrievePin() -> String?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setPin<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setPin(with p0: String)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func isPinValid<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(String), Bool> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "isPinValid(with p0: String) -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class PinStorageControllerStub:PinStorageController, @unchecked Sendable {


    
    public func retrievePin() -> String? {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    public func setPin(with p0: String) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func isPinValid(with p0: String) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-authentication/Sources/Controller/SystemBiometryController.swift'

import Cuckoo
import Foundation
import LocalAuthentication
import Combine
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication

public class MockSystemBiometryController: SystemBiometryController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = SystemBiometryController
    public typealias Stubbing = __StubbingProxy_SystemBiometryController
    public typealias Verification = __VerificationProxy_SystemBiometryController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any SystemBiometryController)?

    public func enableDefaultImplementation(_ stub: any SystemBiometryController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    
    public var biometryType: LABiometryType {
        get {
            return cuckoo_manager.getter(
                "biometryType",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.biometryType
            )
        }
    }

    
    public func canEvaluateForBiometrics() -> AnyPublisher<Bool, SystemBiometryError> {
        return cuckoo_manager.call(
            "canEvaluateForBiometrics() -> AnyPublisher<Bool, SystemBiometryError>",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.canEvaluateForBiometrics()
        )
    }
    
    public func evaluateBiometrics() -> AnyPublisher<Void, SystemBiometryError> {
        return cuckoo_manager.call(
            "evaluateBiometrics() -> AnyPublisher<Void, SystemBiometryError>",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.evaluateBiometrics()
        )
    }
    
    public func requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometryError> {
        return cuckoo_manager.call(
            "requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometryError>",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.requestBiometricUnlock()
        )
    }

    public struct __StubbingProxy_SystemBiometryController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var biometryType: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSystemBiometryController,LABiometryType> {
            return .init(manager: cuckoo_manager, name: "biometryType")
        }
        
        func canEvaluateForBiometrics() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<Bool, SystemBiometryError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometryController.self,
                method: "canEvaluateForBiometrics() -> AnyPublisher<Bool, SystemBiometryError>",
                parameterMatchers: matchers
            ))
        }
        
        func evaluateBiometrics() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<Void, SystemBiometryError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometryController.self,
                method: "evaluateBiometrics() -> AnyPublisher<Void, SystemBiometryError>",
                parameterMatchers: matchers
            ))
        }
        
        func requestBiometricUnlock() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<Void, SystemBiometryError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometryController.self,
                method: "requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometryError>",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_SystemBiometryController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var biometryType: Cuckoo.VerifyReadOnlyProperty<LABiometryType> {
            return .init(manager: cuckoo_manager, name: "biometryType", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        @discardableResult
        func canEvaluateForBiometrics() -> Cuckoo.__DoNotUse<(), AnyPublisher<Bool, SystemBiometryError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "canEvaluateForBiometrics() -> AnyPublisher<Bool, SystemBiometryError>",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func evaluateBiometrics() -> Cuckoo.__DoNotUse<(), AnyPublisher<Void, SystemBiometryError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "evaluateBiometrics() -> AnyPublisher<Void, SystemBiometryError>",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func requestBiometricUnlock() -> Cuckoo.__DoNotUse<(), AnyPublisher<Void, SystemBiometryError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometryError>",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class SystemBiometryControllerStub:SystemBiometryController, @unchecked Sendable {
    
    public var biometryType: LABiometryType {
        get {
            return DefaultValueRegistry.defaultValue(for: (LABiometryType).self)
        }
    }


    
    public func canEvaluateForBiometrics() -> AnyPublisher<Bool, SystemBiometryError> {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Bool, SystemBiometryError>).self)
    }
    
    public func evaluateBiometrics() -> AnyPublisher<Void, SystemBiometryError> {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Void, SystemBiometryError>).self)
    }
    
    public func requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometryError> {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Void, SystemBiometryError>).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-authentication/Sources/Error/AuthenticationError.swift'

import Cuckoo
import Foundation
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-authentication/Sources/Provider/PinStorageProvider.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication

class MockPinStorageProvider: PinStorageProvider, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = PinStorageProvider
    typealias Stubbing = __StubbingProxy_PinStorageProvider
    typealias Verification = __VerificationProxy_PinStorageProvider

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any PinStorageProvider)?

    func enableDefaultImplementation(_ stub: any PinStorageProvider) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    
    func retrievePin() -> String? {
        return cuckoo_manager.call(
            "retrievePin() -> String?",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.retrievePin()
        )
    }
    
    func setPin(with p0: String) {
        return cuckoo_manager.call(
            "setPin(with p0: String)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setPin(with: p0)
        )
    }
    
    func isPinValid(with p0: String) -> Bool {
        return cuckoo_manager.call(
            "isPinValid(with p0: String) -> Bool",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.isPinValid(with: p0)
        )
    }

    struct __StubbingProxy_PinStorageProvider: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func retrievePin() -> Cuckoo.ProtocolStubFunction<(), String?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPinStorageProvider.self,
                method: "retrievePin() -> String?",
                parameterMatchers: matchers
            ))
        }
        
        func setPin<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPinStorageProvider.self,
                method: "setPin(with p0: String)",
                parameterMatchers: matchers
            ))
        }
        
        func isPinValid<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubFunction<(String), Bool> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPinStorageProvider.self,
                method: "isPinValid(with p0: String) -> Bool",
                parameterMatchers: matchers
            ))
        }
    }

    struct __VerificationProxy_PinStorageProvider: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func retrievePin() -> Cuckoo.__DoNotUse<(), String?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "retrievePin() -> String?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setPin<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setPin(with p0: String)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func isPinValid<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(String), Bool> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "isPinValid(with p0: String) -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

class PinStorageProviderStub:PinStorageProvider, @unchecked Sendable {


    
    func retrievePin() -> String? {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    func setPin(with p0: String) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    func isPinValid(with p0: String) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-authentication/Sources/Storage/KeychainPinStorageProvider.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Builder/ArrayBuilder.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Config/ConfigLogic.swift'

import Cuckoo
import Foundation
import EudiRQESUi
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication

public class MockConfigLogic: ConfigLogic, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = ConfigLogic
    public typealias Stubbing = __StubbingProxy_ConfigLogic
    public typealias Verification = __VerificationProxy_ConfigLogic

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any ConfigLogic)?

    public func enableDefaultImplementation(_ stub: any ConfigLogic) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    
    public var walletHostUrl: String {
        get {
            return cuckoo_manager.getter(
                "walletHostUrl",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.walletHostUrl
            )
        }
    }
    
    public var appBuildType: AppBuildType {
        get {
            return cuckoo_manager.getter(
                "appBuildType",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.appBuildType
            )
        }
    }
    
    public var appBuildVariant: AppBuildVariant {
        get {
            return cuckoo_manager.getter(
                "appBuildVariant",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.appBuildVariant
            )
        }
    }
    
    public var appVersion: String {
        get {
            return cuckoo_manager.getter(
                "appVersion",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.appVersion
            )
        }
    }
    
    public var rqesConfig: EudiRQESUiConfig {
        get {
            return cuckoo_manager.getter(
                "rqesConfig",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.rqesConfig
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
        
        var appBuildVariant: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigLogic,AppBuildVariant> {
            return .init(manager: cuckoo_manager, name: "appBuildVariant")
        }
        
        var appVersion: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigLogic,String> {
            return .init(manager: cuckoo_manager, name: "appVersion")
        }
        
        var rqesConfig: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigLogic,EudiRQESUiConfig> {
            return .init(manager: cuckoo_manager, name: "rqesConfig")
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
        
        var appBuildVariant: Cuckoo.VerifyReadOnlyProperty<AppBuildVariant> {
            return .init(manager: cuckoo_manager, name: "appBuildVariant", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var appVersion: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "appVersion", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var rqesConfig: Cuckoo.VerifyReadOnlyProperty<EudiRQESUiConfig> {
            return .init(manager: cuckoo_manager, name: "rqesConfig", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    }
}

public class ConfigLogicStub:ConfigLogic, @unchecked Sendable {
    
    public var walletHostUrl: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }
    
    public var appBuildType: AppBuildType {
        get {
            return DefaultValueRegistry.defaultValue(for: (AppBuildType).self)
        }
    }
    
    public var appBuildVariant: AppBuildVariant {
        get {
            return DefaultValueRegistry.defaultValue(for: (AppBuildVariant).self)
        }
    }
    
    public var appVersion: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }
    
    public var rqesConfig: EudiRQESUiConfig {
        get {
            return DefaultValueRegistry.defaultValue(for: (EudiRQESUiConfig).self)
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
@testable import logic_authentication

public class MockKeychainWrapper: KeychainWrapper, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = KeychainWrapper
    public typealias Stubbing = __StubbingProxy_KeychainWrapper
    public typealias Verification = __VerificationProxy_KeychainWrapper

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any KeychainWrapper)?

    public func enableDefaultImplementation(_ stub: any KeychainWrapper) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    
    public var value: String {
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

public class KeychainWrapperStub:KeychainWrapper, @unchecked Sendable {
    
    public var value: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }


}


public class MockKeyChainController: KeyChainController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = KeyChainController
    public typealias Stubbing = __StubbingProxy_KeyChainController
    public typealias Verification = __VerificationProxy_KeyChainController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any KeyChainController)?

    public func enableDefaultImplementation(_ stub: any KeyChainController) {
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

public class KeyChainControllerStub:KeyChainController, @unchecked Sendable {


    
    public func storeValue(key p0: KeychainWrapper, value p1: String) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getValue(key p0: KeychainWrapper) -> String? {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    public func removeObject(key p0: KeychainWrapper) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func validateKeyChainBiometry() throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func clearKeyChainBiometry() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func clear() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Controller/PrefsController.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication

public class MockPrefsController: PrefsController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = PrefsController
    public typealias Stubbing = __StubbingProxy_PrefsController
    public typealias Verification = __VerificationProxy_PrefsController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any PrefsController)?

    public func enableDefaultImplementation(_ stub: any PrefsController) {
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

public class PrefsControllerStub:PrefsController, @unchecked Sendable {


    
    public func setValue(_ p0: Any?, forKey p1: Prefs.Key) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getString(forKey p0: Prefs.Key) -> String? {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    public func getOptionalString(forKey p0: Prefs.Key) -> String {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
    
    public func getBool(forKey p0: Prefs.Key) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func getFloat(forKey p0: Prefs.Key) -> Float {
        return DefaultValueRegistry.defaultValue(for: (Float).self)
    }
    
    public func getInt(forKey p0: Prefs.Key) -> Int {
        return DefaultValueRegistry.defaultValue(for: (Int).self)
    }
    
    public func remove(forKey p0: Prefs.Key) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getValue(forKey p0: Prefs.Key) -> Any? {
        return DefaultValueRegistry.defaultValue(for: (Any?).self)
    }
    
    public func getUserLocale() -> String {
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
@testable import logic_authentication

public class MockReachabilityController: ReachabilityController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = ReachabilityController
    public typealias Stubbing = __StubbingProxy_ReachabilityController
    public typealias Verification = __VerificationProxy_ReachabilityController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any ReachabilityController)?

    public func enableDefaultImplementation(_ stub: any ReachabilityController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    
    public func hasInternet() -> Bool {
        return cuckoo_manager.call(
            "hasInternet() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.hasInternet()
        )
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
        
        func hasInternet() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockReachabilityController.self,
                method: "hasInternet() -> Bool",
                parameterMatchers: matchers
            ))
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
        
        
        @discardableResult
        func hasInternet() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "hasInternet() -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
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

public class ReachabilityControllerStub:ReachabilityController, @unchecked Sendable {


    
    public func hasInternet() -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func getBleAvailibity() -> AnyPublisher<Reachability.BleAvailibity, Never> {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Reachability.BleAvailibity, Never>).self)
    }
    
    public func openBleSettings() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/DI/DIGraph.swift'

import Cuckoo
import Swinject
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication

public class MockDIGraphType: DIGraphType, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = DIGraphType
    public typealias Stubbing = __StubbingProxy_DIGraphType
    public typealias Verification = __VerificationProxy_DIGraphType

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any DIGraphType)?

    public func enableDefaultImplementation(_ stub: any DIGraphType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    
    public var assembler: Assembler {
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

public class DIGraphTypeStub:DIGraphType, @unchecked Sendable {
    
    public var assembler: Assembler {
        get {
            return DefaultValueRegistry.defaultValue(for: (Assembler).self)
        }
    }


    
    public func lazyLoad(with p0: [Assembly]) {
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
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Array+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Data+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Encodable+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Error+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Int+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Locale+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/NSNotification+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Publisher+Extensions.swift'

import Cuckoo
import Foundation
import Combine
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/String+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Task+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/TimeInterval+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/URL+Extensions.swift'

import Cuckoo
import Foundation
import UIKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Functions/ConfigLogic+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Validator/FormValidator.swift'

import Cuckoo
import Foundation
import Combine
import Peppermint
import libPhoneNumber
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication

public class MockFormValidator: FormValidator, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = FormValidator
    public typealias Stubbing = __StubbingProxy_FormValidator
    public typealias Verification = __VerificationProxy_FormValidator

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any FormValidator)?

    public func enableDefaultImplementation(_ stub: any FormValidator) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    
    public func validateForm(form p0: ValidatableForm) async -> FormValidationResult {
        return await cuckoo_manager.call(
            "validateForm(form p0: ValidatableForm) async -> FormValidationResult",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.validateForm(form: p0)
        )
    }
    
    public func validateForms(forms p0: [ValidatableForm]) async -> FormsValidationResult {
        return await cuckoo_manager.call(
            "validateForms(forms p0: [ValidatableForm]) async -> FormsValidationResult",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.validateForms(forms: p0)
        )
    }

    public struct __StubbingProxy_FormValidator: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func validateForm<M1: Cuckoo.Matchable>(form p0: M1) -> Cuckoo.ProtocolStubFunction<(ValidatableForm), FormValidationResult> where M1.MatchedType == ValidatableForm {
            let matchers: [Cuckoo.ParameterMatcher<(ValidatableForm)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFormValidator.self,
                method: "validateForm(form p0: ValidatableForm) async -> FormValidationResult",
                parameterMatchers: matchers
            ))
        }
        
        func validateForms<M1: Cuckoo.Matchable>(forms p0: M1) -> Cuckoo.ProtocolStubFunction<([ValidatableForm]), FormsValidationResult> where M1.MatchedType == [ValidatableForm] {
            let matchers: [Cuckoo.ParameterMatcher<([ValidatableForm])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFormValidator.self,
                method: "validateForms(forms p0: [ValidatableForm]) async -> FormsValidationResult",
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
        func validateForm<M1: Cuckoo.Matchable>(form p0: M1) -> Cuckoo.__DoNotUse<(ValidatableForm), FormValidationResult> where M1.MatchedType == ValidatableForm {
            let matchers: [Cuckoo.ParameterMatcher<(ValidatableForm)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "validateForm(form p0: ValidatableForm) async -> FormValidationResult",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func validateForms<M1: Cuckoo.Matchable>(forms p0: M1) -> Cuckoo.__DoNotUse<([ValidatableForm]), FormsValidationResult> where M1.MatchedType == [ValidatableForm] {
            let matchers: [Cuckoo.ParameterMatcher<([ValidatableForm])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "validateForms(forms p0: [ValidatableForm]) async -> FormsValidationResult",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class FormValidatorStub:FormValidator, @unchecked Sendable {


    
    public func validateForm(form p0: ValidatableForm) async -> FormValidationResult {
        return DefaultValueRegistry.defaultValue(for: (FormValidationResult).self)
    }
    
    public func validateForms(forms p0: [ValidatableForm]) async -> FormsValidationResult {
        return DefaultValueRegistry.defaultValue(for: (FormsValidationResult).self)
    }
}


public class MockFormValidatorInteractor: FormValidatorInteractor, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = FormValidatorInteractor
    public typealias Stubbing = __StubbingProxy_FormValidatorInteractor
    public typealias Verification = __VerificationProxy_FormValidatorInteractor

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any FormValidatorInteractor)?

    public func enableDefaultImplementation(_ stub: any FormValidatorInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    
    public func validateForm(form p0: ValidatableForm) async -> FormValidationResult {
        return await cuckoo_manager.call(
            "validateForm(form p0: ValidatableForm) async -> FormValidationResult",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.validateForm(form: p0)
        )
    }
    
    public func validateForms(forms p0: [ValidatableForm]) async -> FormsValidationResult {
        return await cuckoo_manager.call(
            "validateForms(forms p0: [ValidatableForm]) async -> FormsValidationResult",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.validateForms(forms: p0)
        )
    }

    public struct __StubbingProxy_FormValidatorInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func validateForm<M1: Cuckoo.Matchable>(form p0: M1) -> Cuckoo.ProtocolStubFunction<(ValidatableForm), FormValidationResult> where M1.MatchedType == ValidatableForm {
            let matchers: [Cuckoo.ParameterMatcher<(ValidatableForm)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFormValidatorInteractor.self,
                method: "validateForm(form p0: ValidatableForm) async -> FormValidationResult",
                parameterMatchers: matchers
            ))
        }
        
        func validateForms<M1: Cuckoo.Matchable>(forms p0: M1) -> Cuckoo.ProtocolStubFunction<([ValidatableForm]), FormsValidationResult> where M1.MatchedType == [ValidatableForm] {
            let matchers: [Cuckoo.ParameterMatcher<([ValidatableForm])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFormValidatorInteractor.self,
                method: "validateForms(forms p0: [ValidatableForm]) async -> FormsValidationResult",
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
        func validateForm<M1: Cuckoo.Matchable>(form p0: M1) -> Cuckoo.__DoNotUse<(ValidatableForm), FormValidationResult> where M1.MatchedType == ValidatableForm {
            let matchers: [Cuckoo.ParameterMatcher<(ValidatableForm)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "validateForm(form p0: ValidatableForm) async -> FormValidationResult",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func validateForms<M1: Cuckoo.Matchable>(forms p0: M1) -> Cuckoo.__DoNotUse<([ValidatableForm]), FormsValidationResult> where M1.MatchedType == [ValidatableForm] {
            let matchers: [Cuckoo.ParameterMatcher<([ValidatableForm])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "validateForms(forms p0: [ValidatableForm]) async -> FormsValidationResult",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class FormValidatorInteractorStub:FormValidatorInteractor, @unchecked Sendable {


    
    public func validateForm(form p0: ValidatableForm) async -> FormValidationResult {
        return DefaultValueRegistry.defaultValue(for: (FormValidationResult).self)
    }
    
    public func validateForms(forms p0: [ValidatableForm]) async -> FormsValidationResult {
        return DefaultValueRegistry.defaultValue(for: (FormsValidationResult).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Wrapper/EquatableNoop.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Config/WalletKitConfig.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication

class MockWalletKitConfig: WalletKitConfig, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = WalletKitConfig
    typealias Stubbing = __StubbingProxy_WalletKitConfig
    typealias Verification = __VerificationProxy_WalletKitConfig

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any WalletKitConfig)?

    func enableDefaultImplementation(_ stub: any WalletKitConfig) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
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
    
    var readerConfig: ReaderConfig {
        get {
            return cuckoo_manager.getter(
                "readerConfig",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.readerConfig
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
    
    var documentStorageServiceName: String {
        get {
            return cuckoo_manager.getter(
                "documentStorageServiceName",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.documentStorageServiceName
            )
        }
    }
    
    var logFileName: String {
        get {
            return cuckoo_manager.getter(
                "logFileName",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.logFileName
            )
        }
    }


    struct __StubbingProxy_WalletKitConfig: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var vciConfig: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,VciConfig> {
            return .init(manager: cuckoo_manager, name: "vciConfig")
        }
        
        var readerConfig: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,ReaderConfig> {
            return .init(manager: cuckoo_manager, name: "readerConfig")
        }
        
        var userAuthenticationRequired: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,Bool> {
            return .init(manager: cuckoo_manager, name: "userAuthenticationRequired")
        }
        
        var documentStorageServiceName: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,String> {
            return .init(manager: cuckoo_manager, name: "documentStorageServiceName")
        }
        
        var logFileName: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,String> {
            return .init(manager: cuckoo_manager, name: "logFileName")
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
        
        var vciConfig: Cuckoo.VerifyReadOnlyProperty<VciConfig> {
            return .init(manager: cuckoo_manager, name: "vciConfig", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var readerConfig: Cuckoo.VerifyReadOnlyProperty<ReaderConfig> {
            return .init(manager: cuckoo_manager, name: "readerConfig", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var userAuthenticationRequired: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "userAuthenticationRequired", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var documentStorageServiceName: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "documentStorageServiceName", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var logFileName: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "logFileName", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    }
}

class WalletKitConfigStub:WalletKitConfig, @unchecked Sendable {
    
    var vciConfig: VciConfig {
        get {
            return DefaultValueRegistry.defaultValue(for: (VciConfig).self)
        }
    }
    
    var readerConfig: ReaderConfig {
        get {
            return DefaultValueRegistry.defaultValue(for: (ReaderConfig).self)
        }
    }
    
    var userAuthenticationRequired: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
    }
    
    var documentStorageServiceName: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }
    
    var logFileName: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
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
@testable import logic_authentication

public class MockWalletKitController: WalletKitController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = WalletKitController
    public typealias Stubbing = __StubbingProxy_WalletKitController
    public typealias Verification = __VerificationProxy_WalletKitController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any WalletKitController)?

    public func enableDefaultImplementation(_ stub: any WalletKitController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    
    public var wallet: EudiWallet {
        get {
            return cuckoo_manager.getter(
                "wallet",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.wallet
            )
        }
    }

    
    public func startProximityPresentation() async -> ProximitySessionCoordinator {
        return await cuckoo_manager.call(
            "startProximityPresentation() async -> ProximitySessionCoordinator",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.startProximityPresentation()
        )
    }
    
    public func startSameDevicePresentation(deepLink p0: URLComponents) async -> RemoteSessionCoordinator {
        return await cuckoo_manager.call(
            "startSameDevicePresentation(deepLink p0: URLComponents) async -> RemoteSessionCoordinator",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.startSameDevicePresentation(deepLink: p0)
        )
    }
    
    public func startCrossDevicePresentation(urlString p0: String) async -> RemoteSessionCoordinator {
        return await cuckoo_manager.call(
            "startCrossDevicePresentation(urlString p0: String) async -> RemoteSessionCoordinator",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.startCrossDevicePresentation(urlString: p0)
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
    
    public func fetchAllDocuments() -> [MdocDecodable] {
        return cuckoo_manager.call(
            "fetchAllDocuments() -> [MdocDecodable]",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.fetchAllDocuments()
        )
    }
    
    public func fetchDeferredDocuments() -> [WalletStorage.Document] {
        return cuckoo_manager.call(
            "fetchDeferredDocuments() -> [WalletStorage.Document]",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.fetchDeferredDocuments()
        )
    }
    
    public func fetchIssuedDocuments() -> [MdocDecodable] {
        return cuckoo_manager.call(
            "fetchIssuedDocuments() -> [MdocDecodable]",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.fetchIssuedDocuments()
        )
    }
    
    public func fetchIssuedDocuments(with p0: DocumentTypeIdentifier) -> [MdocDecodable] {
        return cuckoo_manager.call(
            "fetchIssuedDocuments(with p0: DocumentTypeIdentifier) -> [MdocDecodable]",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.fetchIssuedDocuments(with: p0)
        )
    }
    
    public func fetchIssuedDocuments(excluded p0: [DocumentTypeIdentifier]) -> [MdocDecodable] {
        return cuckoo_manager.call(
            "fetchIssuedDocuments(excluded p0: [DocumentTypeIdentifier]) -> [MdocDecodable]",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.fetchIssuedDocuments(excluded: p0)
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
    
    public func clearAllDocuments() async {
        return await cuckoo_manager.call(
            "clearAllDocuments() async",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.clearAllDocuments()
        )
    }
    
    public func clearDocuments(status p0: DocumentStatus) async throws {
        return try await cuckoo_manager.callThrows(
            "clearDocuments(status p0: DocumentStatus) async throws",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.clearDocuments(status: p0)
        )
    }
    
    public func deleteDocument(with p0: String, status p1: DocumentStatus) async throws {
        return try await cuckoo_manager.callThrows(
            "deleteDocument(with p0: String, status p1: DocumentStatus) async throws",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.deleteDocument(with: p0, status: p1)
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
    
    public func requestDeferredIssuance(with p0: WalletStorage.Document) async throws -> MdocDecodable {
        return try await cuckoo_manager.callThrows(
            "requestDeferredIssuance(with p0: WalletStorage.Document) async throws -> MdocDecodable",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.requestDeferredIssuance(with: p0)
        )
    }
    
    public func resolveOfferUrlDocTypes(uriOffer p0: String) async throws -> OfferedIssuanceModel {
        return try await cuckoo_manager.callThrows(
            "resolveOfferUrlDocTypes(uriOffer p0: String) async throws -> OfferedIssuanceModel",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.resolveOfferUrlDocTypes(uriOffer: p0)
        )
    }
    
    public func issueDocumentsByOfferUrl(offerUri p0: String, docTypes p1: [OfferedDocModel], format p2: DataFormat, txCodeValue p3: String?) async throws -> [WalletStorage.Document] {
        return try await cuckoo_manager.callThrows(
            "issueDocumentsByOfferUrl(offerUri p0: String, docTypes p1: [OfferedDocModel], format p2: DataFormat, txCodeValue p3: String?) async throws -> [WalletStorage.Document]",
            parameters: (p0, p1, p2, p3),
            escapingParameters: (p0, p1, p2, p3),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.issueDocumentsByOfferUrl(offerUri: p0, docTypes: p1, format: p2, txCodeValue: p3)
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
    
    public func retrieveLogFileUrl() -> URL? {
        return cuckoo_manager.call(
            "retrieveLogFileUrl() -> URL?",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.retrieveLogFileUrl()
        )
    }
    
    public func resumePendingIssuance(pendingDoc p0: WalletStorage.Document, webUrl p1: URL?) async throws -> WalletStorage.Document {
        return try await cuckoo_manager.callThrows(
            "resumePendingIssuance(pendingDoc p0: WalletStorage.Document, webUrl p1: URL?) async throws -> WalletStorage.Document",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.resumePendingIssuance(pendingDoc: p0, webUrl: p1)
        )
    }
    
    public func storeDynamicIssuancePendingUrl(with p0: URL) {
        return cuckoo_manager.call(
            "storeDynamicIssuancePendingUrl(with p0: URL)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.storeDynamicIssuancePendingUrl(with: p0)
        )
    }
    
    public func getDynamicIssuancePendingData() async -> DynamicIssuancePendingData? {
        return await cuckoo_manager.call(
            "getDynamicIssuancePendingData() async -> DynamicIssuancePendingData?",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getDynamicIssuancePendingData()
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
        
        func startProximityPresentation() -> Cuckoo.ProtocolStubFunction<(), ProximitySessionCoordinator> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "startProximityPresentation() async -> ProximitySessionCoordinator",
                parameterMatchers: matchers
            ))
        }
        
        func startSameDevicePresentation<M1: Cuckoo.Matchable>(deepLink p0: M1) -> Cuckoo.ProtocolStubFunction<(URLComponents), RemoteSessionCoordinator> where M1.MatchedType == URLComponents {
            let matchers: [Cuckoo.ParameterMatcher<(URLComponents)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "startSameDevicePresentation(deepLink p0: URLComponents) async -> RemoteSessionCoordinator",
                parameterMatchers: matchers
            ))
        }
        
        func startCrossDevicePresentation<M1: Cuckoo.Matchable>(urlString p0: M1) -> Cuckoo.ProtocolStubFunction<(String), RemoteSessionCoordinator> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "startCrossDevicePresentation(urlString p0: String) async -> RemoteSessionCoordinator",
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
        
        func fetchAllDocuments() -> Cuckoo.ProtocolStubFunction<(), [MdocDecodable]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "fetchAllDocuments() -> [MdocDecodable]",
                parameterMatchers: matchers
            ))
        }
        
        func fetchDeferredDocuments() -> Cuckoo.ProtocolStubFunction<(), [WalletStorage.Document]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "fetchDeferredDocuments() -> [WalletStorage.Document]",
                parameterMatchers: matchers
            ))
        }
        
        func fetchIssuedDocuments() -> Cuckoo.ProtocolStubFunction<(), [MdocDecodable]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "fetchIssuedDocuments() -> [MdocDecodable]",
                parameterMatchers: matchers
            ))
        }
        
        func fetchIssuedDocuments<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubFunction<(DocumentTypeIdentifier), [MdocDecodable]> where M1.MatchedType == DocumentTypeIdentifier {
            let matchers: [Cuckoo.ParameterMatcher<(DocumentTypeIdentifier)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "fetchIssuedDocuments(with p0: DocumentTypeIdentifier) -> [MdocDecodable]",
                parameterMatchers: matchers
            ))
        }
        
        func fetchIssuedDocuments<M1: Cuckoo.Matchable>(excluded p0: M1) -> Cuckoo.ProtocolStubFunction<([DocumentTypeIdentifier]), [MdocDecodable]> where M1.MatchedType == [DocumentTypeIdentifier] {
            let matchers: [Cuckoo.ParameterMatcher<([DocumentTypeIdentifier])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "fetchIssuedDocuments(excluded p0: [DocumentTypeIdentifier]) -> [MdocDecodable]",
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
        
        func clearAllDocuments() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "clearAllDocuments() async",
                parameterMatchers: matchers
            ))
        }
        
        func clearDocuments<M1: Cuckoo.Matchable>(status p0: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(DocumentStatus)> where M1.MatchedType == DocumentStatus {
            let matchers: [Cuckoo.ParameterMatcher<(DocumentStatus)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "clearDocuments(status p0: DocumentStatus) async throws",
                parameterMatchers: matchers
            ))
        }
        
        func deleteDocument<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(with p0: M1, status p1: M2) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(String, DocumentStatus)> where M1.MatchedType == String, M2.MatchedType == DocumentStatus {
            let matchers: [Cuckoo.ParameterMatcher<(String, DocumentStatus)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "deleteDocument(with p0: String, status p1: DocumentStatus) async throws",
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
        
        func requestDeferredIssuance<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubThrowingFunction<(WalletStorage.Document), MdocDecodable> where M1.MatchedType == WalletStorage.Document {
            let matchers: [Cuckoo.ParameterMatcher<(WalletStorage.Document)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "requestDeferredIssuance(with p0: WalletStorage.Document) async throws -> MdocDecodable",
                parameterMatchers: matchers
            ))
        }
        
        func resolveOfferUrlDocTypes<M1: Cuckoo.Matchable>(uriOffer p0: M1) -> Cuckoo.ProtocolStubThrowingFunction<(String), OfferedIssuanceModel> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "resolveOfferUrlDocTypes(uriOffer p0: String) async throws -> OfferedIssuanceModel",
                parameterMatchers: matchers
            ))
        }
        
        func issueDocumentsByOfferUrl<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.OptionalMatchable>(offerUri p0: M1, docTypes p1: M2, format p2: M3, txCodeValue p3: M4) -> Cuckoo.ProtocolStubThrowingFunction<(String, [OfferedDocModel], DataFormat, String?), [WalletStorage.Document]> where M1.MatchedType == String, M2.MatchedType == [OfferedDocModel], M3.MatchedType == DataFormat, M4.OptionalMatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, [OfferedDocModel], DataFormat, String?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "issueDocumentsByOfferUrl(offerUri p0: String, docTypes p1: [OfferedDocModel], format p2: DataFormat, txCodeValue p3: String?) async throws -> [WalletStorage.Document]",
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
        
        func retrieveLogFileUrl() -> Cuckoo.ProtocolStubFunction<(), URL?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "retrieveLogFileUrl() -> URL?",
                parameterMatchers: matchers
            ))
        }
        
        func resumePendingIssuance<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(pendingDoc p0: M1, webUrl p1: M2) -> Cuckoo.ProtocolStubThrowingFunction<(WalletStorage.Document, URL?), WalletStorage.Document> where M1.MatchedType == WalletStorage.Document, M2.OptionalMatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(WalletStorage.Document, URL?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "resumePendingIssuance(pendingDoc p0: WalletStorage.Document, webUrl p1: URL?) async throws -> WalletStorage.Document",
                parameterMatchers: matchers
            ))
        }
        
        func storeDynamicIssuancePendingUrl<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(URL)> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "storeDynamicIssuancePendingUrl(with p0: URL)",
                parameterMatchers: matchers
            ))
        }
        
        func getDynamicIssuancePendingData() -> Cuckoo.ProtocolStubFunction<(), DynamicIssuancePendingData?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "getDynamicIssuancePendingData() async -> DynamicIssuancePendingData?",
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
        
        
        @discardableResult
        func startProximityPresentation() -> Cuckoo.__DoNotUse<(), ProximitySessionCoordinator> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "startProximityPresentation() async -> ProximitySessionCoordinator",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func startSameDevicePresentation<M1: Cuckoo.Matchable>(deepLink p0: M1) -> Cuckoo.__DoNotUse<(URLComponents), RemoteSessionCoordinator> where M1.MatchedType == URLComponents {
            let matchers: [Cuckoo.ParameterMatcher<(URLComponents)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "startSameDevicePresentation(deepLink p0: URLComponents) async -> RemoteSessionCoordinator",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func startCrossDevicePresentation<M1: Cuckoo.Matchable>(urlString p0: M1) -> Cuckoo.__DoNotUse<(String), RemoteSessionCoordinator> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "startCrossDevicePresentation(urlString p0: String) async -> RemoteSessionCoordinator",
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
        func fetchAllDocuments() -> Cuckoo.__DoNotUse<(), [MdocDecodable]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "fetchAllDocuments() -> [MdocDecodable]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func fetchDeferredDocuments() -> Cuckoo.__DoNotUse<(), [WalletStorage.Document]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "fetchDeferredDocuments() -> [WalletStorage.Document]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func fetchIssuedDocuments() -> Cuckoo.__DoNotUse<(), [MdocDecodable]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "fetchIssuedDocuments() -> [MdocDecodable]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func fetchIssuedDocuments<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(DocumentTypeIdentifier), [MdocDecodable]> where M1.MatchedType == DocumentTypeIdentifier {
            let matchers: [Cuckoo.ParameterMatcher<(DocumentTypeIdentifier)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "fetchIssuedDocuments(with p0: DocumentTypeIdentifier) -> [MdocDecodable]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func fetchIssuedDocuments<M1: Cuckoo.Matchable>(excluded p0: M1) -> Cuckoo.__DoNotUse<([DocumentTypeIdentifier]), [MdocDecodable]> where M1.MatchedType == [DocumentTypeIdentifier] {
            let matchers: [Cuckoo.ParameterMatcher<([DocumentTypeIdentifier])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "fetchIssuedDocuments(excluded p0: [DocumentTypeIdentifier]) -> [MdocDecodable]",
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
        func clearAllDocuments() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "clearAllDocuments() async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func clearDocuments<M1: Cuckoo.Matchable>(status p0: M1) -> Cuckoo.__DoNotUse<(DocumentStatus), Void> where M1.MatchedType == DocumentStatus {
            let matchers: [Cuckoo.ParameterMatcher<(DocumentStatus)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "clearDocuments(status p0: DocumentStatus) async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func deleteDocument<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(with p0: M1, status p1: M2) -> Cuckoo.__DoNotUse<(String, DocumentStatus), Void> where M1.MatchedType == String, M2.MatchedType == DocumentStatus {
            let matchers: [Cuckoo.ParameterMatcher<(String, DocumentStatus)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "deleteDocument(with p0: String, status p1: DocumentStatus) async throws",
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
        func requestDeferredIssuance<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(WalletStorage.Document), MdocDecodable> where M1.MatchedType == WalletStorage.Document {
            let matchers: [Cuckoo.ParameterMatcher<(WalletStorage.Document)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "requestDeferredIssuance(with p0: WalletStorage.Document) async throws -> MdocDecodable",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func resolveOfferUrlDocTypes<M1: Cuckoo.Matchable>(uriOffer p0: M1) -> Cuckoo.__DoNotUse<(String), OfferedIssuanceModel> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "resolveOfferUrlDocTypes(uriOffer p0: String) async throws -> OfferedIssuanceModel",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func issueDocumentsByOfferUrl<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.OptionalMatchable>(offerUri p0: M1, docTypes p1: M2, format p2: M3, txCodeValue p3: M4) -> Cuckoo.__DoNotUse<(String, [OfferedDocModel], DataFormat, String?), [WalletStorage.Document]> where M1.MatchedType == String, M2.MatchedType == [OfferedDocModel], M3.MatchedType == DataFormat, M4.OptionalMatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, [OfferedDocModel], DataFormat, String?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }]
            return cuckoo_manager.verify(
                "issueDocumentsByOfferUrl(offerUri p0: String, docTypes p1: [OfferedDocModel], format p2: DataFormat, txCodeValue p3: String?) async throws -> [WalletStorage.Document]",
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
        
        
        @discardableResult
        func retrieveLogFileUrl() -> Cuckoo.__DoNotUse<(), URL?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "retrieveLogFileUrl() -> URL?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func resumePendingIssuance<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(pendingDoc p0: M1, webUrl p1: M2) -> Cuckoo.__DoNotUse<(WalletStorage.Document, URL?), WalletStorage.Document> where M1.MatchedType == WalletStorage.Document, M2.OptionalMatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(WalletStorage.Document, URL?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "resumePendingIssuance(pendingDoc p0: WalletStorage.Document, webUrl p1: URL?) async throws -> WalletStorage.Document",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func storeDynamicIssuancePendingUrl<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(URL), Void> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "storeDynamicIssuancePendingUrl(with p0: URL)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getDynamicIssuancePendingData() -> Cuckoo.__DoNotUse<(), DynamicIssuancePendingData?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getDynamicIssuancePendingData() async -> DynamicIssuancePendingData?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class WalletKitControllerStub:WalletKitController, @unchecked Sendable {
    
    public var wallet: EudiWallet {
        get {
            return DefaultValueRegistry.defaultValue(for: (EudiWallet).self)
        }
    }


    
    public func startProximityPresentation() async -> ProximitySessionCoordinator {
        return DefaultValueRegistry.defaultValue(for: (ProximitySessionCoordinator).self)
    }
    
    public func startSameDevicePresentation(deepLink p0: URLComponents) async -> RemoteSessionCoordinator {
        return DefaultValueRegistry.defaultValue(for: (RemoteSessionCoordinator).self)
    }
    
    public func startCrossDevicePresentation(urlString p0: String) async -> RemoteSessionCoordinator {
        return DefaultValueRegistry.defaultValue(for: (RemoteSessionCoordinator).self)
    }
    
    public func stopPresentation() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func fetchAllDocuments() -> [MdocDecodable] {
        return DefaultValueRegistry.defaultValue(for: ([MdocDecodable]).self)
    }
    
    public func fetchDeferredDocuments() -> [WalletStorage.Document] {
        return DefaultValueRegistry.defaultValue(for: ([WalletStorage.Document]).self)
    }
    
    public func fetchIssuedDocuments() -> [MdocDecodable] {
        return DefaultValueRegistry.defaultValue(for: ([MdocDecodable]).self)
    }
    
    public func fetchIssuedDocuments(with p0: DocumentTypeIdentifier) -> [MdocDecodable] {
        return DefaultValueRegistry.defaultValue(for: ([MdocDecodable]).self)
    }
    
    public func fetchIssuedDocuments(excluded p0: [DocumentTypeIdentifier]) -> [MdocDecodable] {
        return DefaultValueRegistry.defaultValue(for: ([MdocDecodable]).self)
    }
    
    public func fetchMainPidDocument() -> MdocDecodable? {
        return DefaultValueRegistry.defaultValue(for: (MdocDecodable?).self)
    }
    
    public func fetchDocument(with p0: String) -> MdocDecodable? {
        return DefaultValueRegistry.defaultValue(for: (MdocDecodable?).self)
    }
    
    public func loadSampleData(dataFiles p0: [String]) async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func clearAllDocuments() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func clearDocuments(status p0: DocumentStatus) async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func deleteDocument(with p0: String, status p1: DocumentStatus) async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func loadDocuments() async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func issueDocument(docType p0: String, format p1: DataFormat) async throws -> WalletStorage.Document {
        return DefaultValueRegistry.defaultValue(for: (WalletStorage.Document).self)
    }
    
    public func requestDeferredIssuance(with p0: WalletStorage.Document) async throws -> MdocDecodable {
        return DefaultValueRegistry.defaultValue(for: (MdocDecodable).self)
    }
    
    public func resolveOfferUrlDocTypes(uriOffer p0: String) async throws -> OfferedIssuanceModel {
        return DefaultValueRegistry.defaultValue(for: (OfferedIssuanceModel).self)
    }
    
    public func issueDocumentsByOfferUrl(offerUri p0: String, docTypes p1: [OfferedDocModel], format p2: DataFormat, txCodeValue p3: String?) async throws -> [WalletStorage.Document] {
        return DefaultValueRegistry.defaultValue(for: ([WalletStorage.Document]).self)
    }
    
    public func valueForElementIdentifier(for p0: DocumentTypeIdentifier, with p1: String, elementIdentifier p2: String, parser p3: (String) -> String) -> MdocValue {
        return DefaultValueRegistry.defaultValue(for: (MdocValue).self)
    }
    
    public func mandatoryFields(for p0: DocumentTypeIdentifier) -> [String] {
        return DefaultValueRegistry.defaultValue(for: ([String]).self)
    }
    
    public func retrieveLogFileUrl() -> URL? {
        return DefaultValueRegistry.defaultValue(for: (URL?).self)
    }
    
    public func resumePendingIssuance(pendingDoc p0: WalletStorage.Document, webUrl p1: URL?) async throws -> WalletStorage.Document {
        return DefaultValueRegistry.defaultValue(for: (WalletStorage.Document).self)
    }
    
    public func storeDynamicIssuancePendingUrl(with p0: URL) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getDynamicIssuancePendingData() async -> DynamicIssuancePendingData? {
        return DefaultValueRegistry.defaultValue(for: (DynamicIssuancePendingData?).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Coordinator/Model/PresentationRequest.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Coordinator/Model/PresentationSessionError.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Coordinator/Model/PresentationState.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Coordinator/ProximitySessionCoordinator.swift'

import Cuckoo
import Foundation
import Combine
import logic_resources
import UIKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication

public class MockProximitySessionCoordinator: ProximitySessionCoordinator, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = ProximitySessionCoordinator
    public typealias Stubbing = __StubbingProxy_ProximitySessionCoordinator
    public typealias Verification = __VerificationProxy_ProximitySessionCoordinator

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any ProximitySessionCoordinator)?

    public func enableDefaultImplementation(_ stub: any ProximitySessionCoordinator) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    
    public var sendableCurrentValueSubject: SendableCurrentValueSubject<PresentationState> {
        get {
            return cuckoo_manager.getter(
                "sendableCurrentValueSubject",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.sendableCurrentValueSubject
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
    
    public func sendResponse(response p0: RequestItemConvertible) async {
        return await cuckoo_manager.call(
            "sendResponse(response p0: RequestItemConvertible) async",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.sendResponse(response: p0)
        )
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
    
    public func getStream() -> AsyncStream<PresentationState> {
        return cuckoo_manager.call(
            "getStream() -> AsyncStream<PresentationState>",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getStream()
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

    public struct __StubbingProxy_ProximitySessionCoordinator: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var sendableCurrentValueSubject: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockProximitySessionCoordinator,SendableCurrentValueSubject<PresentationState>> {
            return .init(manager: cuckoo_manager, name: "sendableCurrentValueSubject")
        }
        
        func initialize() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockProximitySessionCoordinator.self,
                method: "initialize() async",
                parameterMatchers: matchers
            ))
        }
        
        func startQrEngagement() -> Cuckoo.ProtocolStubThrowingFunction<(), UIImage> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockProximitySessionCoordinator.self,
                method: "startQrEngagement() async throws -> UIImage",
                parameterMatchers: matchers
            ))
        }
        
        func requestReceived() -> Cuckoo.ProtocolStubThrowingFunction<(), PresentationRequest> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockProximitySessionCoordinator.self,
                method: "requestReceived() async throws -> PresentationRequest",
                parameterMatchers: matchers
            ))
        }
        
        func sendResponse<M1: Cuckoo.Matchable>(response p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(RequestItemConvertible)> where M1.MatchedType == RequestItemConvertible {
            let matchers: [Cuckoo.ParameterMatcher<(RequestItemConvertible)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockProximitySessionCoordinator.self,
                method: "sendResponse(response p0: RequestItemConvertible) async",
                parameterMatchers: matchers
            ))
        }
        
        func getState() -> Cuckoo.ProtocolStubFunction<(), PresentationState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockProximitySessionCoordinator.self,
                method: "getState() async -> PresentationState",
                parameterMatchers: matchers
            ))
        }
        
        func setState<M1: Cuckoo.Matchable>(presentationState p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(PresentationState)> where M1.MatchedType == PresentationState {
            let matchers: [Cuckoo.ParameterMatcher<(PresentationState)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockProximitySessionCoordinator.self,
                method: "setState(presentationState p0: PresentationState)",
                parameterMatchers: matchers
            ))
        }
        
        func getStream() -> Cuckoo.ProtocolStubFunction<(), AsyncStream<PresentationState>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockProximitySessionCoordinator.self,
                method: "getStream() -> AsyncStream<PresentationState>",
                parameterMatchers: matchers
            ))
        }
        
        func stopPresentation() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockProximitySessionCoordinator.self,
                method: "stopPresentation()",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_ProximitySessionCoordinator: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var sendableCurrentValueSubject: Cuckoo.VerifyReadOnlyProperty<SendableCurrentValueSubject<PresentationState>> {
            return .init(manager: cuckoo_manager, name: "sendableCurrentValueSubject", callMatcher: callMatcher, sourceLocation: sourceLocation)
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
        func sendResponse<M1: Cuckoo.Matchable>(response p0: M1) -> Cuckoo.__DoNotUse<(RequestItemConvertible), Void> where M1.MatchedType == RequestItemConvertible {
            let matchers: [Cuckoo.ParameterMatcher<(RequestItemConvertible)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "sendResponse(response p0: RequestItemConvertible) async",
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
        
        
        @discardableResult
        func getStream() -> Cuckoo.__DoNotUse<(), AsyncStream<PresentationState>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getStream() -> AsyncStream<PresentationState>",
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
    }
}

public class ProximitySessionCoordinatorStub:ProximitySessionCoordinator, @unchecked Sendable {
    
    public var sendableCurrentValueSubject: SendableCurrentValueSubject<PresentationState> {
        get {
            return DefaultValueRegistry.defaultValue(for: (SendableCurrentValueSubject<PresentationState>).self)
        }
    }

    
    public required init(session p0: PresentationSession) {}

    
    public func initialize() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func startQrEngagement() async throws -> UIImage {
        return DefaultValueRegistry.defaultValue(for: (UIImage).self)
    }
    
    public func requestReceived() async throws -> PresentationRequest {
        return DefaultValueRegistry.defaultValue(for: (PresentationRequest).self)
    }
    
    public func sendResponse(response p0: RequestItemConvertible) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getState() async -> PresentationState {
        return DefaultValueRegistry.defaultValue(for: (PresentationState).self)
    }
    
    public func setState(presentationState p0: PresentationState) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getStream() -> AsyncStream<PresentationState> {
        return DefaultValueRegistry.defaultValue(for: (AsyncStream<PresentationState>).self)
    }
    
    public func stopPresentation() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Coordinator/RemoteSessionCoordinator.swift'

import Cuckoo
import Foundation
import Combine
import logic_resources
import UIKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication

public class MockRemoteSessionCoordinator: RemoteSessionCoordinator, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = RemoteSessionCoordinator
    public typealias Stubbing = __StubbingProxy_RemoteSessionCoordinator
    public typealias Verification = __VerificationProxy_RemoteSessionCoordinator

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any RemoteSessionCoordinator)?

    public func enableDefaultImplementation(_ stub: any RemoteSessionCoordinator) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    
    public var sendableCurrentValueSubject: SendableCurrentValueSubject<PresentationState> {
        get {
            return cuckoo_manager.getter(
                "sendableCurrentValueSubject",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.sendableCurrentValueSubject
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
    
    public func requestReceived() async throws -> PresentationRequest {
        return try await cuckoo_manager.callThrows(
            "requestReceived() async throws -> PresentationRequest",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.requestReceived()
        )
    }
    
    public func sendResponse(response p0: RequestItemConvertible) async {
        return await cuckoo_manager.call(
            "sendResponse(response p0: RequestItemConvertible) async",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.sendResponse(response: p0)
        )
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
    
    public func getStream() -> AsyncStream<PresentationState> {
        return cuckoo_manager.call(
            "getStream() -> AsyncStream<PresentationState>",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getStream()
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
    
    public func stopPresentation() {
        return cuckoo_manager.call(
            "stopPresentation()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.stopPresentation()
        )
    }

    public struct __StubbingProxy_RemoteSessionCoordinator: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var sendableCurrentValueSubject: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockRemoteSessionCoordinator,SendableCurrentValueSubject<PresentationState>> {
            return .init(manager: cuckoo_manager, name: "sendableCurrentValueSubject")
        }
        
        func initialize() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteSessionCoordinator.self,
                method: "initialize() async",
                parameterMatchers: matchers
            ))
        }
        
        func requestReceived() -> Cuckoo.ProtocolStubThrowingFunction<(), PresentationRequest> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteSessionCoordinator.self,
                method: "requestReceived() async throws -> PresentationRequest",
                parameterMatchers: matchers
            ))
        }
        
        func sendResponse<M1: Cuckoo.Matchable>(response p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(RequestItemConvertible)> where M1.MatchedType == RequestItemConvertible {
            let matchers: [Cuckoo.ParameterMatcher<(RequestItemConvertible)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteSessionCoordinator.self,
                method: "sendResponse(response p0: RequestItemConvertible) async",
                parameterMatchers: matchers
            ))
        }
        
        func getState() -> Cuckoo.ProtocolStubFunction<(), PresentationState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteSessionCoordinator.self,
                method: "getState() async -> PresentationState",
                parameterMatchers: matchers
            ))
        }
        
        func getStream() -> Cuckoo.ProtocolStubFunction<(), AsyncStream<PresentationState>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteSessionCoordinator.self,
                method: "getStream() -> AsyncStream<PresentationState>",
                parameterMatchers: matchers
            ))
        }
        
        func setState<M1: Cuckoo.Matchable>(presentationState p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(PresentationState)> where M1.MatchedType == PresentationState {
            let matchers: [Cuckoo.ParameterMatcher<(PresentationState)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteSessionCoordinator.self,
                method: "setState(presentationState p0: PresentationState)",
                parameterMatchers: matchers
            ))
        }
        
        func stopPresentation() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteSessionCoordinator.self,
                method: "stopPresentation()",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_RemoteSessionCoordinator: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var sendableCurrentValueSubject: Cuckoo.VerifyReadOnlyProperty<SendableCurrentValueSubject<PresentationState>> {
            return .init(manager: cuckoo_manager, name: "sendableCurrentValueSubject", callMatcher: callMatcher, sourceLocation: sourceLocation)
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
        func sendResponse<M1: Cuckoo.Matchable>(response p0: M1) -> Cuckoo.__DoNotUse<(RequestItemConvertible), Void> where M1.MatchedType == RequestItemConvertible {
            let matchers: [Cuckoo.ParameterMatcher<(RequestItemConvertible)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "sendResponse(response p0: RequestItemConvertible) async",
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
        func getStream() -> Cuckoo.__DoNotUse<(), AsyncStream<PresentationState>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getStream() -> AsyncStream<PresentationState>",
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
    }
}

public class RemoteSessionCoordinatorStub:RemoteSessionCoordinator, @unchecked Sendable {
    
    public var sendableCurrentValueSubject: SendableCurrentValueSubject<PresentationState> {
        get {
            return DefaultValueRegistry.defaultValue(for: (SendableCurrentValueSubject<PresentationState>).self)
        }
    }

    
    public required init(session p0: PresentationSession) {}

    
    public func initialize() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func requestReceived() async throws -> PresentationRequest {
        return DefaultValueRegistry.defaultValue(for: (PresentationRequest).self)
    }
    
    public func sendResponse(response p0: RequestItemConvertible) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getState() async -> PresentationState {
        return DefaultValueRegistry.defaultValue(for: (PresentationState).self)
    }
    
    public func getStream() -> AsyncStream<PresentationState> {
        return DefaultValueRegistry.defaultValue(for: (AsyncStream<PresentationState>).self)
    }
    
    public func setState(presentationState p0: PresentationState) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func stopPresentation() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Coordinator/Wrapper/SessionCoordinatorHolder.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication

public class MockSessionCoordinatorHolder: SessionCoordinatorHolder, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = SessionCoordinatorHolder
    public typealias Stubbing = __StubbingProxy_SessionCoordinatorHolder
    public typealias Verification = __VerificationProxy_SessionCoordinatorHolder

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any SessionCoordinatorHolder)?

    public func enableDefaultImplementation(_ stub: any SessionCoordinatorHolder) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
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
    
    public func setActiveRemoteCoordinator(_ p0: RemoteSessionCoordinator) {
        return cuckoo_manager.call(
            "setActiveRemoteCoordinator(_ p0: RemoteSessionCoordinator)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setActiveRemoteCoordinator(p0)
        )
    }
    
    public func setActiveProximityCoordinator(_ p0: ProximitySessionCoordinator) {
        return cuckoo_manager.call(
            "setActiveProximityCoordinator(_ p0: ProximitySessionCoordinator)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setActiveProximityCoordinator(p0)
        )
    }
    
    public func getActiveRemoteCoordinator() throws -> RemoteSessionCoordinator {
        return try cuckoo_manager.callThrows(
            "getActiveRemoteCoordinator() throws -> RemoteSessionCoordinator",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getActiveRemoteCoordinator()
        )
    }
    
    public func getActiveProximityCoordinator() throws -> ProximitySessionCoordinator {
        return try cuckoo_manager.callThrows(
            "getActiveProximityCoordinator() throws -> ProximitySessionCoordinator",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getActiveProximityCoordinator()
        )
    }

    public struct __StubbingProxy_SessionCoordinatorHolder: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func clear() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSessionCoordinatorHolder.self,
                method: "clear()",
                parameterMatchers: matchers
            ))
        }
        
        func setActiveRemoteCoordinator<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(RemoteSessionCoordinator)> where M1.MatchedType == RemoteSessionCoordinator {
            let matchers: [Cuckoo.ParameterMatcher<(RemoteSessionCoordinator)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockSessionCoordinatorHolder.self,
                method: "setActiveRemoteCoordinator(_ p0: RemoteSessionCoordinator)",
                parameterMatchers: matchers
            ))
        }
        
        func setActiveProximityCoordinator<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(ProximitySessionCoordinator)> where M1.MatchedType == ProximitySessionCoordinator {
            let matchers: [Cuckoo.ParameterMatcher<(ProximitySessionCoordinator)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockSessionCoordinatorHolder.self,
                method: "setActiveProximityCoordinator(_ p0: ProximitySessionCoordinator)",
                parameterMatchers: matchers
            ))
        }
        
        func getActiveRemoteCoordinator() -> Cuckoo.ProtocolStubThrowingFunction<(), RemoteSessionCoordinator> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSessionCoordinatorHolder.self,
                method: "getActiveRemoteCoordinator() throws -> RemoteSessionCoordinator",
                parameterMatchers: matchers
            ))
        }
        
        func getActiveProximityCoordinator() -> Cuckoo.ProtocolStubThrowingFunction<(), ProximitySessionCoordinator> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSessionCoordinatorHolder.self,
                method: "getActiveProximityCoordinator() throws -> ProximitySessionCoordinator",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_SessionCoordinatorHolder: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
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
        
        
        @discardableResult
        func setActiveRemoteCoordinator<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.__DoNotUse<(RemoteSessionCoordinator), Void> where M1.MatchedType == RemoteSessionCoordinator {
            let matchers: [Cuckoo.ParameterMatcher<(RemoteSessionCoordinator)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setActiveRemoteCoordinator(_ p0: RemoteSessionCoordinator)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setActiveProximityCoordinator<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.__DoNotUse<(ProximitySessionCoordinator), Void> where M1.MatchedType == ProximitySessionCoordinator {
            let matchers: [Cuckoo.ParameterMatcher<(ProximitySessionCoordinator)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setActiveProximityCoordinator(_ p0: ProximitySessionCoordinator)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getActiveRemoteCoordinator() -> Cuckoo.__DoNotUse<(), RemoteSessionCoordinator> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getActiveRemoteCoordinator() throws -> RemoteSessionCoordinator",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getActiveProximityCoordinator() -> Cuckoo.__DoNotUse<(), ProximitySessionCoordinator> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getActiveProximityCoordinator() throws -> ProximitySessionCoordinator",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class SessionCoordinatorHolderStub:SessionCoordinatorHolder, @unchecked Sendable {


    
    public func clear() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func setActiveRemoteCoordinator(_ p0: RemoteSessionCoordinator) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func setActiveProximityCoordinator(_ p0: ProximitySessionCoordinator) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getActiveRemoteCoordinator() throws -> RemoteSessionCoordinator {
        return DefaultValueRegistry.defaultValue(for: (RemoteSessionCoordinator).self)
    }
    
    public func getActiveProximityCoordinator() throws -> ProximitySessionCoordinator {
        return DefaultValueRegistry.defaultValue(for: (ProximitySessionCoordinator).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Error/WalletCoreError.swift'

import Cuckoo
import Foundation
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Extension/MdocDecodable+Extensions.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Extension/NameValue+Extensions.swift'

import Cuckoo
import Foundation
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Extension/String+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Extension/URLComponents+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Extension/WalletKitConfig+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Extension/WalletStorage.Document+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Model/DeferrredDocument.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Model/DocumentIdentifier.swift'

import Cuckoo
import Foundation
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Model/DynamicIssuancePendingData.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Model/MdocValue.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Model/RequestItemConvertible.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_authentication

public class MockRequestItemConvertible: RequestItemConvertible, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = RequestItemConvertible
    public typealias Stubbing = __StubbingProxy_RequestItemConvertible
    public typealias Verification = __VerificationProxy_RequestItemConvertible

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any RequestItemConvertible)?

    public func enableDefaultImplementation(_ stub: any RequestItemConvertible) {
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

public class RequestItemConvertibleStub:RequestItemConvertible, @unchecked Sendable {


    
    public func asRequestItems() -> RequestConvertibleItems {
        return DefaultValueRegistry.defaultValue(for: (RequestConvertibleItems).self)
    }
}


