import Cuckoo
@testable import logic_analytics
@testable import logic_core






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
            return cuckoo_manager.getter("analyticsProviders",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.analyticsProviders)
        }
        
    }
    
    

    

    

     struct __StubbingProxy_AnalyticsConfig: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var analyticsProviders: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAnalyticsConfig, [String: AnalyticsProvider]> {
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


 class AnalyticsConfigStub: AnalyticsConfig {
    
    
    
    
     var analyticsProviders: [String: AnalyticsProvider] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String: AnalyticsProvider]).self)
        }
        
    }
    
    

    

    
}





import Cuckoo
@testable import logic_analytics
@testable import logic_core






public class MockAnalyticsControllerType: AnalyticsControllerType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = AnalyticsControllerType
    
    public typealias Stubbing = __StubbingProxy_AnalyticsControllerType
    public typealias Verification = __VerificationProxy_AnalyticsControllerType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: AnalyticsControllerType?

    public func enableDefaultImplementation(_ stub: AnalyticsControllerType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func initialize()  {
        
    return cuckoo_manager.call(
    """
    initialize()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.initialize())
        
    }
    
    
    
    
    
    public func logScreen(screen: String, arguments: [String: String])  {
        
    return cuckoo_manager.call(
    """
    logScreen(screen: String, arguments: [String: String])
    """,
            parameters: (screen, arguments),
            escapingParameters: (screen, arguments),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.logScreen(screen: screen, arguments: arguments))
        
    }
    
    
    
    
    
    public func logEvent(event: String, arguments: [String: String])  {
        
    return cuckoo_manager.call(
    """
    logEvent(event: String, arguments: [String: String])
    """,
            parameters: (event, arguments),
            escapingParameters: (event, arguments),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.logEvent(event: event, arguments: arguments))
        
    }
    
    

    public struct __StubbingProxy_AnalyticsControllerType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func initialize() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAnalyticsControllerType.self, method:
    """
    initialize()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func logScreen<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(screen: M1, arguments: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, [String: String])> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: screen) { $0.0 }, wrap(matchable: arguments) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAnalyticsControllerType.self, method:
    """
    logScreen(screen: String, arguments: [String: String])
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func logEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(event: M1, arguments: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, [String: String])> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: event) { $0.0 }, wrap(matchable: arguments) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAnalyticsControllerType.self, method:
    """
    logEvent(event: String, arguments: [String: String])
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_AnalyticsControllerType: Cuckoo.VerificationProxy {
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
    """
    initialize()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func logScreen<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(screen: M1, arguments: M2) -> Cuckoo.__DoNotUse<(String, [String: String]), Void> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: screen) { $0.0 }, wrap(matchable: arguments) { $0.1 }]
            return cuckoo_manager.verify(
    """
    logScreen(screen: String, arguments: [String: String])
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func logEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(event: M1, arguments: M2) -> Cuckoo.__DoNotUse<(String, [String: String]), Void> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: event) { $0.0 }, wrap(matchable: arguments) { $0.1 }]
            return cuckoo_manager.verify(
    """
    logEvent(event: String, arguments: [String: String])
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class AnalyticsControllerTypeStub: AnalyticsControllerType {
    

    

    
    
    
    
    public func initialize()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func logScreen(screen: String, arguments: [String: String])   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func logEvent(event: String, arguments: [String: String])   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





import Cuckoo
@testable import logic_analytics
@testable import logic_core

import Foundation

import Cuckoo
@testable import logic_analytics
@testable import logic_core

import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

import Cuckoo
@testable import logic_analytics
@testable import logic_core

import Foundation






 class MockAnalyticsConfigProviderType: AnalyticsConfigProviderType, Cuckoo.ProtocolMock {
    
     typealias MocksType = AnalyticsConfigProviderType
    
     typealias Stubbing = __StubbingProxy_AnalyticsConfigProviderType
     typealias Verification = __VerificationProxy_AnalyticsConfigProviderType

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: AnalyticsConfigProviderType?

     func enableDefaultImplementation(_ stub: AnalyticsConfigProviderType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func getConfig() -> AnalyticsConfig? {
        
    return cuckoo_manager.call(
    """
    getConfig() -> AnalyticsConfig?
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getConfig())
        
    }
    
    

     struct __StubbingProxy_AnalyticsConfigProviderType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func getConfig() -> Cuckoo.ProtocolStubFunction<(), AnalyticsConfig?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAnalyticsConfigProviderType.self, method:
    """
    getConfig() -> AnalyticsConfig?
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_AnalyticsConfigProviderType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func getConfig() -> Cuckoo.__DoNotUse<(), AnalyticsConfig?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getConfig() -> AnalyticsConfig?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class AnalyticsConfigProviderTypeStub: AnalyticsConfigProviderType {
    

    

    
    
    
    
     func getConfig() -> AnalyticsConfig?  {
        return DefaultValueRegistry.defaultValue(for: (AnalyticsConfig?).self)
    }
    
    
}





import Cuckoo
@testable import logic_analytics
@testable import logic_core






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
    

    

    

    
    
    
    
     func initialize(key: String)  {
        
    return cuckoo_manager.call(
    """
    initialize(key: String)
    """,
            parameters: (key),
            escapingParameters: (key),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.initialize(key: key))
        
    }
    
    
    
    
    
     func logScreen(screen: String, arguments: [String: String])  {
        
    return cuckoo_manager.call(
    """
    logScreen(screen: String, arguments: [String: String])
    """,
            parameters: (screen, arguments),
            escapingParameters: (screen, arguments),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.logScreen(screen: screen, arguments: arguments))
        
    }
    
    
    
    
    
     func logEvent(event: String, arguments: [String: String])  {
        
    return cuckoo_manager.call(
    """
    logEvent(event: String, arguments: [String: String])
    """,
            parameters: (event, arguments),
            escapingParameters: (event, arguments),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.logEvent(event: event, arguments: arguments))
        
    }
    
    

     struct __StubbingProxy_AnalyticsProvider: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func initialize<M1: Cuckoo.Matchable>(key: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: key) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAnalyticsProvider.self, method:
    """
    initialize(key: String)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func logScreen<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(screen: M1, arguments: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, [String: String])> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: screen) { $0.0 }, wrap(matchable: arguments) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAnalyticsProvider.self, method:
    """
    logScreen(screen: String, arguments: [String: String])
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func logEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(event: M1, arguments: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, [String: String])> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: event) { $0.0 }, wrap(matchable: arguments) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAnalyticsProvider.self, method:
    """
    logEvent(event: String, arguments: [String: String])
    """, parameterMatchers: matchers))
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
        func initialize<M1: Cuckoo.Matchable>(key: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: key) { $0 }]
            return cuckoo_manager.verify(
    """
    initialize(key: String)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func logScreen<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(screen: M1, arguments: M2) -> Cuckoo.__DoNotUse<(String, [String: String]), Void> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: screen) { $0.0 }, wrap(matchable: arguments) { $0.1 }]
            return cuckoo_manager.verify(
    """
    logScreen(screen: String, arguments: [String: String])
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func logEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(event: M1, arguments: M2) -> Cuckoo.__DoNotUse<(String, [String: String]), Void> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: event) { $0.0 }, wrap(matchable: arguments) { $0.1 }]
            return cuckoo_manager.verify(
    """
    logEvent(event: String, arguments: [String: String])
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class AnalyticsProviderStub: AnalyticsProvider {
    

    

    
    
    
    
     func initialize(key: String)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     func logScreen(screen: String, arguments: [String: String])   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     func logEvent(event: String, arguments: [String: String])   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





import Cuckoo
@testable import logic_analytics
@testable import logic_core

import Foundation






public class MockWalletKitConfig: WalletKitConfig, Cuckoo.ProtocolMock {
    
    public typealias MocksType = WalletKitConfig
    
    public typealias Stubbing = __StubbingProxy_WalletKitConfig
    public typealias Verification = __VerificationProxy_WalletKitConfig

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: WalletKitConfig?

    public func enableDefaultImplementation(_ stub: WalletKitConfig) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var verifierConfig: VerifierConfig {
        get {
            return cuckoo_manager.getter("verifierConfig",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.verifierConfig)
        }
        
    }
    
    
    
    
    
    public var vciConfig: VciConfig {
        get {
            return cuckoo_manager.getter("vciConfig",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.vciConfig)
        }
        
    }
    
    
    
    
    
    public var proximityConfig: ProximityConfig {
        get {
            return cuckoo_manager.getter("proximityConfig",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.proximityConfig)
        }
        
    }
    
    
    
    
    
    public var userAuthenticationRequired: Bool {
        get {
            return cuckoo_manager.getter("userAuthenticationRequired",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.userAuthenticationRequired)
        }
        
    }
    
    

    

    

    public struct __StubbingProxy_WalletKitConfig: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var verifierConfig: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig, VerifierConfig> {
            return .init(manager: cuckoo_manager, name: "verifierConfig")
        }
        
        
        
        
        var vciConfig: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig, VciConfig> {
            return .init(manager: cuckoo_manager, name: "vciConfig")
        }
        
        
        
        
        var proximityConfig: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig, ProximityConfig> {
            return .init(manager: cuckoo_manager, name: "proximityConfig")
        }
        
        
        
        
        var userAuthenticationRequired: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig, Bool> {
            return .init(manager: cuckoo_manager, name: "userAuthenticationRequired")
        }
        
        
        
    }

    public struct __VerificationProxy_WalletKitConfig: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
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


public class WalletKitConfigStub: WalletKitConfig {
    
    
    
    
    public var verifierConfig: VerifierConfig {
        get {
            return DefaultValueRegistry.defaultValue(for: (VerifierConfig).self)
        }
        
    }
    
    
    
    
    
    public var vciConfig: VciConfig {
        get {
            return DefaultValueRegistry.defaultValue(for: (VciConfig).self)
        }
        
    }
    
    
    
    
    
    public var proximityConfig: ProximityConfig {
        get {
            return DefaultValueRegistry.defaultValue(for: (ProximityConfig).self)
        }
        
    }
    
    
    
    
    
    public var userAuthenticationRequired: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    

    

    
}





import Cuckoo
@testable import logic_analytics
@testable import logic_core

import Foundation

import Cuckoo
@testable import logic_analytics
@testable import logic_core

import Combine
import Foundation
import logic_resources






public class MockWalletKitControllerType: WalletKitControllerType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = WalletKitControllerType
    
    public typealias Stubbing = __StubbingProxy_WalletKitControllerType
    public typealias Verification = __VerificationProxy_WalletKitControllerType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: WalletKitControllerType?

    public func enableDefaultImplementation(_ stub: WalletKitControllerType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var wallet: EudiWallet {
        get {
            return cuckoo_manager.getter("wallet",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.wallet)
        }
        
    }
    
    
    
    
    
    public var activeCoordinator: PresentationSessionCoordinatorType? {
        get {
            return cuckoo_manager.getter("activeCoordinator",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.activeCoordinator)
        }
        
    }
    
    

    

    
    
    
    
    public func startProximityPresentation() -> PresentationSessionCoordinatorType {
        
    return cuckoo_manager.call(
    """
    startProximityPresentation() -> PresentationSessionCoordinatorType
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.startProximityPresentation())
        
    }
    
    
    
    
    
    public func startSameDevicePresentation(deepLink: URLComponents) -> PresentationSessionCoordinatorType {
        
    return cuckoo_manager.call(
    """
    startSameDevicePresentation(deepLink: URLComponents) -> PresentationSessionCoordinatorType
    """,
            parameters: (deepLink),
            escapingParameters: (deepLink),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.startSameDevicePresentation(deepLink: deepLink))
        
    }
    
    
    
    
    
    public func startCrossDevicePresentation(urlString: String) -> PresentationSessionCoordinatorType {
        
    return cuckoo_manager.call(
    """
    startCrossDevicePresentation(urlString: String) -> PresentationSessionCoordinatorType
    """,
            parameters: (urlString),
            escapingParameters: (urlString),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.startCrossDevicePresentation(urlString: urlString))
        
    }
    
    
    
    
    
    public func stopPresentation()  {
        
    return cuckoo_manager.call(
    """
    stopPresentation()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.stopPresentation())
        
    }
    
    
    
    
    
    public func fetchDocuments() -> [MdocDecodable] {
        
    return cuckoo_manager.call(
    """
    fetchDocuments() -> [MdocDecodable]
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fetchDocuments())
        
    }
    
    
    
    
    
    public func fetchDocument(with id: String) -> MdocDecodable? {
        
    return cuckoo_manager.call(
    """
    fetchDocument(with: String) -> MdocDecodable?
    """,
            parameters: (id),
            escapingParameters: (id),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fetchDocument(with: id))
        
    }
    
    
    
    
    
    public func loadSampleData(dataFiles: [String]) async throws {
        
    return try await cuckoo_manager.callThrows(
    """
    loadSampleData(dataFiles: [String]) async throws
    """,
            parameters: (dataFiles),
            escapingParameters: (dataFiles),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.loadSampleData(dataFiles: dataFiles))
        
    }
    
    
    
    
    
    public func clearDocuments() async throws {
        
    return try await cuckoo_manager.callThrows(
    """
    clearDocuments() async throws
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.clearDocuments())
        
    }
    
    
    
    
    
    public func deleteDocument(with type: String) async throws {
        
    return try await cuckoo_manager.callThrows(
    """
    deleteDocument(with: String) async throws
    """,
            parameters: (type),
            escapingParameters: (type),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.deleteDocument(with: type))
        
    }
    
    
    
    
    
    public func loadDocuments() async throws {
        
    return try await cuckoo_manager.callThrows(
    """
    loadDocuments() async throws
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.loadDocuments())
        
    }
    
    
    
    
    
    public func issueDocument(docType: String, format: DataFormat) async throws -> WalletStorage.Document {
        
    return try await cuckoo_manager.callThrows(
    """
    issueDocument(docType: String, format: DataFormat) async throws -> WalletStorage.Document
    """,
            parameters: (docType, format),
            escapingParameters: (docType, format),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.issueDocument(docType: docType, format: format))
        
    }
    
    

    public struct __StubbingProxy_WalletKitControllerType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var wallet: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitControllerType, EudiWallet> {
            return .init(manager: cuckoo_manager, name: "wallet")
        }
        
        
        
        
        var activeCoordinator: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitControllerType, PresentationSessionCoordinatorType?> {
            return .init(manager: cuckoo_manager, name: "activeCoordinator")
        }
        
        
        
        
        
        func startProximityPresentation() -> Cuckoo.ProtocolStubFunction<(), PresentationSessionCoordinatorType> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitControllerType.self, method:
    """
    startProximityPresentation() -> PresentationSessionCoordinatorType
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func startSameDevicePresentation<M1: Cuckoo.Matchable>(deepLink: M1) -> Cuckoo.ProtocolStubFunction<(URLComponents), PresentationSessionCoordinatorType> where M1.MatchedType == URLComponents {
            let matchers: [Cuckoo.ParameterMatcher<(URLComponents)>] = [wrap(matchable: deepLink) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitControllerType.self, method:
    """
    startSameDevicePresentation(deepLink: URLComponents) -> PresentationSessionCoordinatorType
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func startCrossDevicePresentation<M1: Cuckoo.Matchable>(urlString: M1) -> Cuckoo.ProtocolStubFunction<(String), PresentationSessionCoordinatorType> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: urlString) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitControllerType.self, method:
    """
    startCrossDevicePresentation(urlString: String) -> PresentationSessionCoordinatorType
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func stopPresentation() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitControllerType.self, method:
    """
    stopPresentation()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fetchDocuments() -> Cuckoo.ProtocolStubFunction<(), [MdocDecodable]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitControllerType.self, method:
    """
    fetchDocuments() -> [MdocDecodable]
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fetchDocument<M1: Cuckoo.Matchable>(with id: M1) -> Cuckoo.ProtocolStubFunction<(String), MdocDecodable?> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: id) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitControllerType.self, method:
    """
    fetchDocument(with: String) -> MdocDecodable?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func loadSampleData<M1: Cuckoo.Matchable>(dataFiles: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<([String])> where M1.MatchedType == [String] {
            let matchers: [Cuckoo.ParameterMatcher<([String])>] = [wrap(matchable: dataFiles) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitControllerType.self, method:
    """
    loadSampleData(dataFiles: [String]) async throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func clearDocuments() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitControllerType.self, method:
    """
    clearDocuments() async throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func deleteDocument<M1: Cuckoo.Matchable>(with type: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: type) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitControllerType.self, method:
    """
    deleteDocument(with: String) async throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func loadDocuments() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitControllerType.self, method:
    """
    loadDocuments() async throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func issueDocument<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(docType: M1, format: M2) -> Cuckoo.ProtocolStubThrowingFunction<(String, DataFormat), WalletStorage.Document> where M1.MatchedType == String, M2.MatchedType == DataFormat {
            let matchers: [Cuckoo.ParameterMatcher<(String, DataFormat)>] = [wrap(matchable: docType) { $0.0 }, wrap(matchable: format) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitControllerType.self, method:
    """
    issueDocument(docType: String, format: DataFormat) async throws -> WalletStorage.Document
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_WalletKitControllerType: Cuckoo.VerificationProxy {
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
        
        
        
        
        var activeCoordinator: Cuckoo.VerifyReadOnlyProperty<PresentationSessionCoordinatorType?> {
            return .init(manager: cuckoo_manager, name: "activeCoordinator", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func startProximityPresentation() -> Cuckoo.__DoNotUse<(), PresentationSessionCoordinatorType> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    startProximityPresentation() -> PresentationSessionCoordinatorType
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func startSameDevicePresentation<M1: Cuckoo.Matchable>(deepLink: M1) -> Cuckoo.__DoNotUse<(URLComponents), PresentationSessionCoordinatorType> where M1.MatchedType == URLComponents {
            let matchers: [Cuckoo.ParameterMatcher<(URLComponents)>] = [wrap(matchable: deepLink) { $0 }]
            return cuckoo_manager.verify(
    """
    startSameDevicePresentation(deepLink: URLComponents) -> PresentationSessionCoordinatorType
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func startCrossDevicePresentation<M1: Cuckoo.Matchable>(urlString: M1) -> Cuckoo.__DoNotUse<(String), PresentationSessionCoordinatorType> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: urlString) { $0 }]
            return cuckoo_manager.verify(
    """
    startCrossDevicePresentation(urlString: String) -> PresentationSessionCoordinatorType
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func stopPresentation() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    stopPresentation()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func fetchDocuments() -> Cuckoo.__DoNotUse<(), [MdocDecodable]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    fetchDocuments() -> [MdocDecodable]
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func fetchDocument<M1: Cuckoo.Matchable>(with id: M1) -> Cuckoo.__DoNotUse<(String), MdocDecodable?> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: id) { $0 }]
            return cuckoo_manager.verify(
    """
    fetchDocument(with: String) -> MdocDecodable?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func loadSampleData<M1: Cuckoo.Matchable>(dataFiles: M1) -> Cuckoo.__DoNotUse<([String]), Void> where M1.MatchedType == [String] {
            let matchers: [Cuckoo.ParameterMatcher<([String])>] = [wrap(matchable: dataFiles) { $0 }]
            return cuckoo_manager.verify(
    """
    loadSampleData(dataFiles: [String]) async throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func clearDocuments() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    clearDocuments() async throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func deleteDocument<M1: Cuckoo.Matchable>(with type: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: type) { $0 }]
            return cuckoo_manager.verify(
    """
    deleteDocument(with: String) async throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func loadDocuments() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    loadDocuments() async throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func issueDocument<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(docType: M1, format: M2) -> Cuckoo.__DoNotUse<(String, DataFormat), WalletStorage.Document> where M1.MatchedType == String, M2.MatchedType == DataFormat {
            let matchers: [Cuckoo.ParameterMatcher<(String, DataFormat)>] = [wrap(matchable: docType) { $0.0 }, wrap(matchable: format) { $0.1 }]
            return cuckoo_manager.verify(
    """
    issueDocument(docType: String, format: DataFormat) async throws -> WalletStorage.Document
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class WalletKitControllerTypeStub: WalletKitControllerType {
    
    
    
    
    public var wallet: EudiWallet {
        get {
            return DefaultValueRegistry.defaultValue(for: (EudiWallet).self)
        }
        
    }
    
    
    
    
    
    public var activeCoordinator: PresentationSessionCoordinatorType? {
        get {
            return DefaultValueRegistry.defaultValue(for: (PresentationSessionCoordinatorType?).self)
        }
        
    }
    
    

    

    
    
    
    
    public func startProximityPresentation() -> PresentationSessionCoordinatorType  {
        return DefaultValueRegistry.defaultValue(for: (PresentationSessionCoordinatorType).self)
    }
    
    
    
    
    
    public func startSameDevicePresentation(deepLink: URLComponents) -> PresentationSessionCoordinatorType  {
        return DefaultValueRegistry.defaultValue(for: (PresentationSessionCoordinatorType).self)
    }
    
    
    
    
    
    public func startCrossDevicePresentation(urlString: String) -> PresentationSessionCoordinatorType  {
        return DefaultValueRegistry.defaultValue(for: (PresentationSessionCoordinatorType).self)
    }
    
    
    
    
    
    public func stopPresentation()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func fetchDocuments() -> [MdocDecodable]  {
        return DefaultValueRegistry.defaultValue(for: ([MdocDecodable]).self)
    }
    
    
    
    
    
    public func fetchDocument(with id: String) -> MdocDecodable?  {
        return DefaultValueRegistry.defaultValue(for: (MdocDecodable?).self)
    }
    
    
    
    
    
    public func loadSampleData(dataFiles: [String]) async throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func clearDocuments() async throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func deleteDocument(with type: String) async throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func loadDocuments() async throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func issueDocument(docType: String, format: DataFormat) async throws -> WalletStorage.Document  {
        return DefaultValueRegistry.defaultValue(for: (WalletStorage.Document).self)
    }
    
    
}





import Cuckoo
@testable import logic_analytics
@testable import logic_core

import Combine
import Foundation
import logic_resources






public class MockPresentationSessionCoordinatorType: PresentationSessionCoordinatorType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = PresentationSessionCoordinatorType
    
    public typealias Stubbing = __StubbingProxy_PresentationSessionCoordinatorType
    public typealias Verification = __VerificationProxy_PresentationSessionCoordinatorType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: PresentationSessionCoordinatorType?

    public func enableDefaultImplementation(_ stub: PresentationSessionCoordinatorType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var presentationStateSubject: CurrentValueSubject<PresentationState, Never> {
        get {
            return cuckoo_manager.getter("presentationStateSubject",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.presentationStateSubject)
        }
        
    }
    
    

    
    
    
    public required init(session: PresentationSession) {
        
    }
    
    

    
    
    
    
    public func initialize() async {
        
    return await cuckoo_manager.call(
    """
    initialize() async
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.initialize())
        
    }
    
    
    
    
    
    public func startQrEngagement() async throws -> Data {
        
    return try await cuckoo_manager.callThrows(
    """
    startQrEngagement() async throws -> Data
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.startQrEngagement())
        
    }
    
    
    
    
    
    public func requestReceived() async throws -> PresentationRequest {
        
    return try await cuckoo_manager.callThrows(
    """
    requestReceived() async throws -> PresentationRequest
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.requestReceived())
        
    }
    
    
    
    
    
    public func sendResponse(response: RequestItemConvertible, onSuccess: ((URL?) -> Void)?, onCancel: (() -> Void)?) async throws {
        
    return try await cuckoo_manager.callThrows(
    """
    sendResponse(response: RequestItemConvertible, onSuccess: ((URL?) -> Void)?, onCancel: (() -> Void)?) async throws
    """,
            parameters: (response, onSuccess, onCancel),
            escapingParameters: (response, onSuccess, onCancel),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.sendResponse(response: response, onSuccess: onSuccess, onCancel: onCancel))
        
    }
    
    
    
    
    
    public func onSuccess(completion: () -> Void)  {
        return withoutActuallyEscaping(completion, do: { (completion: @escaping () -> Void) -> Void in

    return cuckoo_manager.call(
    """
    onSuccess(completion: () -> Void)
    """,
            parameters: (completion),
            escapingParameters: ({ () in fatalError("This is a stub! It's not supposed to be called!") }),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.onSuccess(completion: completion))
        })

    }
    
    
    
    
    
    public func getState() async -> PresentationState {
        
    return await cuckoo_manager.call(
    """
    getState() async -> PresentationState
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.getState())
        
    }
    
    
    
    
    
    public func setState(presentationState: PresentationState)  {
        
    return cuckoo_manager.call(
    """
    setState(presentationState: PresentationState)
    """,
            parameters: (presentationState),
            escapingParameters: (presentationState),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setState(presentationState: presentationState))
        
    }
    
    

    public struct __StubbingProxy_PresentationSessionCoordinatorType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var presentationStateSubject: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockPresentationSessionCoordinatorType, CurrentValueSubject<PresentationState, Never>> {
            return .init(manager: cuckoo_manager, name: "presentationStateSubject")
        }
        
        
        
        
        
        func initialize() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinatorType.self, method:
    """
    initialize() async
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func startQrEngagement() -> Cuckoo.ProtocolStubThrowingFunction<(), Data> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinatorType.self, method:
    """
    startQrEngagement() async throws -> Data
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func requestReceived() -> Cuckoo.ProtocolStubThrowingFunction<(), PresentationRequest> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinatorType.self, method:
    """
    requestReceived() async throws -> PresentationRequest
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func sendResponse<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.OptionalMatchable>(response: M1, onSuccess: M2, onCancel: M3) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(RequestItemConvertible, ((URL?) -> Void)?, (() -> Void)?)> where M1.MatchedType == RequestItemConvertible, M2.OptionalMatchedType == ((URL?) -> Void), M3.OptionalMatchedType == (() -> Void) {
            let matchers: [Cuckoo.ParameterMatcher<(RequestItemConvertible, ((URL?) -> Void)?, (() -> Void)?)>] = [wrap(matchable: response) { $0.0 }, wrap(matchable: onSuccess) { $0.1 }, wrap(matchable: onCancel) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinatorType.self, method:
    """
    sendResponse(response: RequestItemConvertible, onSuccess: ((URL?) -> Void)?, onCancel: (() -> Void)?) async throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func onSuccess<M1: Cuckoo.Matchable>(completion: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(() -> Void)> where M1.MatchedType == () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: completion) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinatorType.self, method:
    """
    onSuccess(completion: () -> Void)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getState() -> Cuckoo.ProtocolStubFunction<(), PresentationState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinatorType.self, method:
    """
    getState() async -> PresentationState
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setState<M1: Cuckoo.Matchable>(presentationState: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(PresentationState)> where M1.MatchedType == PresentationState {
            let matchers: [Cuckoo.ParameterMatcher<(PresentationState)>] = [wrap(matchable: presentationState) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinatorType.self, method:
    """
    setState(presentationState: PresentationState)
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_PresentationSessionCoordinatorType: Cuckoo.VerificationProxy {
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
    """
    initialize() async
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func startQrEngagement() -> Cuckoo.__DoNotUse<(), Data> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    startQrEngagement() async throws -> Data
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func requestReceived() -> Cuckoo.__DoNotUse<(), PresentationRequest> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    requestReceived() async throws -> PresentationRequest
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func sendResponse<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.OptionalMatchable>(response: M1, onSuccess: M2, onCancel: M3) -> Cuckoo.__DoNotUse<(RequestItemConvertible, ((URL?) -> Void)?, (() -> Void)?), Void> where M1.MatchedType == RequestItemConvertible, M2.OptionalMatchedType == ((URL?) -> Void), M3.OptionalMatchedType == (() -> Void) {
            let matchers: [Cuckoo.ParameterMatcher<(RequestItemConvertible, ((URL?) -> Void)?, (() -> Void)?)>] = [wrap(matchable: response) { $0.0 }, wrap(matchable: onSuccess) { $0.1 }, wrap(matchable: onCancel) { $0.2 }]
            return cuckoo_manager.verify(
    """
    sendResponse(response: RequestItemConvertible, onSuccess: ((URL?) -> Void)?, onCancel: (() -> Void)?) async throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func onSuccess<M1: Cuckoo.Matchable>(completion: M1) -> Cuckoo.__DoNotUse<(() -> Void), Void> where M1.MatchedType == () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: completion) { $0 }]
            return cuckoo_manager.verify(
    """
    onSuccess(completion: () -> Void)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getState() -> Cuckoo.__DoNotUse<(), PresentationState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getState() async -> PresentationState
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setState<M1: Cuckoo.Matchable>(presentationState: M1) -> Cuckoo.__DoNotUse<(PresentationState), Void> where M1.MatchedType == PresentationState {
            let matchers: [Cuckoo.ParameterMatcher<(PresentationState)>] = [wrap(matchable: presentationState) { $0 }]
            return cuckoo_manager.verify(
    """
    setState(presentationState: PresentationState)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class PresentationSessionCoordinatorTypeStub: PresentationSessionCoordinatorType {
    
    
    
    
    public var presentationStateSubject: CurrentValueSubject<PresentationState, Never> {
        get {
            return DefaultValueRegistry.defaultValue(for: (CurrentValueSubject<PresentationState, Never>).self)
        }
        
    }
    
    

    
    
    public required init(session: PresentationSession) {
        
    }
    
    

    
    
    
    
    public func initialize() async  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func startQrEngagement() async throws -> Data  {
        return DefaultValueRegistry.defaultValue(for: (Data).self)
    }
    
    
    
    
    
    public func requestReceived() async throws -> PresentationRequest  {
        return DefaultValueRegistry.defaultValue(for: (PresentationRequest).self)
    }
    
    
    
    
    
    public func sendResponse(response: RequestItemConvertible, onSuccess: ((URL?) -> Void)?, onCancel: (() -> Void)?) async throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func onSuccess(completion: () -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func getState() async -> PresentationState  {
        return DefaultValueRegistry.defaultValue(for: (PresentationState).self)
    }
    
    
    
    
    
    public func setState(presentationState: PresentationState)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





import Cuckoo
@testable import logic_analytics
@testable import logic_core

import Combine
import Foundation
import logic_resources

import Cuckoo
@testable import logic_analytics
@testable import logic_core

import Combine
import Foundation
import logic_resources

import Cuckoo
@testable import logic_analytics
@testable import logic_core

import SwiftUI
import logic_resources

import Cuckoo
@testable import logic_analytics
@testable import logic_core

import Foundation
import logic_resources

import Cuckoo
@testable import logic_analytics
@testable import logic_core

import Cuckoo
@testable import logic_analytics
@testable import logic_core

import Foundation

import Cuckoo
@testable import logic_analytics
@testable import logic_core

import EudiWalletKit
import MdocDataModel18013
import MdocDataTransfer18013
import MdocSecurity18013
import WalletStorage

import Cuckoo
@testable import logic_analytics
@testable import logic_core

import Foundation
import logic_resources

import Cuckoo
@testable import logic_analytics
@testable import logic_core

import Foundation

import Cuckoo
@testable import logic_analytics
@testable import logic_core

import Foundation






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
    """
    asRequestItems() -> RequestConvertibleItems
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.asRequestItems())
        
    }
    
    

    public struct __StubbingProxy_RequestItemConvertible: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func asRequestItems() -> Cuckoo.ProtocolStubFunction<(), RequestConvertibleItems> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRequestItemConvertible.self, method:
    """
    asRequestItems() -> RequestConvertibleItems
    """, parameterMatchers: matchers))
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
    """
    asRequestItems() -> RequestConvertibleItems
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class RequestItemConvertibleStub: RequestItemConvertible {
    

    

    
    
    
    
    public func asRequestItems() -> RequestConvertibleItems  {
        return DefaultValueRegistry.defaultValue(for: (RequestConvertibleItems).self)
    }
    
    
}





import Cuckoo
@testable import logic_analytics
@testable import logic_core

import class Foundation.Bundle






public class MockWalletKitConfigProviderType: WalletKitConfigProviderType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = WalletKitConfigProviderType
    
    public typealias Stubbing = __StubbingProxy_WalletKitConfigProviderType
    public typealias Verification = __VerificationProxy_WalletKitConfigProviderType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: WalletKitConfigProviderType?

    public func enableDefaultImplementation(_ stub: WalletKitConfigProviderType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func getWalletKitConfig() -> WalletKitConfig {
        
    return cuckoo_manager.call(
    """
    getWalletKitConfig() -> WalletKitConfig
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getWalletKitConfig())
        
    }
    
    

    public struct __StubbingProxy_WalletKitConfigProviderType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func getWalletKitConfig() -> Cuckoo.ProtocolStubFunction<(), WalletKitConfig> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitConfigProviderType.self, method:
    """
    getWalletKitConfig() -> WalletKitConfig
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_WalletKitConfigProviderType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func getWalletKitConfig() -> Cuckoo.__DoNotUse<(), WalletKitConfig> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getWalletKitConfig() -> WalletKitConfig
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class WalletKitConfigProviderTypeStub: WalletKitConfigProviderType {
    

    

    
    
    
    
    public func getWalletKitConfig() -> WalletKitConfig  {
        return DefaultValueRegistry.defaultValue(for: (WalletKitConfig).self)
    }
    
    
}




