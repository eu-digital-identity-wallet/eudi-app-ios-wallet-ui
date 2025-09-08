// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Builder/ArrayBuilder.swift'

import Cuckoo
@testable import logic_business



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Config/ConfigLogic.swift'

import Cuckoo
import Foundation
import EudiRQESUi
@testable import logic_business

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
    
    public var changelogUrl: URL? {
        get {
            return cuckoo_manager.getter(
                "changelogUrl",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.changelogUrl
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
        
        var changelogUrl: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigLogic,URL?> {
            return .init(manager: cuckoo_manager, name: "changelogUrl")
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
        
        var changelogUrl: Cuckoo.VerifyReadOnlyProperty<URL?> {
            return .init(manager: cuckoo_manager, name: "changelogUrl", callMatcher: callMatcher, sourceLocation: sourceLocation)
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
    
    public var changelogUrl: URL? {
        get {
            return DefaultValueRegistry.defaultValue(for: (URL?).self)
        }
    }


}




// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Controller/KeyChainController.swift'

import Cuckoo
import Foundation
import KeychainAccess
@testable import logic_business

public class MockKeyChainWrapper: KeyChainWrapper, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = KeyChainWrapper
    public typealias Stubbing = __StubbingProxy_KeyChainWrapper
    public typealias Verification = __VerificationProxy_KeyChainWrapper

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any KeyChainWrapper)?

    public func enableDefaultImplementation(_ stub: any KeyChainWrapper) {
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


    public struct __StubbingProxy_KeyChainWrapper: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var value: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockKeyChainWrapper,String> {
            return .init(manager: cuckoo_manager, name: "value")
        }
    }

    public struct __VerificationProxy_KeyChainWrapper: Cuckoo.VerificationProxy {
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

public class KeyChainWrapperStub:KeyChainWrapper, @unchecked Sendable {
    
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

    
    public func storeValue(key p0: KeyChainWrapper, value p1: String) {
        return cuckoo_manager.call(
            "storeValue(key p0: KeyChainWrapper, value p1: String)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.storeValue(key: p0, value: p1)
        )
    }
    
    public func storeValue(key p0: KeyChainWrapper, value p1: Data) {
        return cuckoo_manager.call(
            "storeValue(key p0: KeyChainWrapper, value p1: Data)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.storeValue(key: p0, value: p1)
        )
    }
    
    public func getValue(key p0: KeyChainWrapper) -> String? {
        return cuckoo_manager.call(
            "getValue(key p0: KeyChainWrapper) -> String?",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getValue(key: p0)
        )
    }
    
    public func getData(key p0: KeyChainWrapper) -> Data? {
        return cuckoo_manager.call(
            "getData(key p0: KeyChainWrapper) -> Data?",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getData(key: p0)
        )
    }
    
    public func removeObject(key p0: KeyChainWrapper) {
        return cuckoo_manager.call(
            "removeObject(key p0: KeyChainWrapper)",
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
errorType: Error.self,            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
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
        
        func storeValue<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(key p0: M1, value p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(KeyChainWrapper, String)> where M1.MatchedType == KeyChainWrapper, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(KeyChainWrapper, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self,
                method: "storeValue(key p0: KeyChainWrapper, value p1: String)",
                parameterMatchers: matchers
            ))
        }
        
        func storeValue<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(key p0: M1, value p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(KeyChainWrapper, Data)> where M1.MatchedType == KeyChainWrapper, M2.MatchedType == Data {
            let matchers: [Cuckoo.ParameterMatcher<(KeyChainWrapper, Data)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self,
                method: "storeValue(key p0: KeyChainWrapper, value p1: Data)",
                parameterMatchers: matchers
            ))
        }
        
        func getValue<M1: Cuckoo.Matchable>(key p0: M1) -> Cuckoo.ProtocolStubFunction<(KeyChainWrapper), String?> where M1.MatchedType == KeyChainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeyChainWrapper)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self,
                method: "getValue(key p0: KeyChainWrapper) -> String?",
                parameterMatchers: matchers
            ))
        }
        
        func getData<M1: Cuckoo.Matchable>(key p0: M1) -> Cuckoo.ProtocolStubFunction<(KeyChainWrapper), Data?> where M1.MatchedType == KeyChainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeyChainWrapper)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self,
                method: "getData(key p0: KeyChainWrapper) -> Data?",
                parameterMatchers: matchers
            ))
        }
        
        func removeObject<M1: Cuckoo.Matchable>(key p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(KeyChainWrapper)> where M1.MatchedType == KeyChainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeyChainWrapper)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self,
                method: "removeObject(key p0: KeyChainWrapper)",
                parameterMatchers: matchers
            ))
        }
        
        func validateKeyChainBiometry() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(),Error> {
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
        func storeValue<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(key p0: M1, value p1: M2) -> Cuckoo.__DoNotUse<(KeyChainWrapper, String), Void> where M1.MatchedType == KeyChainWrapper, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(KeyChainWrapper, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "storeValue(key p0: KeyChainWrapper, value p1: String)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func storeValue<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(key p0: M1, value p1: M2) -> Cuckoo.__DoNotUse<(KeyChainWrapper, Data), Void> where M1.MatchedType == KeyChainWrapper, M2.MatchedType == Data {
            let matchers: [Cuckoo.ParameterMatcher<(KeyChainWrapper, Data)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "storeValue(key p0: KeyChainWrapper, value p1: Data)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getValue<M1: Cuckoo.Matchable>(key p0: M1) -> Cuckoo.__DoNotUse<(KeyChainWrapper), String?> where M1.MatchedType == KeyChainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeyChainWrapper)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "getValue(key p0: KeyChainWrapper) -> String?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getData<M1: Cuckoo.Matchable>(key p0: M1) -> Cuckoo.__DoNotUse<(KeyChainWrapper), Data?> where M1.MatchedType == KeyChainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeyChainWrapper)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "getData(key p0: KeyChainWrapper) -> Data?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func removeObject<M1: Cuckoo.Matchable>(key p0: M1) -> Cuckoo.__DoNotUse<(KeyChainWrapper), Void> where M1.MatchedType == KeyChainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeyChainWrapper)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "removeObject(key p0: KeyChainWrapper)",
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


    
    public func storeValue(key p0: KeyChainWrapper, value p1: String) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func storeValue(key p0: KeyChainWrapper, value p1: Data) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getValue(key p0: KeyChainWrapper) -> String? {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    public func getData(key p0: KeyChainWrapper) -> Data? {
        return DefaultValueRegistry.defaultValue(for: (Data?).self)
    }
    
    public func removeObject(key p0: KeyChainWrapper) {
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




// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Controller/PrefsController.swift'

import Cuckoo
import Foundation
@testable import logic_business

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




// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Controller/ReachabilityController.swift'

import Cuckoo
import Foundation
import Combine
import Network
import BluetoothKit
import UIKit
@testable import logic_business

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




// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/DI/DIGraph.swift'

import Cuckoo
import Swinject
@testable import logic_business

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
    
    public var resolver: Resolver {
        get {
            return cuckoo_manager.getter(
                "resolver",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.resolver
            )
        }
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
        
        var resolver: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockDIGraphType,Resolver> {
            return .init(manager: cuckoo_manager, name: "resolver")
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
        
        var resolver: Cuckoo.VerifyReadOnlyProperty<Resolver> {
            return .init(manager: cuckoo_manager, name: "resolver", callMatcher: callMatcher, sourceLocation: sourceLocation)
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
    
    public var resolver: Resolver {
        get {
            return DefaultValueRegistry.defaultValue(for: (Resolver).self)
        }
    }
    
    public var assembler: Assembler {
        get {
            return DefaultValueRegistry.defaultValue(for: (Assembler).self)
        }
    }


    
    public func lazyLoad(with p0: [Assembly]) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Error/RuntimeError.swift'

import Cuckoo
import Foundation
import logic_resources
@testable import logic_business



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/Array+Extensions.swift'

import Cuckoo
@testable import logic_business



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/Assembler+Extensions.swift'

import Cuckoo
import Swinject
@testable import logic_business



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/ConfigLogic+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_business



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/Data+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_business



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/Date+Extensions.swift'

import Cuckoo
import Foundation
import logic_resources
@testable import logic_business



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/Encodable+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_business



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/Error+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_business



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/Int+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_business



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/Locale+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_business



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/NSNotification+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_business



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/Publisher+Extensions.swift'

import Cuckoo
import Foundation
import Combine
@testable import logic_business



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/Resolver+Extensions.swift'

import Cuckoo
import Swinject
@testable import logic_business



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/String+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_business



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/Task+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_business



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/TimeInterval+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_business



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/URL+Extensions.swift'

import Cuckoo
import UIKit
@testable import logic_business



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Validator/FilterValidator.swift'

import Cuckoo
import Foundation
@testable import logic_business

public class MockFilterValidator: FilterValidator, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = FilterValidator
    public typealias Stubbing = __StubbingProxy_FilterValidator
    public typealias Verification = __VerificationProxy_FilterValidator

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any FilterValidator)?

    public func enableDefaultImplementation(_ stub: any FilterValidator) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    
    public func getFilterResultStream() -> AsyncStream<FilterResultPartialState> {
        return cuckoo_manager.call(
            "getFilterResultStream() -> AsyncStream<FilterResultPartialState>",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getFilterResultStream()
        )
    }
    
    public func initializeValidator(filters p0: Filters, filterableList p1: FilterableList) async {
        return await cuckoo_manager.call(
            "initializeValidator(filters p0: Filters, filterableList p1: FilterableList) async",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.initializeValidator(filters: p0, filterableList: p1)
        )
    }
    
    public func updateLists(sortOrder p0: SortOrderType, filterableList p1: FilterableList) async {
        return await cuckoo_manager.call(
            "updateLists(sortOrder p0: SortOrderType, filterableList p1: FilterableList) async",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.updateLists(sortOrder: p0, filterableList: p1)
        )
    }
    
    public func applyFilters(sortOrder p0: SortOrderType) async {
        return await cuckoo_manager.call(
            "applyFilters(sortOrder p0: SortOrderType) async",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.applyFilters(sortOrder: p0)
        )
    }
    
    public func applySearch(query p0: String) async {
        return await cuckoo_manager.call(
            "applySearch(query p0: String) async",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.applySearch(query: p0)
        )
    }
    
    public func resetFilters() async {
        return await cuckoo_manager.call(
            "resetFilters() async",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.resetFilters()
        )
    }
    
    public func revertFilters() async {
        return await cuckoo_manager.call(
            "revertFilters() async",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.revertFilters()
        )
    }
    
    public func updateFilter(filterGroupId p0: String, filterId p1: String) async {
        return await cuckoo_manager.call(
            "updateFilter(filterGroupId p0: String, filterId p1: String) async",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.updateFilter(filterGroupId: p0, filterId: p1)
        )
    }
    
    public func updateDateFilters(filterGroupId p0: String, filterId p1: String, startDate p2: Date, endDate p3: Date) async {
        return await cuckoo_manager.call(
            "updateDateFilters(filterGroupId p0: String, filterId p1: String, startDate p2: Date, endDate p3: Date) async",
            parameters: (p0, p1, p2, p3),
            escapingParameters: (p0, p1, p2, p3),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.updateDateFilters(filterGroupId: p0, filterId: p1, startDate: p2, endDate: p3)
        )
    }
    
    public func updateSortOrder(sortOrder p0: SortOrderType) async {
        return await cuckoo_manager.call(
            "updateSortOrder(sortOrder p0: SortOrderType) async",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.updateSortOrder(sortOrder: p0)
        )
    }

    public struct __StubbingProxy_FilterValidator: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func getFilterResultStream() -> Cuckoo.ProtocolStubFunction<(), AsyncStream<FilterResultPartialState>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockFilterValidator.self,
                method: "getFilterResultStream() -> AsyncStream<FilterResultPartialState>",
                parameterMatchers: matchers
            ))
        }
        
        func initializeValidator<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(filters p0: M1, filterableList p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(Filters, FilterableList)> where M1.MatchedType == Filters, M2.MatchedType == FilterableList {
            let matchers: [Cuckoo.ParameterMatcher<(Filters, FilterableList)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFilterValidator.self,
                method: "initializeValidator(filters p0: Filters, filterableList p1: FilterableList) async",
                parameterMatchers: matchers
            ))
        }
        
        func updateLists<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(sortOrder p0: M1, filterableList p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(SortOrderType, FilterableList)> where M1.MatchedType == SortOrderType, M2.MatchedType == FilterableList {
            let matchers: [Cuckoo.ParameterMatcher<(SortOrderType, FilterableList)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFilterValidator.self,
                method: "updateLists(sortOrder p0: SortOrderType, filterableList p1: FilterableList) async",
                parameterMatchers: matchers
            ))
        }
        
        func applyFilters<M1: Cuckoo.Matchable>(sortOrder p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(SortOrderType)> where M1.MatchedType == SortOrderType {
            let matchers: [Cuckoo.ParameterMatcher<(SortOrderType)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFilterValidator.self,
                method: "applyFilters(sortOrder p0: SortOrderType) async",
                parameterMatchers: matchers
            ))
        }
        
        func applySearch<M1: Cuckoo.Matchable>(query p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFilterValidator.self,
                method: "applySearch(query p0: String) async",
                parameterMatchers: matchers
            ))
        }
        
        func resetFilters() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockFilterValidator.self,
                method: "resetFilters() async",
                parameterMatchers: matchers
            ))
        }
        
        func revertFilters() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockFilterValidator.self,
                method: "revertFilters() async",
                parameterMatchers: matchers
            ))
        }
        
        func updateFilter<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(filterGroupId p0: M1, filterId p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, String)> where M1.MatchedType == String, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFilterValidator.self,
                method: "updateFilter(filterGroupId p0: String, filterId p1: String) async",
                parameterMatchers: matchers
            ))
        }
        
        func updateDateFilters<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(filterGroupId p0: M1, filterId p1: M2, startDate p2: M3, endDate p3: M4) -> Cuckoo.ProtocolStubNoReturnFunction<(String, String, Date, Date)> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == Date, M4.MatchedType == Date {
            let matchers: [Cuckoo.ParameterMatcher<(String, String, Date, Date)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFilterValidator.self,
                method: "updateDateFilters(filterGroupId p0: String, filterId p1: String, startDate p2: Date, endDate p3: Date) async",
                parameterMatchers: matchers
            ))
        }
        
        func updateSortOrder<M1: Cuckoo.Matchable>(sortOrder p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(SortOrderType)> where M1.MatchedType == SortOrderType {
            let matchers: [Cuckoo.ParameterMatcher<(SortOrderType)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFilterValidator.self,
                method: "updateSortOrder(sortOrder p0: SortOrderType) async",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_FilterValidator: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func getFilterResultStream() -> Cuckoo.__DoNotUse<(), AsyncStream<FilterResultPartialState>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getFilterResultStream() -> AsyncStream<FilterResultPartialState>",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func initializeValidator<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(filters p0: M1, filterableList p1: M2) -> Cuckoo.__DoNotUse<(Filters, FilterableList), Void> where M1.MatchedType == Filters, M2.MatchedType == FilterableList {
            let matchers: [Cuckoo.ParameterMatcher<(Filters, FilterableList)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "initializeValidator(filters p0: Filters, filterableList p1: FilterableList) async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func updateLists<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(sortOrder p0: M1, filterableList p1: M2) -> Cuckoo.__DoNotUse<(SortOrderType, FilterableList), Void> where M1.MatchedType == SortOrderType, M2.MatchedType == FilterableList {
            let matchers: [Cuckoo.ParameterMatcher<(SortOrderType, FilterableList)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "updateLists(sortOrder p0: SortOrderType, filterableList p1: FilterableList) async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func applyFilters<M1: Cuckoo.Matchable>(sortOrder p0: M1) -> Cuckoo.__DoNotUse<(SortOrderType), Void> where M1.MatchedType == SortOrderType {
            let matchers: [Cuckoo.ParameterMatcher<(SortOrderType)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "applyFilters(sortOrder p0: SortOrderType) async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func applySearch<M1: Cuckoo.Matchable>(query p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "applySearch(query p0: String) async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func resetFilters() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "resetFilters() async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func revertFilters() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "revertFilters() async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func updateFilter<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(filterGroupId p0: M1, filterId p1: M2) -> Cuckoo.__DoNotUse<(String, String), Void> where M1.MatchedType == String, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "updateFilter(filterGroupId p0: String, filterId p1: String) async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func updateDateFilters<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(filterGroupId p0: M1, filterId p1: M2, startDate p2: M3, endDate p3: M4) -> Cuckoo.__DoNotUse<(String, String, Date, Date), Void> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == Date, M4.MatchedType == Date {
            let matchers: [Cuckoo.ParameterMatcher<(String, String, Date, Date)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }]
            return cuckoo_manager.verify(
                "updateDateFilters(filterGroupId p0: String, filterId p1: String, startDate p2: Date, endDate p3: Date) async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func updateSortOrder<M1: Cuckoo.Matchable>(sortOrder p0: M1) -> Cuckoo.__DoNotUse<(SortOrderType), Void> where M1.MatchedType == SortOrderType {
            let matchers: [Cuckoo.ParameterMatcher<(SortOrderType)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "updateSortOrder(sortOrder p0: SortOrderType) async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class FilterValidatorStub:FilterValidator, @unchecked Sendable {


    
    public func getFilterResultStream() -> AsyncStream<FilterResultPartialState> {
        return DefaultValueRegistry.defaultValue(for: (AsyncStream<FilterResultPartialState>).self)
    }
    
    public func initializeValidator(filters p0: Filters, filterableList p1: FilterableList) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func updateLists(sortOrder p0: SortOrderType, filterableList p1: FilterableList) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func applyFilters(sortOrder p0: SortOrderType) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func applySearch(query p0: String) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func resetFilters() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func revertFilters() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func updateFilter(filterGroupId p0: String, filterId p1: String) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func updateDateFilters(filterGroupId p0: String, filterId p1: String, startDate p2: Date, endDate p3: Date) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func updateSortOrder(sortOrder p0: SortOrderType) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Validator/FormValidator.swift'

import Cuckoo
import Foundation
import Peppermint
import libPhoneNumber
@testable import logic_business

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




// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Validator/Model/FilterAction.swift'

import Cuckoo
import Foundation
@testable import logic_business

public class MockFilterAction: FilterAction, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = FilterAction
    public typealias Stubbing = __StubbingProxy_FilterAction
    public typealias Verification = __VerificationProxy_FilterAction

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any FilterAction)?

    public func enableDefaultImplementation(_ stub: any FilterAction) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    
    public func applyFilter(sortOrder p0: SortOrderType, filterableItems p1: FilterableList, filter p2: FilterItem) -> FilterableList {
        return cuckoo_manager.call(
            "applyFilter(sortOrder p0: SortOrderType, filterableItems p1: FilterableList, filter p2: FilterItem) -> FilterableList",
            parameters: (p0, p1, p2),
            escapingParameters: (p0, p1, p2),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.applyFilter(sortOrder: p0, filterableItems: p1, filter: p2)
        )
    }
    
    public func applyFilterGroup(filterableItems p0: FilterableList, filterGroup p1: FilterGroup) -> FilterableList {
        return cuckoo_manager.call(
            "applyFilterGroup(filterableItems p0: FilterableList, filterGroup p1: FilterGroup) -> FilterableList",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.applyFilterGroup(filterableItems: p0, filterGroup: p1)
        )
    }

    public struct __StubbingProxy_FilterAction: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func applyFilter<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(sortOrder p0: M1, filterableItems p1: M2, filter p2: M3) -> Cuckoo.ProtocolStubFunction<(SortOrderType, FilterableList, FilterItem), FilterableList> where M1.MatchedType == SortOrderType, M2.MatchedType == FilterableList, M3.MatchedType == FilterItem {
            let matchers: [Cuckoo.ParameterMatcher<(SortOrderType, FilterableList, FilterItem)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFilterAction.self,
                method: "applyFilter(sortOrder p0: SortOrderType, filterableItems p1: FilterableList, filter p2: FilterItem) -> FilterableList",
                parameterMatchers: matchers
            ))
        }
        
        func applyFilterGroup<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(filterableItems p0: M1, filterGroup p1: M2) -> Cuckoo.ProtocolStubFunction<(FilterableList, FilterGroup), FilterableList> where M1.MatchedType == FilterableList, M2.MatchedType == FilterGroup {
            let matchers: [Cuckoo.ParameterMatcher<(FilterableList, FilterGroup)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFilterAction.self,
                method: "applyFilterGroup(filterableItems p0: FilterableList, filterGroup p1: FilterGroup) -> FilterableList",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_FilterAction: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func applyFilter<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(sortOrder p0: M1, filterableItems p1: M2, filter p2: M3) -> Cuckoo.__DoNotUse<(SortOrderType, FilterableList, FilterItem), FilterableList> where M1.MatchedType == SortOrderType, M2.MatchedType == FilterableList, M3.MatchedType == FilterItem {
            let matchers: [Cuckoo.ParameterMatcher<(SortOrderType, FilterableList, FilterItem)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return cuckoo_manager.verify(
                "applyFilter(sortOrder p0: SortOrderType, filterableItems p1: FilterableList, filter p2: FilterItem) -> FilterableList",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func applyFilterGroup<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(filterableItems p0: M1, filterGroup p1: M2) -> Cuckoo.__DoNotUse<(FilterableList, FilterGroup), FilterableList> where M1.MatchedType == FilterableList, M2.MatchedType == FilterGroup {
            let matchers: [Cuckoo.ParameterMatcher<(FilterableList, FilterGroup)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "applyFilterGroup(filterableItems p0: FilterableList, filterGroup p1: FilterGroup) -> FilterableList",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class FilterActionStub:FilterAction, @unchecked Sendable {


    
    public func applyFilter(sortOrder p0: SortOrderType, filterableItems p1: FilterableList, filter p2: FilterItem) -> FilterableList {
        return DefaultValueRegistry.defaultValue(for: (FilterableList).self)
    }
    
    public func applyFilterGroup(filterableItems p0: FilterableList, filterGroup p1: FilterGroup) -> FilterableList {
        return DefaultValueRegistry.defaultValue(for: (FilterableList).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Validator/Model/FilterIds.swift'

import Cuckoo
@testable import logic_business



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Validator/Model/Filterable.swift'

import Cuckoo
import Foundation
import Copyable
@testable import logic_business

public class MockFilterableItemPayload: FilterableItemPayload, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = FilterableItemPayload
    public typealias Stubbing = __StubbingProxy_FilterableItemPayload
    public typealias Verification = __VerificationProxy_FilterableItemPayload

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any FilterableItemPayload)?

    public func enableDefaultImplementation(_ stub: any FilterableItemPayload) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    
    public var id: String {
        get {
            return cuckoo_manager.getter(
                "id",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.id
            )
        }
    }


    public struct __StubbingProxy_FilterableItemPayload: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var id: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockFilterableItemPayload,String> {
            return .init(manager: cuckoo_manager, name: "id")
        }
    }

    public struct __VerificationProxy_FilterableItemPayload: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var id: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "id", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    }
}

public class FilterableItemPayloadStub:FilterableItemPayload, @unchecked Sendable {
    
    public var id: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }


}


public class MockFilterableAttributes: FilterableAttributes, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = FilterableAttributes
    public typealias Stubbing = __StubbingProxy_FilterableAttributes
    public typealias Verification = __VerificationProxy_FilterableAttributes

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any FilterableAttributes)?

    public func enableDefaultImplementation(_ stub: any FilterableAttributes) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    
    public var sortingKey: String {
        get {
            return cuckoo_manager.getter(
                "sortingKey",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.sortingKey
            )
        }
    }
    
    public var searchTags: [String] {
        get {
            return cuckoo_manager.getter(
                "searchTags",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.searchTags
            )
        }
    }


    public struct __StubbingProxy_FilterableAttributes: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var sortingKey: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockFilterableAttributes,String> {
            return .init(manager: cuckoo_manager, name: "sortingKey")
        }
        
        var searchTags: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockFilterableAttributes,[String]> {
            return .init(manager: cuckoo_manager, name: "searchTags")
        }
    }

    public struct __VerificationProxy_FilterableAttributes: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var sortingKey: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "sortingKey", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var searchTags: Cuckoo.VerifyReadOnlyProperty<[String]> {
            return .init(manager: cuckoo_manager, name: "searchTags", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    }
}

public class FilterableAttributesStub:FilterableAttributes, @unchecked Sendable {
    
    public var sortingKey: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }
    
    public var searchTags: [String] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String]).self)
        }
    }


}




// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Validator/Model/Filters.swift'

import Cuckoo
import Foundation
import Copyable
@testable import logic_business

public class MockFilterGroup: FilterGroup, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = FilterGroup
    public typealias Stubbing = __StubbingProxy_FilterGroup
    public typealias Verification = __VerificationProxy_FilterGroup

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any FilterGroup)?

    public func enableDefaultImplementation(_ stub: any FilterGroup) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    
    public var id: String {
        get {
            return cuckoo_manager.getter(
                "id",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.id
            )
        }
    }
    
    public var name: String {
        get {
            return cuckoo_manager.getter(
                "name",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.name
            )
        }
    }
    
    public var filters: [FilterItem] {
        get {
            return cuckoo_manager.getter(
                "filters",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.filters
            )
        }
    }
    
    public var filterType: FilterGroupType {
        get {
            return cuckoo_manager.getter(
                "filterType",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.filterType
            )
        }
    }


    public struct __StubbingProxy_FilterGroup: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var id: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockFilterGroup,String> {
            return .init(manager: cuckoo_manager, name: "id")
        }
        
        var name: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockFilterGroup,String> {
            return .init(manager: cuckoo_manager, name: "name")
        }
        
        var filters: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockFilterGroup,[FilterItem]> {
            return .init(manager: cuckoo_manager, name: "filters")
        }
        
        var filterType: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockFilterGroup,FilterGroupType> {
            return .init(manager: cuckoo_manager, name: "filterType")
        }
    }

    public struct __VerificationProxy_FilterGroup: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var id: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "id", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var name: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "name", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var filters: Cuckoo.VerifyReadOnlyProperty<[FilterItem]> {
            return .init(manager: cuckoo_manager, name: "filters", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var filterType: Cuckoo.VerifyReadOnlyProperty<FilterGroupType> {
            return .init(manager: cuckoo_manager, name: "filterType", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    }
}

public class FilterGroupStub:FilterGroup, @unchecked Sendable {
    
    public var id: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }
    
    public var name: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }
    
    public var filters: [FilterItem] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([FilterItem]).self)
        }
    }
    
    public var filterType: FilterGroupType {
        get {
            return DefaultValueRegistry.defaultValue(for: (FilterGroupType).self)
        }
    }


}




// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Wrapper/EquatableNoop.swift'

import Cuckoo
@testable import logic_business

