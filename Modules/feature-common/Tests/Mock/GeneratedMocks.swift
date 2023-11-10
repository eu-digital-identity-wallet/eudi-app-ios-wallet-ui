import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import logic_resources
import logic_ui

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation
import SwiftUI
import logic_resources
import logic_ui

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Combine
import Foundation
import LocalAuthentication
import SwiftUI
import logic_business
import logic_ui






public class MockBiometryInteractorType: BiometryInteractorType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = BiometryInteractorType
    
    public typealias Stubbing = __StubbingProxy_BiometryInteractorType
    public typealias Verification = __VerificationProxy_BiometryInteractorType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: BiometryInteractorType?

    public func enableDefaultImplementation(_ stub: BiometryInteractorType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var biometricsImage: Image? {
        get {
            return cuckoo_manager.getter("biometricsImage",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.biometricsImage)
        }
        
    }
    
    
    
    
    
    public var currentBiometricsMethod: String {
        get {
            return cuckoo_manager.getter("currentBiometricsMethod",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.currentBiometricsMethod)
        }
        
    }
    
    
    
    
    
    public var biometryType: LABiometryType {
        get {
            return cuckoo_manager.getter("biometryType",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.biometryType)
        }
        
    }
    
    

    

    
    
    
    
    public func authenticate() -> AnyPublisher<BiometricsState, Never> {
        
    return cuckoo_manager.call(
    """
    authenticate() -> AnyPublisher<BiometricsState, Never>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.authenticate())
        
    }
    
    
    
    
    
    public func openSettingsURL(action: @escaping () -> Void)  {
        
    return cuckoo_manager.call(
    """
    openSettingsURL(action: @escaping () -> Void)
    """,
            parameters: (action),
            escapingParameters: (action),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.openSettingsURL(action: action))
        
    }
    
    
    
    
    
    public func isBiometryEnabled() -> Bool {
        
    return cuckoo_manager.call(
    """
    isBiometryEnabled() -> Bool
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isBiometryEnabled())
        
    }
    
    
    
    
    
    public func setBiometrySelection(isEnabled: Bool)  {
        
    return cuckoo_manager.call(
    """
    setBiometrySelection(isEnabled: Bool)
    """,
            parameters: (isEnabled),
            escapingParameters: (isEnabled),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setBiometrySelection(isEnabled: isEnabled))
        
    }
    
    
    
    
    
    public func isPinValid(with pin: String) -> QuickPinPartialState {
        
    return cuckoo_manager.call(
    """
    isPinValid(with: String) -> QuickPinPartialState
    """,
            parameters: (pin),
            escapingParameters: (pin),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isPinValid(with: pin))
        
    }
    
    

    public struct __StubbingProxy_BiometryInteractorType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var biometricsImage: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockBiometryInteractorType, Image?> {
            return .init(manager: cuckoo_manager, name: "biometricsImage")
        }
        
        
        
        
        var currentBiometricsMethod: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockBiometryInteractorType, String> {
            return .init(manager: cuckoo_manager, name: "currentBiometricsMethod")
        }
        
        
        
        
        var biometryType: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockBiometryInteractorType, LABiometryType> {
            return .init(manager: cuckoo_manager, name: "biometryType")
        }
        
        
        
        
        
        func authenticate() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<BiometricsState, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBiometryInteractorType.self, method:
    """
    authenticate() -> AnyPublisher<BiometricsState, Never>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openSettingsURL<M1: Cuckoo.Matchable>(action: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(() -> Void)> where M1.MatchedType == () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: action) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockBiometryInteractorType.self, method:
    """
    openSettingsURL(action: @escaping () -> Void)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isBiometryEnabled() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBiometryInteractorType.self, method:
    """
    isBiometryEnabled() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setBiometrySelection<M1: Cuckoo.Matchable>(isEnabled: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: isEnabled) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockBiometryInteractorType.self, method:
    """
    setBiometrySelection(isEnabled: Bool)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isPinValid<M1: Cuckoo.Matchable>(with pin: M1) -> Cuckoo.ProtocolStubFunction<(String), QuickPinPartialState> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pin) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockBiometryInteractorType.self, method:
    """
    isPinValid(with: String) -> QuickPinPartialState
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_BiometryInteractorType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var biometricsImage: Cuckoo.VerifyReadOnlyProperty<Image?> {
            return .init(manager: cuckoo_manager, name: "biometricsImage", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var currentBiometricsMethod: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "currentBiometricsMethod", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var biometryType: Cuckoo.VerifyReadOnlyProperty<LABiometryType> {
            return .init(manager: cuckoo_manager, name: "biometryType", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func authenticate() -> Cuckoo.__DoNotUse<(), AnyPublisher<BiometricsState, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    authenticate() -> AnyPublisher<BiometricsState, Never>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openSettingsURL<M1: Cuckoo.Matchable>(action: M1) -> Cuckoo.__DoNotUse<(() -> Void), Void> where M1.MatchedType == () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: action) { $0 }]
            return cuckoo_manager.verify(
    """
    openSettingsURL(action: @escaping () -> Void)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isBiometryEnabled() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    isBiometryEnabled() -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setBiometrySelection<M1: Cuckoo.Matchable>(isEnabled: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: isEnabled) { $0 }]
            return cuckoo_manager.verify(
    """
    setBiometrySelection(isEnabled: Bool)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isPinValid<M1: Cuckoo.Matchable>(with pin: M1) -> Cuckoo.__DoNotUse<(String), QuickPinPartialState> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pin) { $0 }]
            return cuckoo_manager.verify(
    """
    isPinValid(with: String) -> QuickPinPartialState
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class BiometryInteractorTypeStub: BiometryInteractorType {
    
    
    
    
    public var biometricsImage: Image? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Image?).self)
        }
        
    }
    
    
    
    
    
    public var currentBiometricsMethod: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    
    
    
    
    public var biometryType: LABiometryType {
        get {
            return DefaultValueRegistry.defaultValue(for: (LABiometryType).self)
        }
        
    }
    
    

    

    
    
    
    
    public func authenticate() -> AnyPublisher<BiometricsState, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<BiometricsState, Never>).self)
    }
    
    
    
    
    
    public func openSettingsURL(action: @escaping () -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func isBiometryEnabled() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
    public func setBiometrySelection(isEnabled: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func isPinValid(with pin: String) -> QuickPinPartialState  {
        return DefaultValueRegistry.defaultValue(for: (QuickPinPartialState).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Combine
import Foundation
import logic_business






public class MockQuickPinInteractorType: QuickPinInteractorType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = QuickPinInteractorType
    
    public typealias Stubbing = __StubbingProxy_QuickPinInteractorType
    public typealias Verification = __VerificationProxy_QuickPinInteractorType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: QuickPinInteractorType?

    public func enableDefaultImplementation(_ stub: QuickPinInteractorType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func setPin(newPin: String)  {
        
    return cuckoo_manager.call(
    """
    setPin(newPin: String)
    """,
            parameters: (newPin),
            escapingParameters: (newPin),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setPin(newPin: newPin))
        
    }
    
    
    
    
    
    public func isPinValid(pin: String) -> QuickPinPartialState {
        
    return cuckoo_manager.call(
    """
    isPinValid(pin: String) -> QuickPinPartialState
    """,
            parameters: (pin),
            escapingParameters: (pin),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isPinValid(pin: pin))
        
    }
    
    
    
    
    
    public func changePin(currentPin: String, newPin: String) -> QuickPinPartialState {
        
    return cuckoo_manager.call(
    """
    changePin(currentPin: String, newPin: String) -> QuickPinPartialState
    """,
            parameters: (currentPin, newPin),
            escapingParameters: (currentPin, newPin),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.changePin(currentPin: currentPin, newPin: newPin))
        
    }
    
    

    public struct __StubbingProxy_QuickPinInteractorType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func setPin<M1: Cuckoo.Matchable>(newPin: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: newPin) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockQuickPinInteractorType.self, method:
    """
    setPin(newPin: String)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isPinValid<M1: Cuckoo.Matchable>(pin: M1) -> Cuckoo.ProtocolStubFunction<(String), QuickPinPartialState> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pin) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockQuickPinInteractorType.self, method:
    """
    isPinValid(pin: String) -> QuickPinPartialState
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func changePin<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(currentPin: M1, newPin: M2) -> Cuckoo.ProtocolStubFunction<(String, String), QuickPinPartialState> where M1.MatchedType == String, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: currentPin) { $0.0 }, wrap(matchable: newPin) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockQuickPinInteractorType.self, method:
    """
    changePin(currentPin: String, newPin: String) -> QuickPinPartialState
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_QuickPinInteractorType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func setPin<M1: Cuckoo.Matchable>(newPin: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: newPin) { $0 }]
            return cuckoo_manager.verify(
    """
    setPin(newPin: String)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isPinValid<M1: Cuckoo.Matchable>(pin: M1) -> Cuckoo.__DoNotUse<(String), QuickPinPartialState> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pin) { $0 }]
            return cuckoo_manager.verify(
    """
    isPinValid(pin: String) -> QuickPinPartialState
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func changePin<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(currentPin: M1, newPin: M2) -> Cuckoo.__DoNotUse<(String, String), QuickPinPartialState> where M1.MatchedType == String, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: currentPin) { $0.0 }, wrap(matchable: newPin) { $0.1 }]
            return cuckoo_manager.verify(
    """
    changePin(currentPin: String, newPin: String) -> QuickPinPartialState
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class QuickPinInteractorTypeStub: QuickPinInteractorType {
    

    

    
    
    
    
    public func setPin(newPin: String)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func isPinValid(pin: String) -> QuickPinPartialState  {
        return DefaultValueRegistry.defaultValue(for: (QuickPinPartialState).self)
    }
    
    
    
    
    
    public func changePin(currentPin: String, newPin: String) -> QuickPinPartialState  {
        return DefaultValueRegistry.defaultValue(for: (QuickPinPartialState).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_resources
import logic_ui

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation
import logic_business
import logic_ui

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_resources
import logic_ui

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_resources
import logic_ui

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import logic_resources
import logic_ui

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_resources
import logic_ui

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import logic_resources
import logic_ui

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation
import SwiftUI
import logic_resources
import logic_ui

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation
import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_resources
import logic_ui

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import logic_business
import logic_ui

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Alamofire
import Foundation
import logic_business

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Cuckoo
@testable import logic_business
@testable import feature_common
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
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_common
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
@testable import feature_common
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
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

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
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

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
    
    
}





import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

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
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Combine
import Foundation
import Network

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

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
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Combine
import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation
import UIKit

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_common
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
@testable import feature_common
@testable import logic_api
@testable import logic_ui

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





import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Combine
import SwiftUI






public class MockViewState: ViewState, Cuckoo.ProtocolMock {
    
    public typealias MocksType = ViewState
    
    public typealias Stubbing = __StubbingProxy_ViewState
    public typealias Verification = __VerificationProxy_ViewState

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: ViewState?

    public func enableDefaultImplementation(_ stub: ViewState) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    

    public struct __StubbingProxy_ViewState: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
    }

    public struct __VerificationProxy_ViewState: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
    }
}


public class ViewStateStub: ViewState {
    

    

    
}





import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Combine
import Foundation
import LocalAuthentication
import SwiftUI
import logic_business






public class MockSystemBiometricsControllerType: SystemBiometricsControllerType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = SystemBiometricsControllerType
    
    public typealias Stubbing = __StubbingProxy_SystemBiometricsControllerType
    public typealias Verification = __VerificationProxy_SystemBiometricsControllerType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: SystemBiometricsControllerType?

    public func enableDefaultImplementation(_ stub: SystemBiometricsControllerType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var biometryType: LABiometryType {
        get {
            return cuckoo_manager.getter("biometryType",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.biometryType)
        }
        
    }
    
    

    

    
    
    
    
    public func canEvaluateForBiometrics() -> AnyPublisher<Bool, SystemBiometricsError> {
        
    return cuckoo_manager.call(
    """
    canEvaluateForBiometrics() -> AnyPublisher<Bool, SystemBiometricsError>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.canEvaluateForBiometrics())
        
    }
    
    
    
    
    
    public func evaluateBiometrics() -> AnyPublisher<Void, SystemBiometricsError> {
        
    return cuckoo_manager.call(
    """
    evaluateBiometrics() -> AnyPublisher<Void, SystemBiometricsError>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.evaluateBiometrics())
        
    }
    
    
    
    
    
    public func requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometricsError> {
        
    return cuckoo_manager.call(
    """
    requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometricsError>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.requestBiometricUnlock())
        
    }
    
    

    public struct __StubbingProxy_SystemBiometricsControllerType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var biometryType: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSystemBiometricsControllerType, LABiometryType> {
            return .init(manager: cuckoo_manager, name: "biometryType")
        }
        
        
        
        
        
        func canEvaluateForBiometrics() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<Bool, SystemBiometricsError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometricsControllerType.self, method:
    """
    canEvaluateForBiometrics() -> AnyPublisher<Bool, SystemBiometricsError>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func evaluateBiometrics() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<Void, SystemBiometricsError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometricsControllerType.self, method:
    """
    evaluateBiometrics() -> AnyPublisher<Void, SystemBiometricsError>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func requestBiometricUnlock() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<Void, SystemBiometricsError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometricsControllerType.self, method:
    """
    requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometricsError>
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_SystemBiometricsControllerType: Cuckoo.VerificationProxy {
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
        func canEvaluateForBiometrics() -> Cuckoo.__DoNotUse<(), AnyPublisher<Bool, SystemBiometricsError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    canEvaluateForBiometrics() -> AnyPublisher<Bool, SystemBiometricsError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func evaluateBiometrics() -> Cuckoo.__DoNotUse<(), AnyPublisher<Void, SystemBiometricsError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    evaluateBiometrics() -> AnyPublisher<Void, SystemBiometricsError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func requestBiometricUnlock() -> Cuckoo.__DoNotUse<(), AnyPublisher<Void, SystemBiometricsError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometricsError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class SystemBiometricsControllerTypeStub: SystemBiometricsControllerType {
    
    
    
    
    public var biometryType: LABiometryType {
        get {
            return DefaultValueRegistry.defaultValue(for: (LABiometryType).self)
        }
        
    }
    
    

    

    
    
    
    
    public func canEvaluateForBiometrics() -> AnyPublisher<Bool, SystemBiometricsError>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Bool, SystemBiometricsError>).self)
    }
    
    
    
    
    
    public func evaluateBiometrics() -> AnyPublisher<Void, SystemBiometricsError>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Void, SystemBiometricsError>).self)
    }
    
    
    
    
    
    public func requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometricsError>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Void, SystemBiometricsError>).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Combine
import Foundation
import LocalAuthentication
import SwiftUI
import UIKit
import logic_resources






public class MockSystemBiometricsInteractorType: SystemBiometricsInteractorType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = SystemBiometricsInteractorType
    
    public typealias Stubbing = __StubbingProxy_SystemBiometricsInteractorType
    public typealias Verification = __VerificationProxy_SystemBiometricsInteractorType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: SystemBiometricsInteractorType?

    public func enableDefaultImplementation(_ stub: SystemBiometricsInteractorType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var biometricsImage: Image? {
        get {
            return cuckoo_manager.getter("biometricsImage",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.biometricsImage)
        }
        
    }
    
    
    
    
    
    public var currentBiometricsMethod: String {
        get {
            return cuckoo_manager.getter("currentBiometricsMethod",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.currentBiometricsMethod)
        }
        
    }
    
    
    
    
    
    public var biometryType: LABiometryType {
        get {
            return cuckoo_manager.getter("biometryType",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.biometryType)
        }
        
    }
    
    

    

    
    
    
    
    public func authenticate() -> AnyPublisher<BiometricsState, Never> {
        
    return cuckoo_manager.call(
    """
    authenticate() -> AnyPublisher<BiometricsState, Never>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.authenticate())
        
    }
    
    
    
    
    
    public func openSettingsURL(action: @escaping () -> Void)  {
        
    return cuckoo_manager.call(
    """
    openSettingsURL(action: @escaping () -> Void)
    """,
            parameters: (action),
            escapingParameters: (action),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.openSettingsURL(action: action))
        
    }
    
    

    public struct __StubbingProxy_SystemBiometricsInteractorType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var biometricsImage: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSystemBiometricsInteractorType, Image?> {
            return .init(manager: cuckoo_manager, name: "biometricsImage")
        }
        
        
        
        
        var currentBiometricsMethod: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSystemBiometricsInteractorType, String> {
            return .init(manager: cuckoo_manager, name: "currentBiometricsMethod")
        }
        
        
        
        
        var biometryType: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSystemBiometricsInteractorType, LABiometryType> {
            return .init(manager: cuckoo_manager, name: "biometryType")
        }
        
        
        
        
        
        func authenticate() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<BiometricsState, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometricsInteractorType.self, method:
    """
    authenticate() -> AnyPublisher<BiometricsState, Never>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openSettingsURL<M1: Cuckoo.Matchable>(action: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(() -> Void)> where M1.MatchedType == () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: action) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometricsInteractorType.self, method:
    """
    openSettingsURL(action: @escaping () -> Void)
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_SystemBiometricsInteractorType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var biometricsImage: Cuckoo.VerifyReadOnlyProperty<Image?> {
            return .init(manager: cuckoo_manager, name: "biometricsImage", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var currentBiometricsMethod: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "currentBiometricsMethod", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var biometryType: Cuckoo.VerifyReadOnlyProperty<LABiometryType> {
            return .init(manager: cuckoo_manager, name: "biometryType", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func authenticate() -> Cuckoo.__DoNotUse<(), AnyPublisher<BiometricsState, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    authenticate() -> AnyPublisher<BiometricsState, Never>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openSettingsURL<M1: Cuckoo.Matchable>(action: M1) -> Cuckoo.__DoNotUse<(() -> Void), Void> where M1.MatchedType == () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: action) { $0 }]
            return cuckoo_manager.verify(
    """
    openSettingsURL(action: @escaping () -> Void)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class SystemBiometricsInteractorTypeStub: SystemBiometricsInteractorType {
    
    
    
    
    public var biometricsImage: Image? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Image?).self)
        }
        
    }
    
    
    
    
    
    public var currentBiometricsMethod: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    
    
    
    
    public var biometryType: LABiometryType {
        get {
            return DefaultValueRegistry.defaultValue(for: (LABiometryType).self)
        }
        
    }
    
    

    

    
    
    
    
    public func authenticate() -> AnyPublisher<BiometricsState, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<BiometricsState, Never>).self)
    }
    
    
    
    
    
    public func openSettingsURL(action: @escaping () -> Void)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation
