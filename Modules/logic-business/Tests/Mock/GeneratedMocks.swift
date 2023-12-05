import Cuckoo
@testable import logic_business

import Foundation






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
    

    
    
    
    
    public var baseHost: String {
        get {
            return cuckoo_manager.getter("baseHost",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.baseHost)
        }
        
    }
    
    
    
    
    
    public var appBuildType: AppBuildType {
        get {
            return cuckoo_manager.getter("appBuildType",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.appBuildType)
        }
        
    }
    
    
    
    
    
    public var appVersion: String {
        get {
            return cuckoo_manager.getter("appVersion",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.appVersion)
        }
        
    }
    
    

    

    

    public struct __StubbingProxy_ConfigLogic: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var baseHost: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigLogic, String> {
            return .init(manager: cuckoo_manager, name: "baseHost")
        }
        
        
        
        
        var appBuildType: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigLogic, AppBuildType> {
            return .init(manager: cuckoo_manager, name: "appBuildType")
        }
        
        
        
        
        var appVersion: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigLogic, String> {
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
    
        
        
        
        var baseHost: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "baseHost", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var appBuildType: Cuckoo.VerifyReadOnlyProperty<AppBuildType> {
            return .init(manager: cuckoo_manager, name: "appBuildType", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var appVersion: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "appVersion", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
    }
}


public class ConfigLogicStub: ConfigLogic {
    
    
    
    
    public var baseHost: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    
    
    
    
    public var appBuildType: AppBuildType {
        get {
            return DefaultValueRegistry.defaultValue(for: (AppBuildType).self)
        }
        
    }
    
    
    
    
    
    public var appVersion: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    

    

    
}





import Cuckoo
@testable import logic_business

import Foundation

import Cuckoo
@testable import logic_business

import Foundation






public class MockConfigSecurityLogic: ConfigSecurityLogic, Cuckoo.ProtocolMock {
    
    public typealias MocksType = ConfigSecurityLogic
    
    public typealias Stubbing = __StubbingProxy_ConfigSecurityLogic
    public typealias Verification = __VerificationProxy_ConfigSecurityLogic

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: ConfigSecurityLogic?

    public func enableDefaultImplementation(_ stub: ConfigSecurityLogic) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var blockRootAccess: Bool {
        get {
            return cuckoo_manager.getter("blockRootAccess",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.blockRootAccess)
        }
        
    }
    
    
    
    
    
    public var blockEmulator: Bool {
        get {
            return cuckoo_manager.getter("blockEmulator",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.blockEmulator)
        }
        
    }
    
    
    
    
    
    public var blockDebugMode: Bool {
        get {
            return cuckoo_manager.getter("blockDebugMode",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.blockDebugMode)
        }
        
    }
    
    
    
    
    
    public var blockReverseEngineering: Bool {
        get {
            return cuckoo_manager.getter("blockReverseEngineering",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.blockReverseEngineering)
        }
        
    }
    
    
    
    
    
    public var blockScreenCapture: Bool {
        get {
            return cuckoo_manager.getter("blockScreenCapture",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.blockScreenCapture)
        }
        
    }
    
    
    
    
    
    public var blockUnsecureWebContent: Bool {
        get {
            return cuckoo_manager.getter("blockUnsecureWebContent",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.blockUnsecureWebContent)
        }
        
    }
    
    
    
    
    
    public var bindToDevice: Bool {
        get {
            return cuckoo_manager.getter("bindToDevice",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.bindToDevice)
        }
        
    }
    
    
    
    
    
    public var profileInformation: (bundleId: String, signature: String)? {
        get {
            return cuckoo_manager.getter("profileInformation",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.profileInformation)
        }
        
    }
    
    
    
    
    
    public var useNetworkLogger: Bool {
        get {
            return cuckoo_manager.getter("useNetworkLogger",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.useNetworkLogger)
        }
        
    }
    
    
    
    
    
    public var networkLoggerExclusionList: [String] {
        get {
            return cuckoo_manager.getter("networkLoggerExclusionList",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.networkLoggerExclusionList)
        }
        
    }
    
    

    

    

    public struct __StubbingProxy_ConfigSecurityLogic: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var blockRootAccess: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigSecurityLogic, Bool> {
            return .init(manager: cuckoo_manager, name: "blockRootAccess")
        }
        
        
        
        
        var blockEmulator: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigSecurityLogic, Bool> {
            return .init(manager: cuckoo_manager, name: "blockEmulator")
        }
        
        
        
        
        var blockDebugMode: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigSecurityLogic, Bool> {
            return .init(manager: cuckoo_manager, name: "blockDebugMode")
        }
        
        
        
        
        var blockReverseEngineering: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigSecurityLogic, Bool> {
            return .init(manager: cuckoo_manager, name: "blockReverseEngineering")
        }
        
        
        
        
        var blockScreenCapture: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigSecurityLogic, Bool> {
            return .init(manager: cuckoo_manager, name: "blockScreenCapture")
        }
        
        
        
        
        var blockUnsecureWebContent: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigSecurityLogic, Bool> {
            return .init(manager: cuckoo_manager, name: "blockUnsecureWebContent")
        }
        
        
        
        
        var bindToDevice: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigSecurityLogic, Bool> {
            return .init(manager: cuckoo_manager, name: "bindToDevice")
        }
        
        
        
        
        var profileInformation: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigSecurityLogic, (bundleId: String, signature: String)?> {
            return .init(manager: cuckoo_manager, name: "profileInformation")
        }
        
        
        
        
        var useNetworkLogger: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigSecurityLogic, Bool> {
            return .init(manager: cuckoo_manager, name: "useNetworkLogger")
        }
        
        
        
        
        var networkLoggerExclusionList: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigSecurityLogic, [String]> {
            return .init(manager: cuckoo_manager, name: "networkLoggerExclusionList")
        }
        
        
        
    }

    public struct __VerificationProxy_ConfigSecurityLogic: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var blockRootAccess: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "blockRootAccess", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var blockEmulator: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "blockEmulator", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var blockDebugMode: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "blockDebugMode", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var blockReverseEngineering: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "blockReverseEngineering", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var blockScreenCapture: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "blockScreenCapture", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var blockUnsecureWebContent: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "blockUnsecureWebContent", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var bindToDevice: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "bindToDevice", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var profileInformation: Cuckoo.VerifyReadOnlyProperty<(bundleId: String, signature: String)?> {
            return .init(manager: cuckoo_manager, name: "profileInformation", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var useNetworkLogger: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "useNetworkLogger", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var networkLoggerExclusionList: Cuckoo.VerifyReadOnlyProperty<[String]> {
            return .init(manager: cuckoo_manager, name: "networkLoggerExclusionList", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
    }
}


public class ConfigSecurityLogicStub: ConfigSecurityLogic {
    
    
    
    
    public var blockRootAccess: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    
    
    
    public var blockEmulator: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    
    
    
    public var blockDebugMode: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    
    
    
    public var blockReverseEngineering: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    
    
    
    public var blockScreenCapture: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    
    
    
    public var blockUnsecureWebContent: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    
    
    
    public var bindToDevice: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    
    
    
    public var profileInformation: (bundleId: String, signature: String)? {
        get {
            return DefaultValueRegistry.defaultValue(for: ((bundleId: String, signature: String)?).self)
        }
        
    }
    
    
    
    
    
    public var useNetworkLogger: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    
    
    
    
    
    public var networkLoggerExclusionList: [String] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String]).self)
        }
        
    }
    
    

    

    
}





