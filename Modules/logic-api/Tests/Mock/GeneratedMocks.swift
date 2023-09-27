import Cuckoo
@testable import logic_business
@testable import logic_api

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_api

import Alamofire
import Foundation
import logic_business

import Cuckoo
@testable import logic_business
@testable import logic_api

import Cuckoo
@testable import logic_business
@testable import logic_api

import struct Foundation.Data






 class MockNetworkRequest<Response>: NetworkRequest, Cuckoo.ProtocolMock {
    
     typealias MocksType = DefaultImplCaller<Response>
    
     typealias Stubbing = __StubbingProxy_NetworkRequest
     typealias Verification = __VerificationProxy_NetworkRequest

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
     class DefaultImplCaller<Response>: NetworkRequest {
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

    private var __defaultImplStub: DefaultImplCaller<Response>?

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
            return cuckoo_manager.getter("method",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.method)
        }
        
    }
    
    
    
    
    
     var path: String {
        get {
            return cuckoo_manager.getter("path",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.path)
        }
        
    }
    
    
    
    
    
     var additionalHeaders: [String: String] {
        get {
            return cuckoo_manager.getter("additionalHeaders",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.additionalHeaders)
        }
        
    }
    
    
    
    
    
     var body: Data? {
        get {
            return cuckoo_manager.getter("body",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.body)
        }
        
    }
    
    

    

    

     struct __StubbingProxy_NetworkRequest: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var method: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockNetworkRequest, NetworkMethod> {
            return .init(manager: cuckoo_manager, name: "method")
        }
        
        
        
        
        var path: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockNetworkRequest, String> {
            return .init(manager: cuckoo_manager, name: "path")
        }
        
        
        
        
        var additionalHeaders: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockNetworkRequest, [String: String]> {
            return .init(manager: cuckoo_manager, name: "additionalHeaders")
        }
        
        
        
        
        var body: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockNetworkRequest, Data?> {
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


 class NetworkRequestStub<Response>: NetworkRequest {
    
    
    
    
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





import Cuckoo
@testable import logic_business
@testable import logic_api

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_api

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_api

import Foundation






public class MockSampleRepositoryType: SampleRepositoryType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = SampleRepositoryType
    
    public typealias Stubbing = __StubbingProxy_SampleRepositoryType
    public typealias Verification = __VerificationProxy_SampleRepositoryType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: SampleRepositoryType?

    public func enableDefaultImplementation(_ stub: SampleRepositoryType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func sampleCall() async throws -> SampleResponseDTO {
        
    return try await cuckoo_manager.callThrows(
    """
    sampleCall() async throws -> SampleResponseDTO
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.sampleCall())
        
    }
    
    

    public struct __StubbingProxy_SampleRepositoryType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func sampleCall() -> Cuckoo.ProtocolStubThrowingFunction<(), SampleResponseDTO> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSampleRepositoryType.self, method:
    """
    sampleCall() async throws -> SampleResponseDTO
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_SampleRepositoryType: Cuckoo.VerificationProxy {
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
    """
    sampleCall() async throws -> SampleResponseDTO
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class SampleRepositoryTypeStub: SampleRepositoryType {
    

    

    
    
    
    
    public func sampleCall() async throws -> SampleResponseDTO  {
        return DefaultValueRegistry.defaultValue(for: (SampleResponseDTO).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import logic_api

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
@testable import logic_api

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_api

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_api

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_api

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_api

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_api

import Foundation

import Cuckoo
@testable import logic_business
@testable import logic_api

import Foundation
import UIKit

import Cuckoo
@testable import logic_business
@testable import logic_api

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