import logic_resources






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
    

    
    
    
    
    public var landingRoute: AppRoute {
        get {
            return cuckoo_manager.getter("landingRoute",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.landingRoute)
        }
        
    }
    
    
    
    
    
    public var backgroundColorForScreenDictionary: [AppRouteKey: UIConfig.ToolBar] {
        get {
            return cuckoo_manager.getter("backgroundColorForScreenDictionary",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.backgroundColorForScreenDictionary)
        }
        
    }
    
    

    
    
    
    public required init(themeConfiguration: ThemeConfiguration) {
        
    }
    
    

    

    public struct __StubbingProxy_ConfigUiLogic: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var landingRoute: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigUiLogic, AppRoute> {
            return .init(manager: cuckoo_manager, name: "landingRoute")
        }
        
        
        
        
        var backgroundColorForScreenDictionary: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigUiLogic, [AppRouteKey: UIConfig.ToolBar]> {
            return .init(manager: cuckoo_manager, name: "backgroundColorForScreenDictionary")
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
    
        
        
        
        var landingRoute: Cuckoo.VerifyReadOnlyProperty<AppRoute> {
            return .init(manager: cuckoo_manager, name: "landingRoute", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        
        var backgroundColorForScreenDictionary: Cuckoo.VerifyReadOnlyProperty<[AppRouteKey: UIConfig.ToolBar]> {
            return .init(manager: cuckoo_manager, name: "backgroundColorForScreenDictionary", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
    }
}


public class ConfigUiLogicStub: ConfigUiLogic {
    
    
    
    
    public var landingRoute: AppRoute {
        get {
            return DefaultValueRegistry.defaultValue(for: (AppRoute).self)
        }
        
    }
    
    
    
    
    
    public var backgroundColorForScreenDictionary: [AppRouteKey: UIConfig.ToolBar] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([AppRouteKey: UIConfig.ToolBar]).self)
        }
        
    }
    
    

    
    
    public required init(themeConfiguration: ThemeConfiguration) {
        
    }
    
    

    
}