import Cuckoo
@testable import logic_business

import Foundation

import Cuckoo
@testable import logic_business

import Foundation
import KeychainAccess






public class MockKeyChainControllerType: KeyChainControllerType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = KeyChainControllerType
    
    public typealias Stubbing = __StubbingProxy_KeyChainControllerType
    public typealias Verification = __VerificationProxy_KeyChainControllerType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: KeyChainControllerType?

    public func enableDefaultImplementation(_ stub: KeyChainControllerType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func storeValue(key: KeychainWrapper, value: String)  {
        
    return cuckoo_manager.call(
    """
    storeValue(key: KeychainWrapper, value: String)
    """,
            parameters: (key, value),
            escapingParameters: (key, value),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.storeValue(key: key, value: value))
        
    }
    
    
    
    
    
    public func getValue(key: KeychainWrapper) -> String? {
        
    return cuckoo_manager.call(
    """
    getValue(key: KeychainWrapper) -> String?
    """,
            parameters: (key),
            escapingParameters: (key),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getValue(key: key))
        
    }
    
    
    
    
    
    public func removeObject(key: KeychainWrapper)  {
        
    return cuckoo_manager.call(
    """
    removeObject(key: KeychainWrapper)
    """,
            parameters: (key),
            escapingParameters: (key),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.removeObject(key: key))
        
    }
    
    
    
    
    
    public func validateKeyChainBiometry() throws {
        
    return try cuckoo_manager.callThrows(
    """
    validateKeyChainBiometry() throws
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.validateKeyChainBiometry())
        
    }
    
    
    
    
    
    public func clearKeyChainBiometry()  {
        
    return cuckoo_manager.call(
    """
    clearKeyChainBiometry()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.clearKeyChainBiometry())
        
    }
    
    
    
    
    
    public func clear()  {
        
    return cuckoo_manager.call(
    """
    clear()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.clear())
        
    }
    
    

    public struct __StubbingProxy_KeyChainControllerType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func storeValue<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(key: M1, value: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(KeychainWrapper, String)> where M1.MatchedType == KeychainWrapper, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(KeychainWrapper, String)>] = [wrap(matchable: key) { $0.0 }, wrap(matchable: value) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainControllerType.self, method:
    """
    storeValue(key: KeychainWrapper, value: String)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getValue<M1: Cuckoo.Matchable>(key: M1) -> Cuckoo.ProtocolStubFunction<(KeychainWrapper), String?> where M1.MatchedType == KeychainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeychainWrapper)>] = [wrap(matchable: key) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainControllerType.self, method:
    """
    getValue(key: KeychainWrapper) -> String?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func removeObject<M1: Cuckoo.Matchable>(key: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(KeychainWrapper)> where M1.MatchedType == KeychainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeychainWrapper)>] = [wrap(matchable: key) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainControllerType.self, method:
    """
    removeObject(key: KeychainWrapper)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func validateKeyChainBiometry() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainControllerType.self, method:
    """
    validateKeyChainBiometry() throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func clearKeyChainBiometry() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainControllerType.self, method:
    """
    clearKeyChainBiometry()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func clear() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainControllerType.self, method:
    """
    clear()
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_KeyChainControllerType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func storeValue<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(key: M1, value: M2) -> Cuckoo.__DoNotUse<(KeychainWrapper, String), Void> where M1.MatchedType == KeychainWrapper, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(KeychainWrapper, String)>] = [wrap(matchable: key) { $0.0 }, wrap(matchable: value) { $0.1 }]
            return cuckoo_manager.verify(
    """
    storeValue(key: KeychainWrapper, value: String)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getValue<M1: Cuckoo.Matchable>(key: M1) -> Cuckoo.__DoNotUse<(KeychainWrapper), String?> where M1.MatchedType == KeychainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeychainWrapper)>] = [wrap(matchable: key) { $0 }]
            return cuckoo_manager.verify(
    """
    getValue(key: KeychainWrapper) -> String?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func removeObject<M1: Cuckoo.Matchable>(key: M1) -> Cuckoo.__DoNotUse<(KeychainWrapper), Void> where M1.MatchedType == KeychainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeychainWrapper)>] = [wrap(matchable: key) { $0 }]
            return cuckoo_manager.verify(
    """
    removeObject(key: KeychainWrapper)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func validateKeyChainBiometry() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    validateKeyChainBiometry() throws
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func clearKeyChainBiometry() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    clearKeyChainBiometry()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func clear() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    clear()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class KeyChainControllerTypeStub: KeyChainControllerType {
    

    

    
    
    
    
    public func storeValue(key: KeychainWrapper, value: String)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func getValue(key: KeychainWrapper) -> String?  {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    
    
    
    
    public func removeObject(key: KeychainWrapper)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func validateKeyChainBiometry() throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func clearKeyChainBiometry()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func clear()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





import Cuckoo
@testable import logic_business

import Foundation






public class MockPrefsControllerType: PrefsControllerType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = PrefsControllerType
    
    public typealias Stubbing = __StubbingProxy_PrefsControllerType
    public typealias Verification = __VerificationProxy_PrefsControllerType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: PrefsControllerType?

    public func enableDefaultImplementation(_ stub: PrefsControllerType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func setValue(_ value: Any?, forKey: PrefsController.Key)  {
        
    return cuckoo_manager.call(
    """
    setValue(_: Any?, forKey: PrefsController.Key)
    """,
            parameters: (value, forKey),
            escapingParameters: (value, forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setValue(value, forKey: forKey))
        
    }
    
    
    
    
    
    public func getString(forKey: PrefsController.Key) -> String? {
        
    return cuckoo_manager.call(
    """
    getString(forKey: PrefsController.Key) -> String?
    """,
            parameters: (forKey),
            escapingParameters: (forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getString(forKey: forKey))
        
    }
    
    
    
    
    
    public func getOptionalString(forKey: PrefsController.Key) -> String {
        
    return cuckoo_manager.call(
    """
    getOptionalString(forKey: PrefsController.Key) -> String
    """,
            parameters: (forKey),
            escapingParameters: (forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getOptionalString(forKey: forKey))
        
    }
    
    
    
    
    
    public func getBool(forKey: PrefsController.Key) -> Bool {
        
    return cuckoo_manager.call(
    """
    getBool(forKey: PrefsController.Key) -> Bool
    """,
            parameters: (forKey),
            escapingParameters: (forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getBool(forKey: forKey))
        
    }
    
    
    
    
    
    public func getFloat(forKey: PrefsController.Key) -> Float {
        
    return cuckoo_manager.call(
    """
    getFloat(forKey: PrefsController.Key) -> Float
    """,
            parameters: (forKey),
            escapingParameters: (forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getFloat(forKey: forKey))
        
    }
    
    
    
    
    
    public func getInt(forKey: PrefsController.Key) -> Int {
        
    return cuckoo_manager.call(
    """
    getInt(forKey: PrefsController.Key) -> Int
    """,
            parameters: (forKey),
            escapingParameters: (forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getInt(forKey: forKey))
        
    }
    
    
    
    
    
    public func remove(forKey: PrefsController.Key)  {
        
    return cuckoo_manager.call(
    """
    remove(forKey: PrefsController.Key)
    """,
            parameters: (forKey),
            escapingParameters: (forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.remove(forKey: forKey))
        
    }
    
    
    
    
    
    public func getValue(forKey: PrefsController.Key) -> Any? {
        
    return cuckoo_manager.call(
    """
    getValue(forKey: PrefsController.Key) -> Any?
    """,
            parameters: (forKey),
            escapingParameters: (forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getValue(forKey: forKey))
        
    }
    
    

    public struct __StubbingProxy_PrefsControllerType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func setValue<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable>(_ value: M1, forKey: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(Any?, PrefsController.Key)> where M1.OptionalMatchedType == Any, M2.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Any?, PrefsController.Key)>] = [wrap(matchable: value) { $0.0 }, wrap(matchable: forKey) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsControllerType.self, method:
    """
    setValue(_: Any?, forKey: PrefsController.Key)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getString<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.ProtocolStubFunction<(PrefsController.Key), String?> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsControllerType.self, method:
    """
    getString(forKey: PrefsController.Key) -> String?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getOptionalString<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.ProtocolStubFunction<(PrefsController.Key), String> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsControllerType.self, method:
    """
    getOptionalString(forKey: PrefsController.Key) -> String
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getBool<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.ProtocolStubFunction<(PrefsController.Key), Bool> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsControllerType.self, method:
    """
    getBool(forKey: PrefsController.Key) -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getFloat<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.ProtocolStubFunction<(PrefsController.Key), Float> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsControllerType.self, method:
    """
    getFloat(forKey: PrefsController.Key) -> Float
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getInt<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.ProtocolStubFunction<(PrefsController.Key), Int> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsControllerType.self, method:
    """
    getInt(forKey: PrefsController.Key) -> Int
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func remove<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(PrefsController.Key)> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsControllerType.self, method:
    """
    remove(forKey: PrefsController.Key)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getValue<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.ProtocolStubFunction<(PrefsController.Key), Any?> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsControllerType.self, method:
    """
    getValue(forKey: PrefsController.Key) -> Any?
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_PrefsControllerType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func setValue<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable>(_ value: M1, forKey: M2) -> Cuckoo.__DoNotUse<(Any?, PrefsController.Key), Void> where M1.OptionalMatchedType == Any, M2.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Any?, PrefsController.Key)>] = [wrap(matchable: value) { $0.0 }, wrap(matchable: forKey) { $0.1 }]
            return cuckoo_manager.verify(
    """
    setValue(_: Any?, forKey: PrefsController.Key)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getString<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.__DoNotUse<(PrefsController.Key), String?> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return cuckoo_manager.verify(
    """
    getString(forKey: PrefsController.Key) -> String?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getOptionalString<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.__DoNotUse<(PrefsController.Key), String> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return cuckoo_manager.verify(
    """
    getOptionalString(forKey: PrefsController.Key) -> String
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getBool<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.__DoNotUse<(PrefsController.Key), Bool> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return cuckoo_manager.verify(
    """
    getBool(forKey: PrefsController.Key) -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getFloat<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.__DoNotUse<(PrefsController.Key), Float> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return cuckoo_manager.verify(
    """
    getFloat(forKey: PrefsController.Key) -> Float
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getInt<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.__DoNotUse<(PrefsController.Key), Int> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return cuckoo_manager.verify(
    """
    getInt(forKey: PrefsController.Key) -> Int
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func remove<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.__DoNotUse<(PrefsController.Key), Void> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return cuckoo_manager.verify(
    """
    remove(forKey: PrefsController.Key)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getValue<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.__DoNotUse<(PrefsController.Key), Any?> where M1.MatchedType == PrefsController.Key {
            let matchers: [Cuckoo.ParameterMatcher<(PrefsController.Key)>] = [wrap(matchable: forKey) { $0 }]
            return cuckoo_manager.verify(
    """
    getValue(forKey: PrefsController.Key) -> Any?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class PrefsControllerTypeStub: PrefsControllerType {
    

    

    
    
    
    
    public func setValue(_ value: Any?, forKey: PrefsController.Key)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func getString(forKey: PrefsController.Key) -> String?  {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    
    
    
    
    public func getOptionalString(forKey: PrefsController.Key) -> String  {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
    
    
    
    
    
    public func getBool(forKey: PrefsController.Key) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
    public func getFloat(forKey: PrefsController.Key) -> Float  {
        return DefaultValueRegistry.defaultValue(for: (Float).self)
    }
    
    
    
    
    
    public func getInt(forKey: PrefsController.Key) -> Int  {
        return DefaultValueRegistry.defaultValue(for: (Int).self)
    }
    
    
    
    
    
    public func remove(forKey: PrefsController.Key)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func getValue(forKey: PrefsController.Key) -> Any?  {
        return DefaultValueRegistry.defaultValue(for: (Any?).self)
    }
    
    
}





import Cuckoo
@testable import logic_business

import Combine
import Foundation
import Network

import Cuckoo
@testable import logic_business

import Combine
import Foundation
import IOSSecuritySuite
import UIKit






public class MockSecurityControllerType: SecurityControllerType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = SecurityControllerType
    
    public typealias Stubbing = __StubbingProxy_SecurityControllerType
    public typealias Verification = __VerificationProxy_SecurityControllerType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: SecurityControllerType?

    public func enableDefaultImplementation(_ stub: SecurityControllerType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func isRunningOnEmulator() -> Bool {
        
    return cuckoo_manager.call(
    """
    isRunningOnEmulator() -> Bool
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isRunningOnEmulator())
        
    }
    
    
    
    
    
    public func isDeviceJailBroken() -> Bool {
        
    return cuckoo_manager.call(
    """
    isDeviceJailBroken() -> Bool
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isDeviceJailBroken())
        
    }
    
    
    
    
    
    public func isReverseEngineered() -> Bool {
        
    return cuckoo_manager.call(
    """
    isReverseEngineered() -> Bool
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isReverseEngineered())
        
    }
    
    
    
    
    
    public func isSignatureValid() -> Bool {
        
    return cuckoo_manager.call(
    """
    isSignatureValid() -> Bool
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isSignatureValid())
        
    }
    
    
    
    
    
    public func isDebuggable() -> Bool {
        
    return cuckoo_manager.call(
    """
    isDebuggable() -> Bool
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isDebuggable())
        
    }
    
    
    
    
    
    public func isApplicationSecure() -> AnyPublisher<SecurityController.SecurityValidation, Never> {
        
    return cuckoo_manager.call(
    """
    isApplicationSecure() -> AnyPublisher<SecurityController.SecurityValidation, Never>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isApplicationSecure())
        
    }
    
    
    
    
    
    public func isScreenCaptureDisabled() -> Bool {
        
    return cuckoo_manager.call(
    """
    isScreenCaptureDisabled() -> Bool
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isScreenCaptureDisabled())
        
    }
    
    
    
    
    
    public func isBlockUnsecureWebContentEnabled() -> Bool {
        
    return cuckoo_manager.call(
    """
    isBlockUnsecureWebContentEnabled() -> Bool
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isBlockUnsecureWebContentEnabled())
        
    }
    
    
    
    
    
    public func isDeviceBindingValid() -> Bool {
        
    return cuckoo_manager.call(
    """
    isDeviceBindingValid() -> Bool
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isDeviceBindingValid())
        
    }
    
    

    public struct __StubbingProxy_SecurityControllerType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func isRunningOnEmulator() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityControllerType.self, method:
    """
    isRunningOnEmulator() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isDeviceJailBroken() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityControllerType.self, method:
    """
    isDeviceJailBroken() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isReverseEngineered() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityControllerType.self, method:
    """
    isReverseEngineered() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isSignatureValid() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityControllerType.self, method:
    """
    isSignatureValid() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isDebuggable() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityControllerType.self, method:
    """
    isDebuggable() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isApplicationSecure() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<SecurityController.SecurityValidation, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityControllerType.self, method:
    """
    isApplicationSecure() -> AnyPublisher<SecurityController.SecurityValidation, Never>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isScreenCaptureDisabled() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityControllerType.self, method:
    """
    isScreenCaptureDisabled() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isBlockUnsecureWebContentEnabled() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityControllerType.self, method:
    """
    isBlockUnsecureWebContentEnabled() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isDeviceBindingValid() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityControllerType.self, method:
    """
    isDeviceBindingValid() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_SecurityControllerType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func isRunningOnEmulator() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    isRunningOnEmulator() -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isDeviceJailBroken() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    isDeviceJailBroken() -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isReverseEngineered() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    isReverseEngineered() -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isSignatureValid() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    isSignatureValid() -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isDebuggable() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    isDebuggable() -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isApplicationSecure() -> Cuckoo.__DoNotUse<(), AnyPublisher<SecurityController.SecurityValidation, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    isApplicationSecure() -> AnyPublisher<SecurityController.SecurityValidation, Never>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isScreenCaptureDisabled() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    isScreenCaptureDisabled() -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isBlockUnsecureWebContentEnabled() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    isBlockUnsecureWebContentEnabled() -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isDeviceBindingValid() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    isDeviceBindingValid() -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class SecurityControllerTypeStub: SecurityControllerType {
    

    

    
    
    
    
    public func isRunningOnEmulator() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
    public func isDeviceJailBroken() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
    public func isReverseEngineered() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
    public func isSignatureValid() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
    public func isDebuggable() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
    public func isApplicationSecure() -> AnyPublisher<SecurityController.SecurityValidation, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<SecurityController.SecurityValidation, Never>).self)
    }
    
    
    
    
    
    public func isScreenCaptureDisabled() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
    public func isBlockUnsecureWebContentEnabled() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
    public func isDeviceBindingValid() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
}





import Cuckoo
@testable import logic_business

import Combine
import EudiWalletKit
import Foundation
import MdocDataModel18013
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
    
    
    
    
    
    public func stopPresentation()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func fetchDocuments() -> [MdocDecodable]  {
        return DefaultValueRegistry.defaultValue(for: ([MdocDecodable]).self)
    }
    
    
}





import Cuckoo
@testable import logic_business

import Combine
import EudiWalletKit
import Foundation
import MdocDataModel18013
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
    
    
    
    
    
    public func sendResponse(response: RequestItemConvertible) async throws {
        
    return try await cuckoo_manager.callThrows(
    """
    sendResponse(response: RequestItemConvertible) async throws
    """,
            parameters: (response),
            escapingParameters: (response),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.sendResponse(response: response))
        
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
        
        
        
        
        func sendResponse<M1: Cuckoo.Matchable>(response: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(RequestItemConvertible)> where M1.MatchedType == RequestItemConvertible {
            let matchers: [Cuckoo.ParameterMatcher<(RequestItemConvertible)>] = [wrap(matchable: response) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinatorType.self, method:
    """
    sendResponse(response: RequestItemConvertible) async throws
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
        func sendResponse<M1: Cuckoo.Matchable>(response: M1) -> Cuckoo.__DoNotUse<(RequestItemConvertible), Void> where M1.MatchedType == RequestItemConvertible {
            let matchers: [Cuckoo.ParameterMatcher<(RequestItemConvertible)>] = [wrap(matchable: response) { $0 }]
            return cuckoo_manager.verify(
    """
    sendResponse(response: RequestItemConvertible) async throws
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
    
    
    
    
    
    public func sendResponse(response: RequestItemConvertible) async throws  {
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
@testable import logic_business

import Foundation
import logic_resources

import Cuckoo
@testable import logic_business

import Foundation

import Cuckoo
@testable import logic_business

import Foundation

import Cuckoo
@testable import logic_business

import Foundation

import Cuckoo
@testable import logic_business

import Foundation

import Cuckoo
@testable import logic_business

import Foundation

import Cuckoo
@testable import logic_business

import Combine
import Foundation

import Cuckoo
@testable import logic_business

import Foundation

import Cuckoo
@testable import logic_business

import Foundation

import Cuckoo
@testable import logic_business

import Foundation

import Cuckoo
@testable import logic_business

import Foundation
import UIKit

import Cuckoo
@testable import logic_business

import Foundation

import Cuckoo
@testable import logic_business

import Foundation
import MdocDataModel18013
import logic_resources

import Cuckoo
@testable import logic_business

import EudiWalletKit
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
    

    

    

    
    
    
    
    public func asRequestItems() -> RequestItems {
        
    return cuckoo_manager.call(
    """
    asRequestItems() -> RequestItems
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
        
        
        
        
        func asRequestItems() -> Cuckoo.ProtocolStubFunction<(), RequestItems> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRequestItemConvertible.self, method:
    """
    asRequestItems() -> RequestItems
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
        func asRequestItems() -> Cuckoo.__DoNotUse<(), RequestItems> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    asRequestItems() -> RequestItems
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class RequestItemConvertibleStub: RequestItemConvertible {
    

    

    
    
    
    
    public func asRequestItems() -> RequestItems  {
        return DefaultValueRegistry.defaultValue(for: (RequestItems).self)
    }
    
    
}





import Cuckoo
@testable import logic_business

import class Foundation.Bundle






public class MockConfigProviderType: ConfigProviderType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = ConfigProviderType
    
    public typealias Stubbing = __StubbingProxy_ConfigProviderType
    public typealias Verification = __VerificationProxy_ConfigProviderType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: ConfigProviderType?

    public func enableDefaultImplementation(_ stub: ConfigProviderType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func getConfigLogic() -> ConfigLogic {
        
    return cuckoo_manager.call(
    """
    getConfigLogic() -> ConfigLogic
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getConfigLogic())
        
    }
    
    
    
    
    
    public func getConfigSecurityLogic() -> ConfigSecurityLogic {
        
    return cuckoo_manager.call(
    """
    getConfigSecurityLogic() -> ConfigSecurityLogic
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getConfigSecurityLogic())
        
    }
    
    

    public struct __StubbingProxy_ConfigProviderType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func getConfigLogic() -> Cuckoo.ProtocolStubFunction<(), ConfigLogic> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockConfigProviderType.self, method:
    """
    getConfigLogic() -> ConfigLogic
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getConfigSecurityLogic() -> Cuckoo.ProtocolStubFunction<(), ConfigSecurityLogic> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockConfigProviderType.self, method:
    """
    getConfigSecurityLogic() -> ConfigSecurityLogic
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_ConfigProviderType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func getConfigLogic() -> Cuckoo.__DoNotUse<(), ConfigLogic> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getConfigLogic() -> ConfigLogic
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getConfigSecurityLogic() -> Cuckoo.__DoNotUse<(), ConfigSecurityLogic> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getConfigSecurityLogic() -> ConfigSecurityLogic
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class ConfigProviderTypeStub: ConfigProviderType {
    

    

    
    
    
    
    public func getConfigLogic() -> ConfigLogic  {
        return DefaultValueRegistry.defaultValue(for: (ConfigLogic).self)
    }
    
    
    
    
    
    public func getConfigSecurityLogic() -> ConfigSecurityLogic  {
        return DefaultValueRegistry.defaultValue(for: (ConfigSecurityLogic).self)
    }
    
    
}





import Cuckoo
@testable import logic_business

import Combine
import Foundation
import Peppermint
import libPhoneNumber






public class MockFormValidatorType: FormValidatorType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = FormValidatorType
    
    public typealias Stubbing = __StubbingProxy_FormValidatorType
    public typealias Verification = __VerificationProxy_FormValidatorType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: FormValidatorType?

    public func enableDefaultImplementation(_ stub: FormValidatorType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func validateForm(form: ValidatableForm) -> AnyPublisher<FormValidationResult, Never> {
        
    return cuckoo_manager.call(
    """
    validateForm(form: ValidatableForm) -> AnyPublisher<FormValidationResult, Never>
    """,
            parameters: (form),
            escapingParameters: (form),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.validateForm(form: form))
        
    }
    
    
    
    
    
    public func validateForms(forms: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never> {
        
    return cuckoo_manager.call(
    """
    validateForms(forms: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never>
    """,
            parameters: (forms),
            escapingParameters: (forms),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.validateForms(forms: forms))
        
    }
    
    

    public struct __StubbingProxy_FormValidatorType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func validateForm<M1: Cuckoo.Matchable>(form: M1) -> Cuckoo.ProtocolStubFunction<(ValidatableForm), AnyPublisher<FormValidationResult, Never>> where M1.MatchedType == ValidatableForm {
            let matchers: [Cuckoo.ParameterMatcher<(ValidatableForm)>] = [wrap(matchable: form) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFormValidatorType.self, method:
    """
    validateForm(form: ValidatableForm) -> AnyPublisher<FormValidationResult, Never>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func validateForms<M1: Cuckoo.Matchable>(forms: M1) -> Cuckoo.ProtocolStubFunction<([ValidatableForm]), AnyPublisher<FormsValidationResult, Never>> where M1.MatchedType == [ValidatableForm] {
            let matchers: [Cuckoo.ParameterMatcher<([ValidatableForm])>] = [wrap(matchable: forms) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFormValidatorType.self, method:
    """
    validateForms(forms: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never>
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_FormValidatorType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func validateForm<M1: Cuckoo.Matchable>(form: M1) -> Cuckoo.__DoNotUse<(ValidatableForm), AnyPublisher<FormValidationResult, Never>> where M1.MatchedType == ValidatableForm {
            let matchers: [Cuckoo.ParameterMatcher<(ValidatableForm)>] = [wrap(matchable: form) { $0 }]
            return cuckoo_manager.verify(
    """
    validateForm(form: ValidatableForm) -> AnyPublisher<FormValidationResult, Never>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func validateForms<M1: Cuckoo.Matchable>(forms: M1) -> Cuckoo.__DoNotUse<([ValidatableForm]), AnyPublisher<FormsValidationResult, Never>> where M1.MatchedType == [ValidatableForm] {
            let matchers: [Cuckoo.ParameterMatcher<([ValidatableForm])>] = [wrap(matchable: forms) { $0 }]
            return cuckoo_manager.verify(
    """
    validateForms(forms: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class FormValidatorTypeStub: FormValidatorType {
    

    

    
    
    
    
    public func validateForm(form: ValidatableForm) -> AnyPublisher<FormValidationResult, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<FormValidationResult, Never>).self)
    }
    
    
    
    
    
    public func validateForms(forms: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never>  {
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
    

    

    

    
    
    
    
    public func validateForm(form: ValidatableForm) -> AnyPublisher<FormValidationResult, Never> {
        
    return cuckoo_manager.call(
    """
    validateForm(form: ValidatableForm) -> AnyPublisher<FormValidationResult, Never>
    """,
            parameters: (form),
            escapingParameters: (form),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.validateForm(form: form))
        
    }
    
    
    
    
    
    public func validateForms(forms: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never> {
        
    return cuckoo_manager.call(
    """
    validateForms(forms: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never>
    """,
            parameters: (forms),
            escapingParameters: (forms),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.validateForms(forms: forms))
        
    }
    
    

    public struct __StubbingProxy_FormValidatorInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func validateForm<M1: Cuckoo.Matchable>(form: M1) -> Cuckoo.ProtocolStubFunction<(ValidatableForm), AnyPublisher<FormValidationResult, Never>> where M1.MatchedType == ValidatableForm {
            let matchers: [Cuckoo.ParameterMatcher<(ValidatableForm)>] = [wrap(matchable: form) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFormValidatorInteractor.self, method:
    """
    validateForm(form: ValidatableForm) -> AnyPublisher<FormValidationResult, Never>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func validateForms<M1: Cuckoo.Matchable>(forms: M1) -> Cuckoo.ProtocolStubFunction<([ValidatableForm]), AnyPublisher<FormsValidationResult, Never>> where M1.MatchedType == [ValidatableForm] {
            let matchers: [Cuckoo.ParameterMatcher<([ValidatableForm])>] = [wrap(matchable: forms) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFormValidatorInteractor.self, method:
    """
    validateForms(forms: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never>
    """, parameterMatchers: matchers))
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
        func validateForm<M1: Cuckoo.Matchable>(form: M1) -> Cuckoo.__DoNotUse<(ValidatableForm), AnyPublisher<FormValidationResult, Never>> where M1.MatchedType == ValidatableForm {
            let matchers: [Cuckoo.ParameterMatcher<(ValidatableForm)>] = [wrap(matchable: form) { $0 }]
            return cuckoo_manager.verify(
    """
    validateForm(form: ValidatableForm) -> AnyPublisher<FormValidationResult, Never>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func validateForms<M1: Cuckoo.Matchable>(forms: M1) -> Cuckoo.__DoNotUse<([ValidatableForm]), AnyPublisher<FormsValidationResult, Never>> where M1.MatchedType == [ValidatableForm] {
            let matchers: [Cuckoo.ParameterMatcher<([ValidatableForm])>] = [wrap(matchable: forms) { $0 }]
            return cuckoo_manager.verify(
    """
    validateForms(forms: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class FormValidatorInteractorStub: FormValidatorInteractor {
    

    

    
    
    
    
    public func validateForm(form: ValidatableForm) -> AnyPublisher<FormValidationResult, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<FormValidationResult, Never>).self)
    }
    
    
    
    
    
    public func validateForms(forms: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<FormsValidationResult, Never>).self)
    }
    
    
}




