import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import Foundation
import logic_api






public class MockStartupInteractorType: StartupInteractorType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = StartupInteractorType
    
    public typealias Stubbing = __StubbingProxy_StartupInteractorType
    public typealias Verification = __VerificationProxy_StartupInteractorType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: StartupInteractorType?

    public func enableDefaultImplementation(_ stub: StartupInteractorType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func sampleCall() async -> SamplePartialState {
        
    return await cuckoo_manager.call(
    """
    sampleCall() async -> SamplePartialState
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.sampleCall())
        
    }
    
    

    public struct __StubbingProxy_StartupInteractorType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func sampleCall() -> Cuckoo.ProtocolStubFunction<(), SamplePartialState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockStartupInteractorType.self, method:
    """
    sampleCall() async -> SamplePartialState
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_StartupInteractorType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func sampleCall() -> Cuckoo.__DoNotUse<(), SamplePartialState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    sampleCall() async -> SamplePartialState
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class StartupInteractorTypeStub: StartupInteractorType {
    

    

    
    
    
    
    public func sampleCall() async -> SamplePartialState  {
        return DefaultValueRegistry.defaultValue(for: (SamplePartialState).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_ui

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import Foundation
import logic_business
import logic_ui

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import Alamofire
import Foundation
import logic_business

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

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
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

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
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

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
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import Foundation
import UIKit

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

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





import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import Foundation






public class MockConfigUiLogic: ConfigUiLogic, Cuckoo.ProtocolMock {
    
    public typealias MocksType = ConfigUiLogic
    
    public typealias Stubbing = __StubbingProxy_ConfigUiLogic
    public typealias Verification = __VerificationProxy_ConfigUiLogic

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: ConfigUiLogic?

    public func enableDefaultImplementation(_ stub: ConfigUiLogic) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var initialRoute: AppRoute {
        get {
            return cuckoo_manager.getter("initialRoute",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.initialRoute)
        }
        
    }
    
    

    
    
    
    public required init(themeConciguration: ThemeConfiguration) {
        
    }
    
    

    

    public struct __StubbingProxy_ConfigUiLogic: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var initialRoute: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigUiLogic, AppRoute> {
            return .init(manager: cuckoo_manager, name: "initialRoute")
        }
        
        
        
    }

    public struct __VerificationProxy_ConfigUiLogic: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var initialRoute: Cuckoo.VerifyReadOnlyProperty<AppRoute> {
            return .init(manager: cuckoo_manager, name: "initialRoute", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
    }
}


public class ConfigUiLogicStub: ConfigUiLogic {
    
    
    
    
    public var initialRoute: AppRoute {
        get {
            return DefaultValueRegistry.defaultValue(for: (AppRoute).self)
        }
        
    }
    
    

    
    
    public required init(themeConciguration: ThemeConfiguration) {
        
    }
    
    

    
}





import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import Foundation
import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import ActivityIndicatorView
import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import Foundation
import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import AlertToast
import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import SwiftUI






public class MockRouterHostType: RouterHostType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = RouterHostType
    
    public typealias Stubbing = __StubbingProxy_RouterHostType
    public typealias Verification = __VerificationProxy_RouterHostType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: RouterHostType?

    public func enableDefaultImplementation(_ stub: RouterHostType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func push(with route: AppRoute)  {
        
    return cuckoo_manager.call(
    """
    push(with: AppRoute)
    """,
            parameters: (route),
            escapingParameters: (route),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.push(with: route))
        
    }
    
    
    
    
    
    public func popTo(with route: AppRoute, inclusive: Bool, animated: Bool)  {
        
    return cuckoo_manager.call(
    """
    popTo(with: AppRoute, inclusive: Bool, animated: Bool)
    """,
            parameters: (route, inclusive, animated),
            escapingParameters: (route, inclusive, animated),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.popTo(with: route, inclusive: inclusive, animated: animated))
        
    }
    
    
    
    
    
    public func pop()  {
        
    return cuckoo_manager.call(
    """
    pop()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.pop())
        
    }
    
    
    
    
    
    public func composeApplication() -> AnyView {
        
    return cuckoo_manager.call(
    """
    composeApplication() -> AnyView
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.composeApplication())
        
    }
    
    
    
    
    
    public func getCurrentScreen() -> AppRoute? {
        
    return cuckoo_manager.call(
    """
    getCurrentScreen() -> AppRoute?
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getCurrentScreen())
        
    }
    
    

    public struct __StubbingProxy_RouterHostType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func push<M1: Cuckoo.Matchable>(with route: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(AppRoute)> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: route) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHostType.self, method:
    """
    push(with: AppRoute)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func popTo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(with route: M1, inclusive: M2, animated: M3) -> Cuckoo.ProtocolStubNoReturnFunction<(AppRoute, Bool, Bool)> where M1.MatchedType == AppRoute, M2.MatchedType == Bool, M3.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute, Bool, Bool)>] = [wrap(matchable: route) { $0.0 }, wrap(matchable: inclusive) { $0.1 }, wrap(matchable: animated) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHostType.self, method:
    """
    popTo(with: AppRoute, inclusive: Bool, animated: Bool)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func pop() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHostType.self, method:
    """
    pop()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func composeApplication() -> Cuckoo.ProtocolStubFunction<(), AnyView> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHostType.self, method:
    """
    composeApplication() -> AnyView
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getCurrentScreen() -> Cuckoo.ProtocolStubFunction<(), AppRoute?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHostType.self, method:
    """
    getCurrentScreen() -> AppRoute?
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_RouterHostType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func push<M1: Cuckoo.Matchable>(with route: M1) -> Cuckoo.__DoNotUse<(AppRoute), Void> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: route) { $0 }]
            return cuckoo_manager.verify(
    """
    push(with: AppRoute)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func popTo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(with route: M1, inclusive: M2, animated: M3) -> Cuckoo.__DoNotUse<(AppRoute, Bool, Bool), Void> where M1.MatchedType == AppRoute, M2.MatchedType == Bool, M3.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute, Bool, Bool)>] = [wrap(matchable: route) { $0.0 }, wrap(matchable: inclusive) { $0.1 }, wrap(matchable: animated) { $0.2 }]
            return cuckoo_manager.verify(
    """
    popTo(with: AppRoute, inclusive: Bool, animated: Bool)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func pop() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    pop()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func composeApplication() -> Cuckoo.__DoNotUse<(), AnyView> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    composeApplication() -> AnyView
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getCurrentScreen() -> Cuckoo.__DoNotUse<(), AppRoute?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getCurrentScreen() -> AppRoute?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class RouterHostTypeStub: RouterHostType {
    

    

    
    
    
    
    public func push(with route: AppRoute)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func popTo(with route: AppRoute, inclusive: Bool, animated: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func pop()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func composeApplication() -> AnyView  {
        return DefaultValueRegistry.defaultValue(for: (AnyView).self)
    }
    
    
    
    
    
    public func getCurrentScreen() -> AppRoute?  {
        return DefaultValueRegistry.defaultValue(for: (AppRoute?).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import class Foundation.Bundle
import logic_business






public class MockConfigUiProviderType: ConfigUiProviderType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = ConfigUiProviderType
    
    public typealias Stubbing = __StubbingProxy_ConfigUiProviderType
    public typealias Verification = __VerificationProxy_ConfigUiProviderType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: ConfigUiProviderType?

    public func enableDefaultImplementation(_ stub: ConfigUiProviderType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func getConfigUiLogic() -> ConfigUiLogic {
        
    return cuckoo_manager.call(
    """
    getConfigUiLogic() -> ConfigUiLogic
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getConfigUiLogic())
        
    }
    
    

    public struct __StubbingProxy_ConfigUiProviderType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func getConfigUiLogic() -> Cuckoo.ProtocolStubFunction<(), ConfigUiLogic> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockConfigUiProviderType.self, method:
    """
    getConfigUiLogic() -> ConfigUiLogic
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_ConfigUiProviderType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func getConfigUiLogic() -> Cuckoo.__DoNotUse<(), ConfigUiLogic> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getConfigUiLogic() -> ConfigUiLogic
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class ConfigUiProviderTypeStub: ConfigUiProviderType {
    

    

    
    
    
    
    public func getConfigUiLogic() -> ConfigUiLogic  {
        return DefaultValueRegistry.defaultValue(for: (ConfigUiLogic).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import Foundation






public class MockThemeProtocol: ThemeProtocol, Cuckoo.ProtocolMock {
    
    public typealias MocksType = ThemeProtocol
    
    public typealias Stubbing = __StubbingProxy_ThemeProtocol
    public typealias Verification = __VerificationProxy_ThemeProtocol

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: ThemeProtocol?

    public func enableDefaultImplementation(_ stub: ThemeProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var themeConfiguration: ThemeConfiguration {
        get {
            return cuckoo_manager.getter("themeConfiguration",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.themeConfiguration)
        }
        
        set {
            cuckoo_manager.setter("themeConfiguration",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.themeConfiguration = newValue)
        }
        
    }
    
    
    
    
    
    public var image: ImageManagerProtocol {
        get {
            return cuckoo_manager.getter("image",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.image)
        }
        
    }
    
    
    
    
    
    public var color: ColorManagerProtocol {
        get {
            return cuckoo_manager.getter("color",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.color)
        }
        
    }
    
    
    
    
    
    public var shape: ShapeManagerProtocol {
        get {
            return cuckoo_manager.getter("shape",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.shape)
        }
        
    }
    
    
    
    
    
    public var font: TypographyManagerProtocol {
        get {
            return cuckoo_manager.getter("font",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.font)
        }
        
    }
    
    
    
    
    
    public var dimension: DimensionManagerProtocol {
        get {
            return cuckoo_manager.getter("dimension",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.dimension)
        }
        
    }
    
    

    

    

    public struct __StubbingProxy_ThemeProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var themeConfiguration: Cuckoo.ProtocolToBeStubbedProperty<MockThemeProtocol, ThemeConfiguration> {
            return .init(manager: cuckoo_manager, name: "themeConfiguration")
        }
        
        
        
        
        var image: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockThemeProtocol, ImageManagerProtocol> {
            return .init(manager: cuckoo_manager, name: "image")
        }
        
        
        
        
        var color: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockThemeProtocol, ColorManagerProtocol> {
            return .init(manager: cuckoo_manager, name: "color")
        }
        
        
        
        
        var shape: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockThemeProtocol, ShapeManagerProtocol> {
            return .init(manager: cuckoo_manager, name: "shape")
        }
        
        
        
        
        var font: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockThemeProtocol, TypographyManagerProtocol> {
            return .init(manager: cuckoo_manager, name: "font")
        }
        
        
        
        
        var dimension: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockThemeProtocol, DimensionManagerProtocol> {
            return .init(manager: cuckoo_manager, name: "dimension")
        }
        
        
        
    }

    public struct __VerificationProxy_ThemeProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var themeConfiguration: Cuckoo.VerifyProperty<ThemeConfiguration> {
            return .init(manager: cuckoo_manager, name: "themeConfiguration", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var image: Cuckoo.VerifyReadOnlyProperty<ImageManagerProtocol> {
            return .init(manager: cuckoo_manager, name: "image", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var color: Cuckoo.VerifyReadOnlyProperty<ColorManagerProtocol> {
            return .init(manager: cuckoo_manager, name: "color", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var shape: Cuckoo.VerifyReadOnlyProperty<ShapeManagerProtocol> {
            return .init(manager: cuckoo_manager, name: "shape", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var font: Cuckoo.VerifyReadOnlyProperty<TypographyManagerProtocol> {
            return .init(manager: cuckoo_manager, name: "font", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var dimension: Cuckoo.VerifyReadOnlyProperty<DimensionManagerProtocol> {
            return .init(manager: cuckoo_manager, name: "dimension", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
    }
}


public class ThemeProtocolStub: ThemeProtocol {
    
    
    
    
    public var themeConfiguration: ThemeConfiguration {
        get {
            return DefaultValueRegistry.defaultValue(for: (ThemeConfiguration).self)
        }
        
        set { }
        
    }
    
    
    
    
    
    public var image: ImageManagerProtocol {
        get {
            return DefaultValueRegistry.defaultValue(for: (ImageManagerProtocol).self)
        }
        
    }
    
    
    
    
    
    public var color: ColorManagerProtocol {
        get {
            return DefaultValueRegistry.defaultValue(for: (ColorManagerProtocol).self)
        }
        
    }
    
    
    
    
    
    public var shape: ShapeManagerProtocol {
        get {
            return DefaultValueRegistry.defaultValue(for: (ShapeManagerProtocol).self)
        }
        
    }
    
    
    
    
    
    public var font: TypographyManagerProtocol {
        get {
            return DefaultValueRegistry.defaultValue(for: (TypographyManagerProtocol).self)
        }
        
    }
    
    
    
    
    
    public var dimension: DimensionManagerProtocol {
        get {
            return DefaultValueRegistry.defaultValue(for: (DimensionManagerProtocol).self)
        }
        
    }
    
    

    

    
}





import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import SwiftUI






public class MockColorManagerProtocol: ColorManagerProtocol, Cuckoo.ProtocolMock {
    
    public typealias MocksType = ColorManagerProtocol
    
    public typealias Stubbing = __StubbingProxy_ColorManagerProtocol
    public typealias Verification = __VerificationProxy_ColorManagerProtocol

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: ColorManagerProtocol?

    public func enableDefaultImplementation(_ stub: ColorManagerProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var black: Color {
        get {
            return cuckoo_manager.getter("black",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.black)
        }
        
    }
    
    
    
    
    
    public var white: Color {
        get {
            return cuckoo_manager.getter("white",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.white)
        }
        
    }
    
    
    
    
    
    public var blue: Color {
        get {
            return cuckoo_manager.getter("blue",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.blue)
        }
        
    }
    
    
    
    
    
    public var red: Color {
        get {
            return cuckoo_manager.getter("red",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.red)
        }
        
    }
    
    
    
    
    
    public var grey: Color {
        get {
            return cuckoo_manager.getter("grey",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.grey)
        }
        
    }
    
    
    
    
    
    public var darkGrey: Color {
        get {
            return cuckoo_manager.getter("darkGrey",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.darkGrey)
        }
        
    }
    
    
    
    
    
    public var backgroundDefault: Color {
        get {
            return cuckoo_manager.getter("backgroundDefault",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.backgroundDefault)
        }
        
    }
    
    
    
    
    
    public var dividerDark: Color {
        get {
            return cuckoo_manager.getter("dividerDark",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.dividerDark)
        }
        
    }
    
    
    
    
    
    public var lightBlue: Color {
        get {
            return cuckoo_manager.getter("lightBlue",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.lightBlue)
        }
        
    }
    
    
    
    
    
    public var lightGradientEnd: Color {
        get {
            return cuckoo_manager.getter("lightGradientEnd",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.lightGradientEnd)
        }
        
    }
    
    
    
    
    
    public var lightGradientStart: Color {
        get {
            return cuckoo_manager.getter("lightGradientStart",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.lightGradientStart)
        }
        
    }
    
    
    
    
    
    public var onError: Color {
        get {
            return cuckoo_manager.getter("onError",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.onError)
        }
        
    }
    
    
    
    
    
    public var secondaryMain: Color {
        get {
            return cuckoo_manager.getter("secondaryMain",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.secondaryMain)
        }
        
    }
    
    
    
    
    
    public var successText: Color {
        get {
            return cuckoo_manager.getter("successText",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.successText)
        }
        
    }
    
    
    
    
    
    public var tertiaryMain: Color {
        get {
            return cuckoo_manager.getter("tertiaryMain",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.tertiaryMain)
        }
        
    }
    
    
    
    
    
    public var textDisabledDark: Color {
        get {
            return cuckoo_manager.getter("textDisabledDark",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.textDisabledDark)
        }
        
    }
    
    
    
    
    
    public var textPrimaryDark: Color {
        get {
            return cuckoo_manager.getter("textPrimaryDark",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.textPrimaryDark)
        }
        
    }
    
    
    
    
    
    public var textSecondaryDark: Color {
        get {
            return cuckoo_manager.getter("textSecondaryDark",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.textSecondaryDark)
        }
        
    }
    
    

    

    

    public struct __StubbingProxy_ColorManagerProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var black: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockColorManagerProtocol, Color> {
            return .init(manager: cuckoo_manager, name: "black")
        }
        
        
        
        
        var white: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockColorManagerProtocol, Color> {
            return .init(manager: cuckoo_manager, name: "white")
        }
        
        
        
        
        var blue: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockColorManagerProtocol, Color> {
            return .init(manager: cuckoo_manager, name: "blue")
        }
        
        
        
        
        var red: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockColorManagerProtocol, Color> {
            return .init(manager: cuckoo_manager, name: "red")
        }
        
        
        
        
        var grey: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockColorManagerProtocol, Color> {
            return .init(manager: cuckoo_manager, name: "grey")
        }
        
        
        
        
        var darkGrey: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockColorManagerProtocol, Color> {
            return .init(manager: cuckoo_manager, name: "darkGrey")
        }
        
        
        
        
        var backgroundDefault: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockColorManagerProtocol, Color> {
            return .init(manager: cuckoo_manager, name: "backgroundDefault")
        }
        
        
        
        
        var dividerDark: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockColorManagerProtocol, Color> {
            return .init(manager: cuckoo_manager, name: "dividerDark")
        }
        
        
        
        
        var lightBlue: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockColorManagerProtocol, Color> {
            return .init(manager: cuckoo_manager, name: "lightBlue")
        }
        
        
        
        
        var lightGradientEnd: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockColorManagerProtocol, Color> {
            return .init(manager: cuckoo_manager, name: "lightGradientEnd")
        }
        
        
        
        
        var lightGradientStart: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockColorManagerProtocol, Color> {
            return .init(manager: cuckoo_manager, name: "lightGradientStart")
        }
        
        
        
        
        var onError: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockColorManagerProtocol, Color> {
            return .init(manager: cuckoo_manager, name: "onError")
        }
        
        
        
        
        var secondaryMain: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockColorManagerProtocol, Color> {
            return .init(manager: cuckoo_manager, name: "secondaryMain")
        }
        
        
        
        
        var successText: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockColorManagerProtocol, Color> {
            return .init(manager: cuckoo_manager, name: "successText")
        }
        
        
        
        
        var tertiaryMain: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockColorManagerProtocol, Color> {
            return .init(manager: cuckoo_manager, name: "tertiaryMain")
        }
        
        
        
        
        var textDisabledDark: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockColorManagerProtocol, Color> {
            return .init(manager: cuckoo_manager, name: "textDisabledDark")
        }
        
        
        
        
        var textPrimaryDark: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockColorManagerProtocol, Color> {
            return .init(manager: cuckoo_manager, name: "textPrimaryDark")
        }
        
        
        
        
        var textSecondaryDark: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockColorManagerProtocol, Color> {
            return .init(manager: cuckoo_manager, name: "textSecondaryDark")
        }
        
        
        
    }

    public struct __VerificationProxy_ColorManagerProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var black: Cuckoo.VerifyReadOnlyProperty<Color> {
            return .init(manager: cuckoo_manager, name: "black", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var white: Cuckoo.VerifyReadOnlyProperty<Color> {
            return .init(manager: cuckoo_manager, name: "white", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var blue: Cuckoo.VerifyReadOnlyProperty<Color> {
            return .init(manager: cuckoo_manager, name: "blue", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var red: Cuckoo.VerifyReadOnlyProperty<Color> {
            return .init(manager: cuckoo_manager, name: "red", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var grey: Cuckoo.VerifyReadOnlyProperty<Color> {
            return .init(manager: cuckoo_manager, name: "grey", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var darkGrey: Cuckoo.VerifyReadOnlyProperty<Color> {
            return .init(manager: cuckoo_manager, name: "darkGrey", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var backgroundDefault: Cuckoo.VerifyReadOnlyProperty<Color> {
            return .init(manager: cuckoo_manager, name: "backgroundDefault", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var dividerDark: Cuckoo.VerifyReadOnlyProperty<Color> {
            return .init(manager: cuckoo_manager, name: "dividerDark", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var lightBlue: Cuckoo.VerifyReadOnlyProperty<Color> {
            return .init(manager: cuckoo_manager, name: "lightBlue", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var lightGradientEnd: Cuckoo.VerifyReadOnlyProperty<Color> {
            return .init(manager: cuckoo_manager, name: "lightGradientEnd", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var lightGradientStart: Cuckoo.VerifyReadOnlyProperty<Color> {
            return .init(manager: cuckoo_manager, name: "lightGradientStart", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var onError: Cuckoo.VerifyReadOnlyProperty<Color> {
            return .init(manager: cuckoo_manager, name: "onError", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var secondaryMain: Cuckoo.VerifyReadOnlyProperty<Color> {
            return .init(manager: cuckoo_manager, name: "secondaryMain", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var successText: Cuckoo.VerifyReadOnlyProperty<Color> {
            return .init(manager: cuckoo_manager, name: "successText", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var tertiaryMain: Cuckoo.VerifyReadOnlyProperty<Color> {
            return .init(manager: cuckoo_manager, name: "tertiaryMain", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var textDisabledDark: Cuckoo.VerifyReadOnlyProperty<Color> {
            return .init(manager: cuckoo_manager, name: "textDisabledDark", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var textPrimaryDark: Cuckoo.VerifyReadOnlyProperty<Color> {
            return .init(manager: cuckoo_manager, name: "textPrimaryDark", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var textSecondaryDark: Cuckoo.VerifyReadOnlyProperty<Color> {
            return .init(manager: cuckoo_manager, name: "textSecondaryDark", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
    }
}


public class ColorManagerProtocolStub: ColorManagerProtocol {
    
    
    
    
    public var black: Color {
        get {
            return DefaultValueRegistry.defaultValue(for: (Color).self)
        }
        
    }
    
    
    
    
    
    public var white: Color {
        get {
            return DefaultValueRegistry.defaultValue(for: (Color).self)
        }
        
    }
    
    
    
    
    
    public var blue: Color {
        get {
            return DefaultValueRegistry.defaultValue(for: (Color).self)
        }
        
    }
    
    
    
    
    
    public var red: Color {
        get {
            return DefaultValueRegistry.defaultValue(for: (Color).self)
        }
        
    }
    
    
    
    
    
    public var grey: Color {
        get {
            return DefaultValueRegistry.defaultValue(for: (Color).self)
        }
        
    }
    
    
    
    
    
    public var darkGrey: Color {
        get {
            return DefaultValueRegistry.defaultValue(for: (Color).self)
        }
        
    }
    
    
    
    
    
    public var backgroundDefault: Color {
        get {
            return DefaultValueRegistry.defaultValue(for: (Color).self)
        }
        
    }
    
    
    
    
    
    public var dividerDark: Color {
        get {
            return DefaultValueRegistry.defaultValue(for: (Color).self)
        }
        
    }
    
    
    
    
    
    public var lightBlue: Color {
        get {
            return DefaultValueRegistry.defaultValue(for: (Color).self)
        }
        
    }
    
    
    
    
    
    public var lightGradientEnd: Color {
        get {
            return DefaultValueRegistry.defaultValue(for: (Color).self)
        }
        
    }
    
    
    
    
    
    public var lightGradientStart: Color {
        get {
            return DefaultValueRegistry.defaultValue(for: (Color).self)
        }
        
    }
    
    
    
    
    
    public var onError: Color {
        get {
            return DefaultValueRegistry.defaultValue(for: (Color).self)
        }
        
    }
    
    
    
    
    
    public var secondaryMain: Color {
        get {
            return DefaultValueRegistry.defaultValue(for: (Color).self)
        }
        
    }
    
    
    
    
    
    public var successText: Color {
        get {
            return DefaultValueRegistry.defaultValue(for: (Color).self)
        }
        
    }
    
    
    
    
    
    public var tertiaryMain: Color {
        get {
            return DefaultValueRegistry.defaultValue(for: (Color).self)
        }
        
    }
    
    
    
    
    
    public var textDisabledDark: Color {
        get {
            return DefaultValueRegistry.defaultValue(for: (Color).self)
        }
        
    }
    
    
    
    
    
    public var textPrimaryDark: Color {
        get {
            return DefaultValueRegistry.defaultValue(for: (Color).self)
        }
        
    }
    
    
    
    
    
    public var textSecondaryDark: Color {
        get {
            return DefaultValueRegistry.defaultValue(for: (Color).self)
        }
        
    }
    
    

    

    
}





import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import Foundation






public class MockDimensionManagerProtocol: DimensionManagerProtocol, Cuckoo.ProtocolMock {
    
    public typealias MocksType = DimensionManagerProtocol
    
    public typealias Stubbing = __StubbingProxy_DimensionManagerProtocol
    public typealias Verification = __VerificationProxy_DimensionManagerProtocol

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: DimensionManagerProtocol?

    public func enableDefaultImplementation(_ stub: DimensionManagerProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var padding: CGFloat {
        get {
            return cuckoo_manager.getter("padding",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.padding)
        }
        
    }
    
    

    

    

    public struct __StubbingProxy_DimensionManagerProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var padding: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockDimensionManagerProtocol, CGFloat> {
            return .init(manager: cuckoo_manager, name: "padding")
        }
        
        
        
    }

    public struct __VerificationProxy_DimensionManagerProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var padding: Cuckoo.VerifyReadOnlyProperty<CGFloat> {
            return .init(manager: cuckoo_manager, name: "padding", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
    }
}


public class DimensionManagerProtocolStub: DimensionManagerProtocol {
    
    
    
    
    public var padding: CGFloat {
        get {
            return DefaultValueRegistry.defaultValue(for: (CGFloat).self)
        }
        
    }
    
    

    

    
}





import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import SwiftUI






public class MockImageManagerProtocol: ImageManagerProtocol, Cuckoo.ProtocolMock {
    
    public typealias MocksType = ImageManagerProtocol
    
    public typealias Stubbing = __StubbingProxy_ImageManagerProtocol
    public typealias Verification = __VerificationProxy_ImageManagerProtocol

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: ImageManagerProtocol?

    public func enableDefaultImplementation(_ stub: ImageManagerProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var consentImage: Image {
        get {
            return cuckoo_manager.getter("consentImage",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.consentImage)
        }
        
    }
    
    
    
    
    
    public var euLogo: Image {
        get {
            return cuckoo_manager.getter("euLogo",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.euLogo)
        }
        
    }
    
    
    
    
    
    public var launchImage: Image {
        get {
            return cuckoo_manager.getter("launchImage",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.launchImage)
        }
        
    }
    
    

    

    

    public struct __StubbingProxy_ImageManagerProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var consentImage: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockImageManagerProtocol, Image> {
            return .init(manager: cuckoo_manager, name: "consentImage")
        }
        
        
        
        
        var euLogo: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockImageManagerProtocol, Image> {
            return .init(manager: cuckoo_manager, name: "euLogo")
        }
        
        
        
        
        var launchImage: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockImageManagerProtocol, Image> {
            return .init(manager: cuckoo_manager, name: "launchImage")
        }
        
        
        
    }

    public struct __VerificationProxy_ImageManagerProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var consentImage: Cuckoo.VerifyReadOnlyProperty<Image> {
            return .init(manager: cuckoo_manager, name: "consentImage", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var euLogo: Cuckoo.VerifyReadOnlyProperty<Image> {
            return .init(manager: cuckoo_manager, name: "euLogo", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var launchImage: Cuckoo.VerifyReadOnlyProperty<Image> {
            return .init(manager: cuckoo_manager, name: "launchImage", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
    }
}


public class ImageManagerProtocolStub: ImageManagerProtocol {
    
    
    
    
    public var consentImage: Image {
        get {
            return DefaultValueRegistry.defaultValue(for: (Image).self)
        }
        
    }
    
    
    
    
    
    public var euLogo: Image {
        get {
            return DefaultValueRegistry.defaultValue(for: (Image).self)
        }
        
    }
    
    
    
    
    
    public var launchImage: Image {
        get {
            return DefaultValueRegistry.defaultValue(for: (Image).self)
        }
        
    }
    
    

    

    
}





import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import SwiftUI






public class MockShapeManagerProtocol: ShapeManagerProtocol, Cuckoo.ProtocolMock {
    
    public typealias MocksType = ShapeManagerProtocol
    
    public typealias Stubbing = __StubbingProxy_ShapeManagerProtocol
    public typealias Verification = __VerificationProxy_ShapeManagerProtocol

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: ShapeManagerProtocol?

    public func enableDefaultImplementation(_ stub: ShapeManagerProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var lowRadius: CGFloat {
        get {
            return cuckoo_manager.getter("lowRadius",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.lowRadius)
        }
        
    }
    
    
    
    
    
    public var highRadius: CGFloat {
        get {
            return cuckoo_manager.getter("highRadius",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.highRadius)
        }
        
    }
    
    
    
    
    
    public var capsuleShape: AnyShape {
        get {
            return cuckoo_manager.getter("capsuleShape",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.capsuleShape)
        }
        
    }
    
    
    
    
    
    public var lowCornerRadius: AnyShape {
        get {
            return cuckoo_manager.getter("lowCornerRadius",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.lowCornerRadius)
        }
        
    }
    
    
    
    
    
    public var highCornerRadiusShape: AnyShape {
        get {
            return cuckoo_manager.getter("highCornerRadiusShape",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.highCornerRadiusShape)
        }
        
    }
    
    

    

    

    public struct __StubbingProxy_ShapeManagerProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var lowRadius: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockShapeManagerProtocol, CGFloat> {
            return .init(manager: cuckoo_manager, name: "lowRadius")
        }
        
        
        
        
        var highRadius: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockShapeManagerProtocol, CGFloat> {
            return .init(manager: cuckoo_manager, name: "highRadius")
        }
        
        
        
        
        var capsuleShape: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockShapeManagerProtocol, AnyShape> {
            return .init(manager: cuckoo_manager, name: "capsuleShape")
        }
        
        
        
        
        var lowCornerRadius: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockShapeManagerProtocol, AnyShape> {
            return .init(manager: cuckoo_manager, name: "lowCornerRadius")
        }
        
        
        
        
        var highCornerRadiusShape: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockShapeManagerProtocol, AnyShape> {
            return .init(manager: cuckoo_manager, name: "highCornerRadiusShape")
        }
        
        
        
    }

    public struct __VerificationProxy_ShapeManagerProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var lowRadius: Cuckoo.VerifyReadOnlyProperty<CGFloat> {
            return .init(manager: cuckoo_manager, name: "lowRadius", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var highRadius: Cuckoo.VerifyReadOnlyProperty<CGFloat> {
            return .init(manager: cuckoo_manager, name: "highRadius", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var capsuleShape: Cuckoo.VerifyReadOnlyProperty<AnyShape> {
            return .init(manager: cuckoo_manager, name: "capsuleShape", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var lowCornerRadius: Cuckoo.VerifyReadOnlyProperty<AnyShape> {
            return .init(manager: cuckoo_manager, name: "lowCornerRadius", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var highCornerRadiusShape: Cuckoo.VerifyReadOnlyProperty<AnyShape> {
            return .init(manager: cuckoo_manager, name: "highCornerRadiusShape", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
    }
}


public class ShapeManagerProtocolStub: ShapeManagerProtocol {
    
    
    
    
    public var lowRadius: CGFloat {
        get {
            return DefaultValueRegistry.defaultValue(for: (CGFloat).self)
        }
        
    }
    
    
    
    
    
    public var highRadius: CGFloat {
        get {
            return DefaultValueRegistry.defaultValue(for: (CGFloat).self)
        }
        
    }
    
    
    
    
    
    public var capsuleShape: AnyShape {
        get {
            return DefaultValueRegistry.defaultValue(for: (AnyShape).self)
        }
        
    }
    
    
    
    
    
    public var lowCornerRadius: AnyShape {
        get {
            return DefaultValueRegistry.defaultValue(for: (AnyShape).self)
        }
        
    }
    
    
    
    
    
    public var highCornerRadiusShape: AnyShape {
        get {
            return DefaultValueRegistry.defaultValue(for: (AnyShape).self)
        }
        
    }
    
    

    

    
}





import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_startup
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_resources






public class MockTypographyManagerProtocol: TypographyManagerProtocol, Cuckoo.ProtocolMock {
    
    public typealias MocksType = TypographyManagerProtocol
    
    public typealias Stubbing = __StubbingProxy_TypographyManagerProtocol
    public typealias Verification = __VerificationProxy_TypographyManagerProtocol

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: TypographyManagerProtocol?

    public func enableDefaultImplementation(_ stub: TypographyManagerProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var largeTitle: Font {
        get {
            return cuckoo_manager.getter("title",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.titleLarge)
        }
        
    }
    
    
    
    
    
    public var headlineLarge: Font {
        get {
            return cuckoo_manager.getter("subTitle",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.headlineLarge)
        }
        
    }
    
    
    
    
    
    public var headlineMedium: Font {
        get {
            return cuckoo_manager.getter("subTitle2",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.headlineMedium)
        }
        
    }
    
    
    
    
    
    public var displayLarge: Font {
        get {
            return cuckoo_manager.getter("text",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.displayLarge)
        }
        
    }
    
    
    
    
    
    public var displayMedium: Font {
        get {
            return cuckoo_manager.getter("text2",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.displayMedium)
        }
        
    }
    
    
    
    
    
    public var displaySmall: Font {
        get {
            return cuckoo_manager.getter("text3",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.displaySmall)
        }
        
    }
    
    
    
    
    
    public var text4: Font {
        get {
            return cuckoo_manager.getter("text4",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.labelMedium)
        }
        
    }
    
    
    
    
    
    public var text5: Font {
        get {
            return cuckoo_manager.getter("text5",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.labelSmall)
        }
        
    }
    
    
    
    
    
    public var body: Font {
        get {
            return cuckoo_manager.getter("body",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.bodyLarge)
        }
        
    }
    
    
    
    
    
    public var body2: Font {
        get {
            return cuckoo_manager.getter("body2",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.bodyMedium)
        }
        
    }
    
    

    

    

    public struct __StubbingProxy_TypographyManagerProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var title: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockTypographyManagerProtocol, Font> {
            return .init(manager: cuckoo_manager, name: "title")
        }
        
        
        
        
        var subTitle: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockTypographyManagerProtocol, Font> {
            return .init(manager: cuckoo_manager, name: "subTitle")
        }
        
        
        
        
        var subTitle2: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockTypographyManagerProtocol, Font> {
            return .init(manager: cuckoo_manager, name: "subTitle2")
        }
        
        
        
        
        var text: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockTypographyManagerProtocol, Font> {
            return .init(manager: cuckoo_manager, name: "text")
        }
        
        
        
        
        var text2: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockTypographyManagerProtocol, Font> {
            return .init(manager: cuckoo_manager, name: "text2")
        }
        
        
        
        
        var text3: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockTypographyManagerProtocol, Font> {
            return .init(manager: cuckoo_manager, name: "text3")
        }
        
        
        
        
        var text4: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockTypographyManagerProtocol, Font> {
            return .init(manager: cuckoo_manager, name: "text4")
        }
        
        
        
        
        var text5: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockTypographyManagerProtocol, Font> {
            return .init(manager: cuckoo_manager, name: "text5")
        }
        
        
        
        
        var body: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockTypographyManagerProtocol, Font> {
            return .init(manager: cuckoo_manager, name: "body")
        }
        
        
        
        
        var body2: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockTypographyManagerProtocol, Font> {
            return .init(manager: cuckoo_manager, name: "body2")
        }
        
        
        
    }

    public struct __VerificationProxy_TypographyManagerProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var title: Cuckoo.VerifyReadOnlyProperty<Font> {
            return .init(manager: cuckoo_manager, name: "title", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var subTitle: Cuckoo.VerifyReadOnlyProperty<Font> {
            return .init(manager: cuckoo_manager, name: "subTitle", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var subTitle2: Cuckoo.VerifyReadOnlyProperty<Font> {
            return .init(manager: cuckoo_manager, name: "subTitle2", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var text: Cuckoo.VerifyReadOnlyProperty<Font> {
            return .init(manager: cuckoo_manager, name: "text", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var text2: Cuckoo.VerifyReadOnlyProperty<Font> {
            return .init(manager: cuckoo_manager, name: "text2", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var text3: Cuckoo.VerifyReadOnlyProperty<Font> {
            return .init(manager: cuckoo_manager, name: "text3", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var text4: Cuckoo.VerifyReadOnlyProperty<Font> {
            return .init(manager: cuckoo_manager, name: "text4", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var text5: Cuckoo.VerifyReadOnlyProperty<Font> {
            return .init(manager: cuckoo_manager, name: "text5", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var body: Cuckoo.VerifyReadOnlyProperty<Font> {
            return .init(manager: cuckoo_manager, name: "body", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var body2: Cuckoo.VerifyReadOnlyProperty<Font> {
            return .init(manager: cuckoo_manager, name: "body2", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
    }
}


public class TypographyManagerProtocolStub: TypographyManagerProtocol {
    
    
    
    
    public var largeTitle: Font {
        get {
            return DefaultValueRegistry.defaultValue(for: (Font).self)
        }
        
    }
    
    
    
    
    
    public var headlineLarge: Font {
        get {
            return DefaultValueRegistry.defaultValue(for: (Font).self)
        }
        
    }
    
    
    
    
    
    public var headlineMedium: Font {
        get {
            return DefaultValueRegistry.defaultValue(for: (Font).self)
        }
        
    }
    
    
    
    
    
    public var displayLarge: Font {
        get {
            return DefaultValueRegistry.defaultValue(for: (Font).self)
        }
        
    }
    
    
    
    
    
    public var displayMedium: Font {
        get {
            return DefaultValueRegistry.defaultValue(for: (Font).self)
        }
        
    }
    
    
    
    
    
    public var displaySmall: Font {
        get {
            return DefaultValueRegistry.defaultValue(for: (Font).self)
        }
        
    }
    
    
    
    
    
    public var text4: Font {
        get {
            return DefaultValueRegistry.defaultValue(for: (Font).self)
        }
        
    }
    
    
    
    
    
    public var text5: Font {
        get {
            return DefaultValueRegistry.defaultValue(for: (Font).self)
        }
        
    }
    
    
    
    
    
    public var body: Font {
        get {
            return DefaultValueRegistry.defaultValue(for: (Font).self)
        }
        
    }
    
    
    
    
    
    public var body2: Font {
        get {
            return DefaultValueRegistry.defaultValue(for: (Font).self)
        }
        
    }
    
    

    

    
}