import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation
import logic_resources






public class MockUIConfigType: UIConfigType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = UIConfigType
    
    public typealias Stubbing = __StubbingProxy_UIConfigType
    public typealias Verification = __VerificationProxy_UIConfigType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: UIConfigType?

    public func enableDefaultImplementation(_ stub: UIConfigType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    

    public struct __StubbingProxy_UIConfigType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
    }

    public struct __VerificationProxy_UIConfigType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
    }
}


public class UIConfigTypeStub: UIConfigType {
    

    

    
}





import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation
import logic_business






public class MockDeepLinkControllerType: DeepLinkControllerType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = DeepLinkControllerType
    
    public typealias Stubbing = __StubbingProxy_DeepLinkControllerType
    public typealias Verification = __VerificationProxy_DeepLinkControllerType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: DeepLinkControllerType?

    public func enableDefaultImplementation(_ stub: DeepLinkControllerType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func hasDeepLink(url: URL) -> DeepLinkController.DeepLinkAction? {
        
    return cuckoo_manager.call(
    """
    hasDeepLink(url: URL) -> DeepLinkController.DeepLinkAction?
    """,
            parameters: (url),
            escapingParameters: (url),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.hasDeepLink(url: url))
        
    }
    
    
    
    
    
    public func handleDeepLinkAction(routerHost: RouterHostType, deepLinkAction: DeepLinkController.DeepLinkAction)  {
        
    return cuckoo_manager.call(
    """
    handleDeepLinkAction(routerHost: RouterHostType, deepLinkAction: DeepLinkController.DeepLinkAction)
    """,
            parameters: (routerHost, deepLinkAction),
            escapingParameters: (routerHost, deepLinkAction),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.handleDeepLinkAction(routerHost: routerHost, deepLinkAction: deepLinkAction))
        
    }
    
    
    
    
    
    public func getPendingDeepLinkAction() -> DeepLinkController.DeepLinkAction? {
        
    return cuckoo_manager.call(
    """
    getPendingDeepLinkAction() -> DeepLinkController.DeepLinkAction?
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getPendingDeepLinkAction())
        
    }
    
    

    public struct __StubbingProxy_DeepLinkControllerType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func hasDeepLink<M1: Cuckoo.Matchable>(url: M1) -> Cuckoo.ProtocolStubFunction<(URL), DeepLinkController.DeepLinkAction?> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: url) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDeepLinkControllerType.self, method:
    """
    hasDeepLink(url: URL) -> DeepLinkController.DeepLinkAction?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func handleDeepLinkAction<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(routerHost: M1, deepLinkAction: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(RouterHostType, DeepLinkController.DeepLinkAction)> where M1.MatchedType == RouterHostType, M2.MatchedType == DeepLinkController.DeepLinkAction {
            let matchers: [Cuckoo.ParameterMatcher<(RouterHostType, DeepLinkController.DeepLinkAction)>] = [wrap(matchable: routerHost) { $0.0 }, wrap(matchable: deepLinkAction) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDeepLinkControllerType.self, method:
    """
    handleDeepLinkAction(routerHost: RouterHostType, deepLinkAction: DeepLinkController.DeepLinkAction)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getPendingDeepLinkAction() -> Cuckoo.ProtocolStubFunction<(), DeepLinkController.DeepLinkAction?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockDeepLinkControllerType.self, method:
    """
    getPendingDeepLinkAction() -> DeepLinkController.DeepLinkAction?
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_DeepLinkControllerType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func hasDeepLink<M1: Cuckoo.Matchable>(url: M1) -> Cuckoo.__DoNotUse<(URL), DeepLinkController.DeepLinkAction?> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: url) { $0 }]
            return cuckoo_manager.verify(
    """
    hasDeepLink(url: URL) -> DeepLinkController.DeepLinkAction?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func handleDeepLinkAction<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(routerHost: M1, deepLinkAction: M2) -> Cuckoo.__DoNotUse<(RouterHostType, DeepLinkController.DeepLinkAction), Void> where M1.MatchedType == RouterHostType, M2.MatchedType == DeepLinkController.DeepLinkAction {
            let matchers: [Cuckoo.ParameterMatcher<(RouterHostType, DeepLinkController.DeepLinkAction)>] = [wrap(matchable: routerHost) { $0.0 }, wrap(matchable: deepLinkAction) { $0.1 }]
            return cuckoo_manager.verify(
    """
    handleDeepLinkAction(routerHost: RouterHostType, deepLinkAction: DeepLinkController.DeepLinkAction)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getPendingDeepLinkAction() -> Cuckoo.__DoNotUse<(), DeepLinkController.DeepLinkAction?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getPendingDeepLinkAction() -> DeepLinkController.DeepLinkAction?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class DeepLinkControllerTypeStub: DeepLinkControllerType {
    

    

    
    
    
    
    public func hasDeepLink(url: URL) -> DeepLinkController.DeepLinkAction?  {
        return DefaultValueRegistry.defaultValue(for: (DeepLinkController.DeepLinkAction?).self)
    }
    
    
    
    
    
    public func handleDeepLinkAction(routerHost: RouterHostType, deepLinkAction: DeepLinkController.DeepLinkAction)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func getPendingDeepLinkAction() -> DeepLinkController.DeepLinkAction?  {
        return DefaultValueRegistry.defaultValue(for: (DeepLinkController.DeepLinkAction?).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation
import SwiftUI
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_business
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation
import SwiftUI
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import ActivityIndicatorView
import SwiftUI
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI
import UIPilot
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation
import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import PartialSheet
import SwiftUI
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Shimmer
import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation
import SwiftUI
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation
import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import SwiftUI
import logic_resources

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation
import UIKit

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import Foundation
import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_common
@testable import logic_api
@testable import logic_ui

import AlertToast
import PartialSheet
import SwiftUI

import Cuckoo
@testable import logic_business
@testable import feature_common
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
    
    
    
    
    
    public func pop(animated: Bool)  {
        
    return cuckoo_manager.call(
    """
    pop(animated: Bool)
    """,
            parameters: (animated),
            escapingParameters: (animated),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.pop(animated: animated))
        
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
    
    
    
    
    
    public func popTo(with route: AppRoute, inclusive: Bool)  {
        
    return cuckoo_manager.call(
    """
    popTo(with: AppRoute, inclusive: Bool)
    """,
            parameters: (route, inclusive),
            escapingParameters: (route, inclusive),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.popTo(with: route, inclusive: inclusive))
        
    }
    
    
    
    
    
    public func popTo(with route: AppRoute)  {
        
    return cuckoo_manager.call(
    """
    popTo(with: AppRoute)
    """,
            parameters: (route),
            escapingParameters: (route),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.popTo(with: route))
        
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
    
    
    
    
    
    public func getToolbarConfig() -> UIConfig.ToolBar {
        
    return cuckoo_manager.call(
    """
    getToolbarConfig() -> UIConfig.ToolBar
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getToolbarConfig())
        
    }
    
    
    
    
    
    public func isAfterAuthorization() -> Bool {
        
    return cuckoo_manager.call(
    """
    isAfterAuthorization() -> Bool
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isAfterAuthorization())
        
    }
    
    
    
    
    
    public func isScreenForeground(with route: AppRoute) -> Bool {
        
    return cuckoo_manager.call(
    """
    isScreenForeground(with: AppRoute) -> Bool
    """,
            parameters: (route),
            escapingParameters: (route),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isScreenForeground(with: route))
        
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
        
        
        
        
        func pop<M1: Cuckoo.Matchable>(animated: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: animated) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHostType.self, method:
    """
    pop(animated: Bool)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func pop() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHostType.self, method:
    """
    pop()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func popTo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(with route: M1, inclusive: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(AppRoute, Bool)> where M1.MatchedType == AppRoute, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute, Bool)>] = [wrap(matchable: route) { $0.0 }, wrap(matchable: inclusive) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHostType.self, method:
    """
    popTo(with: AppRoute, inclusive: Bool)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func popTo<M1: Cuckoo.Matchable>(with route: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(AppRoute)> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: route) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHostType.self, method:
    """
    popTo(with: AppRoute)
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
        
        
        
        
        func getToolbarConfig() -> Cuckoo.ProtocolStubFunction<(), UIConfig.ToolBar> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHostType.self, method:
    """
    getToolbarConfig() -> UIConfig.ToolBar
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isAfterAuthorization() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHostType.self, method:
    """
    isAfterAuthorization() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isScreenForeground<M1: Cuckoo.Matchable>(with route: M1) -> Cuckoo.ProtocolStubFunction<(AppRoute), Bool> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: route) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHostType.self, method:
    """
    isScreenForeground(with: AppRoute) -> Bool
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
        func pop<M1: Cuckoo.Matchable>(animated: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: animated) { $0 }]
            return cuckoo_manager.verify(
    """
    pop(animated: Bool)
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
        func popTo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(with route: M1, inclusive: M2) -> Cuckoo.__DoNotUse<(AppRoute, Bool), Void> where M1.MatchedType == AppRoute, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute, Bool)>] = [wrap(matchable: route) { $0.0 }, wrap(matchable: inclusive) { $0.1 }]
            return cuckoo_manager.verify(
    """
    popTo(with: AppRoute, inclusive: Bool)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func popTo<M1: Cuckoo.Matchable>(with route: M1) -> Cuckoo.__DoNotUse<(AppRoute), Void> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: route) { $0 }]
            return cuckoo_manager.verify(
    """
    popTo(with: AppRoute)
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
        
        
        
        
        @discardableResult
        func getToolbarConfig() -> Cuckoo.__DoNotUse<(), UIConfig.ToolBar> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getToolbarConfig() -> UIConfig.ToolBar
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isAfterAuthorization() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    isAfterAuthorization() -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isScreenForeground<M1: Cuckoo.Matchable>(with route: M1) -> Cuckoo.__DoNotUse<(AppRoute), Bool> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: route) { $0 }]
            return cuckoo_manager.verify(
    """
    isScreenForeground(with: AppRoute) -> Bool
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
    
    
    
    
    
    public func pop(animated: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func pop()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func popTo(with route: AppRoute, inclusive: Bool)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func popTo(with route: AppRoute)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func composeApplication() -> AnyView  {
        return DefaultValueRegistry.defaultValue(for: (AnyView).self)
    }
    
    
    
    
    
    public func getCurrentScreen() -> AppRoute?  {
        return DefaultValueRegistry.defaultValue(for: (AppRoute?).self)
    }
    
    
    
    
    
    public func getToolbarConfig() -> UIConfig.ToolBar  {
        return DefaultValueRegistry.defaultValue(for: (UIConfig.ToolBar).self)
    }
    
    
    
    
    
    public func isAfterAuthorization() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
    public func isScreenForeground(with route: AppRoute) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
}





import Cuckoo
@testable import logic_business
@testable import feature_common
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




