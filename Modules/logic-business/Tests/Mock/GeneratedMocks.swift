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
    
    
    
    
    
    public var networkLoggerExclusionList: [String] {
        get {
            return cuckoo_manager.getter("networkLoggerExclusionList",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.networkLoggerExclusionList)
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
        
        
        
        
        var networkLoggerExclusionList: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigLogic, [String]> {
            return .init(manager: cuckoo_manager, name: "networkLoggerExclusionList")
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
        
        
        
        
        var networkLoggerExclusionList: Cuckoo.VerifyReadOnlyProperty<[String]> {
            return .init(manager: cuckoo_manager, name: "networkLoggerExclusionList", callMatcher: callMatcher, sourceLocation: sourceLocation)
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
    
    
    
    
    
    public var networkLoggerExclusionList: [String] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String]).self)
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

import Foundation
import UIKit

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
        
        
    }
}


public class ConfigProviderTypeStub: ConfigProviderType {
    

    

    
    
    
    
    public func getConfigLogic() -> ConfigLogic  {
        return DefaultValueRegistry.defaultValue(for: (ConfigLogic).self)
    }
    
    
}




