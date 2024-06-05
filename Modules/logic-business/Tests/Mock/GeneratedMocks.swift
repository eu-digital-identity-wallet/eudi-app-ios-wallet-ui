// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Config/ConfigLogic.swift'

import Cuckoo
import Foundation
@testable import logic_business

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
@testable import logic_business

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
@testable import logic_business

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
@testable import logic_business

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
@testable import logic_business

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
@testable import logic_business



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Array+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_business



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Data+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_business



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Encodable+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_business



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Error+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_business



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Locale+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_business



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/NSNotification+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_business



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Publisher+Extensions.swift'

import Cuckoo
import Foundation
import Combine
@testable import logic_business



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/String+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_business



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Task+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_business



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/TimeInterval+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_business



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/URL+Extensions.swift'

import Cuckoo
import Foundation
import UIKit
@testable import logic_business



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Functions/ConfigLogic+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_business



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Validator/FormValidator.swift'

import Cuckoo
import Foundation
import Combine
import Peppermint
import libPhoneNumber
@testable import logic_business

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
@testable import logic_business

