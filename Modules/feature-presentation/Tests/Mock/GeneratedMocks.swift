import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import logic_resources
import logic_ui

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import logic_ui

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import logic_ui

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import SwiftUI
import logic_resources
import logic_ui

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Combine
import Foundation
import LocalAuthentication
import SwiftUI
import logic_authentication
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
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Combine
import Foundation
import logic_authentication
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
    
    
    
    
    
    public func hasPin() -> Bool {
        
    return cuckoo_manager.call(
    """
    hasPin() -> Bool
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.hasPin())
        
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
        
        
        
        
        func hasPin() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockQuickPinInteractorType.self, method:
    """
    hasPin() -> Bool
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
        
        
        
        
        @discardableResult
        func hasPin() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    hasPin() -> Bool
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
    
    
    
    
    
    public func hasPin() -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
}





import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources
import logic_ui

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import logic_authentication
import logic_ui

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources
import logic_ui

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources
import logic_ui

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import logic_resources
import logic_ui

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import logic_ui

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources
import logic_ui

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import logic_business
import logic_resources
import logic_ui

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources
import logic_ui

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import logic_resources
import logic_ui

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import SwiftUI
import logic_resources
import logic_ui

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import SwiftUI
import logic_business
import logic_core

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import CodeScanner
import Foundation
import SwiftUI
import logic_resources
import logic_ui

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources
import logic_ui

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import logic_business
import logic_ui

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import feature_common
import logic_api
import logic_business
import logic_core






public class MockPresentationInteractorType: PresentationInteractorType, Cuckoo.ProtocolMock {
    
    public typealias MocksType = PresentationInteractorType
    
    public typealias Stubbing = __StubbingProxy_PresentationInteractorType
    public typealias Verification = __VerificationProxy_PresentationInteractorType

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: PresentationInteractorType?

    public func enableDefaultImplementation(_ stub: PresentationInteractorType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
    public var presentationCoordinator: PresentationSessionCoordinator {
        get {
            return cuckoo_manager.getter("presentationCoordinator",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.presentationCoordinator)
        }
        
    }
    
    

    

    
    
    
    
    public func onDeviceEngagement() async -> Result<OnlineAuthenticationRequestSuccessModel, Error> {
        
    return await cuckoo_manager.call(
    """
    onDeviceEngagement() async -> Result<OnlineAuthenticationRequestSuccessModel, Error>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.onDeviceEngagement())
        
    }
    
    
    
    
    
    public func onResponsePrepare(requestItems: [RequestDataUIModel]) async -> Result<RequestItemConvertible, Error> {
        
    return await cuckoo_manager.call(
    """
    onResponsePrepare(requestItems: [RequestDataUIModel]) async -> Result<RequestItemConvertible, Error>
    """,
            parameters: (requestItems),
            escapingParameters: (requestItems),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.onResponsePrepare(requestItems: requestItems))
        
    }
    
    
    
    
    
    public func onSendResponse() async -> Result<URL?, Error> {
        
    return await cuckoo_manager.call(
    """
    onSendResponse() async -> Result<URL?, Error>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.onSendResponse())
        
    }
    
    

    public struct __StubbingProxy_PresentationInteractorType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var presentationCoordinator: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockPresentationInteractorType, PresentationSessionCoordinator> {
            return .init(manager: cuckoo_manager, name: "presentationCoordinator")
        }
        
        
        
        
        
        func onDeviceEngagement() -> Cuckoo.ProtocolStubFunction<(), Result<OnlineAuthenticationRequestSuccessModel, Error>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationInteractorType.self, method:
    """
    onDeviceEngagement() async -> Result<OnlineAuthenticationRequestSuccessModel, Error>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func onResponsePrepare<M1: Cuckoo.Matchable>(requestItems: M1) -> Cuckoo.ProtocolStubFunction<([RequestDataUIModel]), Result<RequestItemConvertible, Error>> where M1.MatchedType == [RequestDataUIModel] {
            let matchers: [Cuckoo.ParameterMatcher<([RequestDataUIModel])>] = [wrap(matchable: requestItems) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationInteractorType.self, method:
    """
    onResponsePrepare(requestItems: [RequestDataUIModel]) async -> Result<RequestItemConvertible, Error>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func onSendResponse() -> Cuckoo.ProtocolStubFunction<(), Result<URL?, Error>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationInteractorType.self, method:
    """
    onSendResponse() async -> Result<URL?, Error>
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_PresentationInteractorType: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var presentationCoordinator: Cuckoo.VerifyReadOnlyProperty<PresentationSessionCoordinator> {
            return .init(manager: cuckoo_manager, name: "presentationCoordinator", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func onDeviceEngagement() -> Cuckoo.__DoNotUse<(), Result<OnlineAuthenticationRequestSuccessModel, Error>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    onDeviceEngagement() async -> Result<OnlineAuthenticationRequestSuccessModel, Error>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func onResponsePrepare<M1: Cuckoo.Matchable>(requestItems: M1) -> Cuckoo.__DoNotUse<([RequestDataUIModel]), Result<RequestItemConvertible, Error>> where M1.MatchedType == [RequestDataUIModel] {
            let matchers: [Cuckoo.ParameterMatcher<([RequestDataUIModel])>] = [wrap(matchable: requestItems) { $0 }]
            return cuckoo_manager.verify(
    """
    onResponsePrepare(requestItems: [RequestDataUIModel]) async -> Result<RequestItemConvertible, Error>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func onSendResponse() -> Cuckoo.__DoNotUse<(), Result<URL?, Error>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    onSendResponse() async -> Result<URL?, Error>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class PresentationInteractorTypeStub: PresentationInteractorType {
    
    
    
    
    public var presentationCoordinator: PresentationSessionCoordinator {
        get {
            return DefaultValueRegistry.defaultValue(for: (PresentationSessionCoordinator).self)
        }
        
    }
    
    

    

    
    
    
    
    public func onDeviceEngagement() async -> Result<OnlineAuthenticationRequestSuccessModel, Error>  {
        return DefaultValueRegistry.defaultValue(for: (Result<OnlineAuthenticationRequestSuccessModel, Error>).self)
    }
    
    
    
    
    
    public func onResponsePrepare(requestItems: [RequestDataUIModel]) async -> Result<RequestItemConvertible, Error>  {
        return DefaultValueRegistry.defaultValue(for: (Result<RequestItemConvertible, Error>).self)
    }
    
    
    
    
    
    public func onSendResponse() async -> Result<URL?, Error>  {
        return DefaultValueRegistry.defaultValue(for: (Result<URL?, Error>).self)
    }
    
    
}





import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import feature_common
import logic_ui

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import feature_common

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import feature_common
import logic_ui

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import feature_common

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication






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
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication






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
    
    

    public struct __StubbingProxy_AnalyticsController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func initialize() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockAnalyticsController.self, method:
    """
    initialize()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func logScreen<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(screen: M1, arguments: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, [String: String])> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: screen) { $0.0 }, wrap(matchable: arguments) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAnalyticsController.self, method:
    """
    logScreen(screen: String, arguments: [String: String])
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func logEvent<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(event: M1, arguments: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(String, [String: String])> where M1.MatchedType == String, M2.MatchedType == [String: String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String: String])>] = [wrap(matchable: event) { $0.0 }, wrap(matchable: arguments) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockAnalyticsController.self, method:
    """
    logEvent(event: String, arguments: [String: String])
    """, parameterMatchers: matchers))
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


public class AnalyticsControllerStub: AnalyticsController {
    

    

    
    
    
    
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
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import Swinject

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication






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
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Alamofire
import Foundation
import logic_business






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
    

    

    

    
    
    
    
     func execute<R: NetworkRequest, T: Decodable>(with request: R, parameters: [NetworkParameter]?) async throws -> T {
        
    return try await cuckoo_manager.callThrows(
    """
    execute(with: R, parameters: [NetworkParameter]?) async throws -> T
    """,
            parameters: (request, parameters),
            escapingParameters: (request, parameters),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.execute(with: request, parameters: parameters))
        
    }
    
    
    
    
    
     func prepare<R: NetworkRequest>(request: R, parameters: [NetworkParameter]?, baseHost: String) async -> URLRequest {
        
    return await cuckoo_manager.call(
    """
    prepare(request: R, parameters: [NetworkParameter]?, baseHost: String) async -> URLRequest
    """,
            parameters: (request, parameters, baseHost),
            escapingParameters: (request, parameters, baseHost),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.prepare(request: request, parameters: parameters, baseHost: baseHost))
        
    }
    
    
    
    
    
     func log(request: URLRequest, responseData: Data?)  {
        
    return cuckoo_manager.call(
    """
    log(request: URLRequest, responseData: Data?)
    """,
            parameters: (request, responseData),
            escapingParameters: (request, responseData),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.log(request: request, responseData: responseData))
        
    }
    
    

     struct __StubbingProxy_NetworkManager: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func execute<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, R: NetworkRequest, T: Decodable>(with request: M1, parameters: M2) -> Cuckoo.ProtocolStubThrowingFunction<(R, [NetworkParameter]?), T> where M1.MatchedType == R, M2.OptionalMatchedType == [NetworkParameter] {
            let matchers: [Cuckoo.ParameterMatcher<(R, [NetworkParameter]?)>] = [wrap(matchable: request) { $0.0 }, wrap(matchable: parameters) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockNetworkManager.self, method:
    """
    execute(with: R, parameters: [NetworkParameter]?) async throws -> T
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func prepare<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, R: NetworkRequest>(request: M1, parameters: M2, baseHost: M3) -> Cuckoo.ProtocolStubFunction<(R, [NetworkParameter]?, String), URLRequest> where M1.MatchedType == R, M2.OptionalMatchedType == [NetworkParameter], M3.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(R, [NetworkParameter]?, String)>] = [wrap(matchable: request) { $0.0 }, wrap(matchable: parameters) { $0.1 }, wrap(matchable: baseHost) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockNetworkManager.self, method:
    """
    prepare(request: R, parameters: [NetworkParameter]?, baseHost: String) async -> URLRequest
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func log<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(request: M1, responseData: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(URLRequest, Data?)> where M1.MatchedType == URLRequest, M2.OptionalMatchedType == Data {
            let matchers: [Cuckoo.ParameterMatcher<(URLRequest, Data?)>] = [wrap(matchable: request) { $0.0 }, wrap(matchable: responseData) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockNetworkManager.self, method:
    """
    log(request: URLRequest, responseData: Data?)
    """, parameterMatchers: matchers))
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
        func execute<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, R: NetworkRequest, T: Decodable>(with request: M1, parameters: M2) -> Cuckoo.__DoNotUse<(R, [NetworkParameter]?), T> where M1.MatchedType == R, M2.OptionalMatchedType == [NetworkParameter] {
            let matchers: [Cuckoo.ParameterMatcher<(R, [NetworkParameter]?)>] = [wrap(matchable: request) { $0.0 }, wrap(matchable: parameters) { $0.1 }]
            return cuckoo_manager.verify(
    """
    execute(with: R, parameters: [NetworkParameter]?) async throws -> T
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func prepare<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, R: NetworkRequest>(request: M1, parameters: M2, baseHost: M3) -> Cuckoo.__DoNotUse<(R, [NetworkParameter]?, String), URLRequest> where M1.MatchedType == R, M2.OptionalMatchedType == [NetworkParameter], M3.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(R, [NetworkParameter]?, String)>] = [wrap(matchable: request) { $0.0 }, wrap(matchable: parameters) { $0.1 }, wrap(matchable: baseHost) { $0.2 }]
            return cuckoo_manager.verify(
    """
    prepare(request: R, parameters: [NetworkParameter]?, baseHost: String) async -> URLRequest
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func log<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(request: M1, responseData: M2) -> Cuckoo.__DoNotUse<(URLRequest, Data?), Void> where M1.MatchedType == URLRequest, M2.OptionalMatchedType == Data {
            let matchers: [Cuckoo.ParameterMatcher<(URLRequest, Data?)>] = [wrap(matchable: request) { $0.0 }, wrap(matchable: responseData) { $0.1 }]
            return cuckoo_manager.verify(
    """
    log(request: URLRequest, responseData: Data?)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class NetworkManagerStub: NetworkManager {
    

    

    
    
    
    
     func execute<R: NetworkRequest, T: Decodable>(with request: R, parameters: [NetworkParameter]?) async throws -> T  {
        return DefaultValueRegistry.defaultValue(for: (T).self)
    }
    
    
    
    
    
     func prepare<R: NetworkRequest>(request: R, parameters: [NetworkParameter]?, baseHost: String) async -> URLRequest  {
        return DefaultValueRegistry.defaultValue(for: (URLRequest).self)
    }
    
    
    
    
    
     func log(request: URLRequest, responseData: Data?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

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
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Swinject
import logic_business

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation






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
    
    

    public struct __StubbingProxy_SampleRepository: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func sampleCall() -> Cuckoo.ProtocolStubThrowingFunction<(), SampleResponseDTO> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSampleRepository.self, method:
    """
    sampleCall() async throws -> SampleResponseDTO
    """, parameterMatchers: matchers))
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
    """
    sampleCall() async throws -> SampleResponseDTO
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class SampleRepositoryStub: SampleRepository {
    

    

    
    
    
    
    public func sampleCall() async throws -> SampleResponseDTO  {
        return DefaultValueRegistry.defaultValue(for: (SampleResponseDTO).self)
    }
    
    
}





import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication






 class MockPinStorageConfig: PinStorageConfig, Cuckoo.ProtocolMock {
    
     typealias MocksType = PinStorageConfig
    
     typealias Stubbing = __StubbingProxy_PinStorageConfig
     typealias Verification = __VerificationProxy_PinStorageConfig

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: PinStorageConfig?

     func enableDefaultImplementation(_ stub: PinStorageConfig) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     var storageProvider: PinStorageProvider {
        get {
            return cuckoo_manager.getter("storageProvider",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.storageProvider)
        }
        
    }
    
    

    

    

     struct __StubbingProxy_PinStorageConfig: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var storageProvider: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockPinStorageConfig, PinStorageProvider> {
            return .init(manager: cuckoo_manager, name: "storageProvider")
        }
        
        
        
    }

     struct __VerificationProxy_PinStorageConfig: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var storageProvider: Cuckoo.VerifyReadOnlyProperty<PinStorageProvider> {
            return .init(manager: cuckoo_manager, name: "storageProvider", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
    }
}


 class PinStorageConfigStub: PinStorageConfig {
    
    
    
    
     var storageProvider: PinStorageProvider {
        get {
            return DefaultValueRegistry.defaultValue(for: (PinStorageProvider).self)
        }
        
    }
    
    

    

    
}





import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication






public class MockPinStorageController: PinStorageController, Cuckoo.ProtocolMock {
    
    public typealias MocksType = PinStorageController
    
    public typealias Stubbing = __StubbingProxy_PinStorageController
    public typealias Verification = __VerificationProxy_PinStorageController

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: PinStorageController?

    public func enableDefaultImplementation(_ stub: PinStorageController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func retrievePin() -> String? {
        
    return cuckoo_manager.call(
    """
    retrievePin() -> String?
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.retrievePin())
        
    }
    
    
    
    
    
    public func setPin(with pin: String)  {
        
    return cuckoo_manager.call(
    """
    setPin(with: String)
    """,
            parameters: (pin),
            escapingParameters: (pin),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setPin(with: pin))
        
    }
    
    
    
    
    
    public func isPinValid(with pin: String) -> Bool {
        
    return cuckoo_manager.call(
    """
    isPinValid(with: String) -> Bool
    """,
            parameters: (pin),
            escapingParameters: (pin),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isPinValid(with: pin))
        
    }
    
    

    public struct __StubbingProxy_PinStorageController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func retrievePin() -> Cuckoo.ProtocolStubFunction<(), String?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPinStorageController.self, method:
    """
    retrievePin() -> String?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setPin<M1: Cuckoo.Matchable>(with pin: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pin) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPinStorageController.self, method:
    """
    setPin(with: String)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isPinValid<M1: Cuckoo.Matchable>(with pin: M1) -> Cuckoo.ProtocolStubFunction<(String), Bool> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pin) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPinStorageController.self, method:
    """
    isPinValid(with: String) -> Bool
    """, parameterMatchers: matchers))
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
    """
    retrievePin() -> String?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setPin<M1: Cuckoo.Matchable>(with pin: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pin) { $0 }]
            return cuckoo_manager.verify(
    """
    setPin(with: String)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isPinValid<M1: Cuckoo.Matchable>(with pin: M1) -> Cuckoo.__DoNotUse<(String), Bool> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pin) { $0 }]
            return cuckoo_manager.verify(
    """
    isPinValid(with: String) -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class PinStorageControllerStub: PinStorageController {
    

    

    
    
    
    
    public func retrievePin() -> String?  {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    
    
    
    
    public func setPin(with pin: String)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func isPinValid(with pin: String) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
}





import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Combine
import Foundation
import LocalAuthentication
import SwiftUI
import logic_business






public class MockSystemBiometryController: SystemBiometryController, Cuckoo.ProtocolMock {
    
    public typealias MocksType = SystemBiometryController
    
    public typealias Stubbing = __StubbingProxy_SystemBiometryController
    public typealias Verification = __VerificationProxy_SystemBiometryController

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: SystemBiometryController?

    public func enableDefaultImplementation(_ stub: SystemBiometryController) {
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
    
    

    

    
    
    
    
    public func canEvaluateForBiometrics() -> AnyPublisher<Bool, SystemBiometryError> {
        
    return cuckoo_manager.call(
    """
    canEvaluateForBiometrics() -> AnyPublisher<Bool, SystemBiometryError>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.canEvaluateForBiometrics())
        
    }
    
    
    
    
    
    public func evaluateBiometrics() -> AnyPublisher<Void, SystemBiometryError> {
        
    return cuckoo_manager.call(
    """
    evaluateBiometrics() -> AnyPublisher<Void, SystemBiometryError>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.evaluateBiometrics())
        
    }
    
    
    
    
    
    public func requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometryError> {
        
    return cuckoo_manager.call(
    """
    requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometryError>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.requestBiometricUnlock())
        
    }
    
    

    public struct __StubbingProxy_SystemBiometryController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var biometryType: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSystemBiometryController, LABiometryType> {
            return .init(manager: cuckoo_manager, name: "biometryType")
        }
        
        
        
        
        
        func canEvaluateForBiometrics() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<Bool, SystemBiometryError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometryController.self, method:
    """
    canEvaluateForBiometrics() -> AnyPublisher<Bool, SystemBiometryError>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func evaluateBiometrics() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<Void, SystemBiometryError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometryController.self, method:
    """
    evaluateBiometrics() -> AnyPublisher<Void, SystemBiometryError>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func requestBiometricUnlock() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<Void, SystemBiometryError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometryController.self, method:
    """
    requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometryError>
    """, parameterMatchers: matchers))
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
    """
    canEvaluateForBiometrics() -> AnyPublisher<Bool, SystemBiometryError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func evaluateBiometrics() -> Cuckoo.__DoNotUse<(), AnyPublisher<Void, SystemBiometryError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    evaluateBiometrics() -> AnyPublisher<Void, SystemBiometryError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func requestBiometricUnlock() -> Cuckoo.__DoNotUse<(), AnyPublisher<Void, SystemBiometryError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometryError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class SystemBiometryControllerStub: SystemBiometryController {
    
    
    
    
    public var biometryType: LABiometryType {
        get {
            return DefaultValueRegistry.defaultValue(for: (LABiometryType).self)
        }
        
    }
    
    

    

    
    
    
    
    public func canEvaluateForBiometrics() -> AnyPublisher<Bool, SystemBiometryError>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Bool, SystemBiometryError>).self)
    }
    
    
    
    
    
    public func evaluateBiometrics() -> AnyPublisher<Void, SystemBiometryError>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Void, SystemBiometryError>).self)
    }
    
    
    
    
    
    public func requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometryError>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Void, SystemBiometryError>).self)
    }
    
    
}





import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Swinject
import logic_business

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Combine
import Foundation
import LocalAuthentication
import SwiftUI
import UIKit
import logic_business
import logic_resources






public class MockSystemBiometryInteractor: SystemBiometryInteractor, Cuckoo.ProtocolMock {
    
    public typealias MocksType = SystemBiometryInteractor
    
    public typealias Stubbing = __StubbingProxy_SystemBiometryInteractor
    public typealias Verification = __VerificationProxy_SystemBiometryInteractor

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: SystemBiometryInteractor?

    public func enableDefaultImplementation(_ stub: SystemBiometryInteractor) {
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
    
    

    public struct __StubbingProxy_SystemBiometryInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var biometricsImage: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSystemBiometryInteractor, Image?> {
            return .init(manager: cuckoo_manager, name: "biometricsImage")
        }
        
        
        
        
        var currentBiometricsMethod: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSystemBiometryInteractor, String> {
            return .init(manager: cuckoo_manager, name: "currentBiometricsMethod")
        }
        
        
        
        
        var biometryType: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSystemBiometryInteractor, LABiometryType> {
            return .init(manager: cuckoo_manager, name: "biometryType")
        }
        
        
        
        
        
        func authenticate() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<BiometricsState, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometryInteractor.self, method:
    """
    authenticate() -> AnyPublisher<BiometricsState, Never>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openSettingsURL<M1: Cuckoo.Matchable>(action: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(() -> Void)> where M1.MatchedType == () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: action) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometryInteractor.self, method:
    """
    openSettingsURL(action: @escaping () -> Void)
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_SystemBiometryInteractor: Cuckoo.VerificationProxy {
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


public class SystemBiometryInteractorStub: SystemBiometryInteractor {
    
    
    
    
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
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication






 class MockPinStorageProvider: PinStorageProvider, Cuckoo.ProtocolMock {
    
     typealias MocksType = PinStorageProvider
    
     typealias Stubbing = __StubbingProxy_PinStorageProvider
     typealias Verification = __VerificationProxy_PinStorageProvider

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: PinStorageProvider?

     func enableDefaultImplementation(_ stub: PinStorageProvider) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func retrievePin() -> String? {
        
    return cuckoo_manager.call(
    """
    retrievePin() -> String?
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.retrievePin())
        
    }
    
    
    
    
    
     func setPin(with pin: String)  {
        
    return cuckoo_manager.call(
    """
    setPin(with: String)
    """,
            parameters: (pin),
            escapingParameters: (pin),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setPin(with: pin))
        
    }
    
    
    
    
    
     func isPinValid(with pin: String) -> Bool {
        
    return cuckoo_manager.call(
    """
    isPinValid(with: String) -> Bool
    """,
            parameters: (pin),
            escapingParameters: (pin),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isPinValid(with: pin))
        
    }
    
    

     struct __StubbingProxy_PinStorageProvider: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func retrievePin() -> Cuckoo.ProtocolStubFunction<(), String?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPinStorageProvider.self, method:
    """
    retrievePin() -> String?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setPin<M1: Cuckoo.Matchable>(with pin: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pin) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPinStorageProvider.self, method:
    """
    setPin(with: String)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isPinValid<M1: Cuckoo.Matchable>(with pin: M1) -> Cuckoo.ProtocolStubFunction<(String), Bool> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pin) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPinStorageProvider.self, method:
    """
    isPinValid(with: String) -> Bool
    """, parameterMatchers: matchers))
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
    """
    retrievePin() -> String?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func setPin<M1: Cuckoo.Matchable>(with pin: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pin) { $0 }]
            return cuckoo_manager.verify(
    """
    setPin(with: String)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func isPinValid<M1: Cuckoo.Matchable>(with pin: M1) -> Cuckoo.__DoNotUse<(String), Bool> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: pin) { $0 }]
            return cuckoo_manager.verify(
    """
    isPinValid(with: String) -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class PinStorageProviderStub: PinStorageProvider {
    

    

    
    
    
    
     func retrievePin() -> String?  {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    
    
    
    
     func setPin(with pin: String)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     func isPinValid(with pin: String) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
}





import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import logic_business

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

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
    

    
    
    
    
    public var walletHostUrl: String {
        get {
            return cuckoo_manager.getter("walletHostUrl",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.walletHostUrl)
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
        
        
        
        var walletHostUrl: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigLogic, String> {
            return .init(manager: cuckoo_manager, name: "walletHostUrl")
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


public class ConfigLogicStub: ConfigLogic {
    
    
    
    
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
    
    
    
    
    
    public var appVersion: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    

    

    
}





import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

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
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import KeychainAccess






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
    

    
    
    
    
    public var value: String {
        get {
            return cuckoo_manager.getter("value",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.value)
        }
        
    }
    
    

    

    

    public struct __StubbingProxy_KeychainWrapper: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var value: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockKeychainWrapper, String> {
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


public class KeychainWrapperStub: KeychainWrapper {
    
    
    
    
    public var value: String {
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
    
    

    public struct __StubbingProxy_KeyChainController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func storeValue<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(key: M1, value: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(KeychainWrapper, String)> where M1.MatchedType == KeychainWrapper, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(KeychainWrapper, String)>] = [wrap(matchable: key) { $0.0 }, wrap(matchable: value) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self, method:
    """
    storeValue(key: KeychainWrapper, value: String)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getValue<M1: Cuckoo.Matchable>(key: M1) -> Cuckoo.ProtocolStubFunction<(KeychainWrapper), String?> where M1.MatchedType == KeychainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeychainWrapper)>] = [wrap(matchable: key) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self, method:
    """
    getValue(key: KeychainWrapper) -> String?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func removeObject<M1: Cuckoo.Matchable>(key: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(KeychainWrapper)> where M1.MatchedType == KeychainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeychainWrapper)>] = [wrap(matchable: key) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self, method:
    """
    removeObject(key: KeychainWrapper)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func validateKeyChainBiometry() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self, method:
    """
    validateKeyChainBiometry() throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func clearKeyChainBiometry() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self, method:
    """
    clearKeyChainBiometry()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func clear() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self, method:
    """
    clear()
    """, parameterMatchers: matchers))
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


public class KeyChainControllerStub: KeyChainController {
    

    

    
    
    
    
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
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation






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
    

    

    

    
    
    
    
    public func setValue(_ value: Any?, forKey: Prefs.Key)  {
        
    return cuckoo_manager.call(
    """
    setValue(_: Any?, forKey: Prefs.Key)
    """,
            parameters: (value, forKey),
            escapingParameters: (value, forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.setValue(value, forKey: forKey))
        
    }
    
    
    
    
    
    public func getString(forKey: Prefs.Key) -> String? {
        
    return cuckoo_manager.call(
    """
    getString(forKey: Prefs.Key) -> String?
    """,
            parameters: (forKey),
            escapingParameters: (forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getString(forKey: forKey))
        
    }
    
    
    
    
    
    public func getOptionalString(forKey: Prefs.Key) -> String {
        
    return cuckoo_manager.call(
    """
    getOptionalString(forKey: Prefs.Key) -> String
    """,
            parameters: (forKey),
            escapingParameters: (forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getOptionalString(forKey: forKey))
        
    }
    
    
    
    
    
    public func getBool(forKey: Prefs.Key) -> Bool {
        
    return cuckoo_manager.call(
    """
    getBool(forKey: Prefs.Key) -> Bool
    """,
            parameters: (forKey),
            escapingParameters: (forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getBool(forKey: forKey))
        
    }
    
    
    
    
    
    public func getFloat(forKey: Prefs.Key) -> Float {
        
    return cuckoo_manager.call(
    """
    getFloat(forKey: Prefs.Key) -> Float
    """,
            parameters: (forKey),
            escapingParameters: (forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getFloat(forKey: forKey))
        
    }
    
    
    
    
    
    public func getInt(forKey: Prefs.Key) -> Int {
        
    return cuckoo_manager.call(
    """
    getInt(forKey: Prefs.Key) -> Int
    """,
            parameters: (forKey),
            escapingParameters: (forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getInt(forKey: forKey))
        
    }
    
    
    
    
    
    public func remove(forKey: Prefs.Key)  {
        
    return cuckoo_manager.call(
    """
    remove(forKey: Prefs.Key)
    """,
            parameters: (forKey),
            escapingParameters: (forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.remove(forKey: forKey))
        
    }
    
    
    
    
    
    public func getValue(forKey: Prefs.Key) -> Any? {
        
    return cuckoo_manager.call(
    """
    getValue(forKey: Prefs.Key) -> Any?
    """,
            parameters: (forKey),
            escapingParameters: (forKey),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getValue(forKey: forKey))
        
    }
    
    
    
    
    
    public func getUserLocale() -> String {
        
    return cuckoo_manager.call(
    """
    getUserLocale() -> String
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getUserLocale())
        
    }
    
    

    public struct __StubbingProxy_PrefsController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func setValue<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable>(_ value: M1, forKey: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(Any?, Prefs.Key)> where M1.OptionalMatchedType == Any, M2.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Any?, Prefs.Key)>] = [wrap(matchable: value) { $0.0 }, wrap(matchable: forKey) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsController.self, method:
    """
    setValue(_: Any?, forKey: Prefs.Key)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getString<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.ProtocolStubFunction<(Prefs.Key), String?> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: forKey) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsController.self, method:
    """
    getString(forKey: Prefs.Key) -> String?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getOptionalString<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.ProtocolStubFunction<(Prefs.Key), String> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: forKey) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsController.self, method:
    """
    getOptionalString(forKey: Prefs.Key) -> String
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getBool<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.ProtocolStubFunction<(Prefs.Key), Bool> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: forKey) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsController.self, method:
    """
    getBool(forKey: Prefs.Key) -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getFloat<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.ProtocolStubFunction<(Prefs.Key), Float> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: forKey) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsController.self, method:
    """
    getFloat(forKey: Prefs.Key) -> Float
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getInt<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.ProtocolStubFunction<(Prefs.Key), Int> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: forKey) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsController.self, method:
    """
    getInt(forKey: Prefs.Key) -> Int
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func remove<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Prefs.Key)> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: forKey) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsController.self, method:
    """
    remove(forKey: Prefs.Key)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getValue<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.ProtocolStubFunction<(Prefs.Key), Any?> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: forKey) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsController.self, method:
    """
    getValue(forKey: Prefs.Key) -> Any?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getUserLocale() -> Cuckoo.ProtocolStubFunction<(), String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPrefsController.self, method:
    """
    getUserLocale() -> String
    """, parameterMatchers: matchers))
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
        func setValue<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable>(_ value: M1, forKey: M2) -> Cuckoo.__DoNotUse<(Any?, Prefs.Key), Void> where M1.OptionalMatchedType == Any, M2.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Any?, Prefs.Key)>] = [wrap(matchable: value) { $0.0 }, wrap(matchable: forKey) { $0.1 }]
            return cuckoo_manager.verify(
    """
    setValue(_: Any?, forKey: Prefs.Key)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getString<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.__DoNotUse<(Prefs.Key), String?> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: forKey) { $0 }]
            return cuckoo_manager.verify(
    """
    getString(forKey: Prefs.Key) -> String?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getOptionalString<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.__DoNotUse<(Prefs.Key), String> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: forKey) { $0 }]
            return cuckoo_manager.verify(
    """
    getOptionalString(forKey: Prefs.Key) -> String
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getBool<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.__DoNotUse<(Prefs.Key), Bool> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: forKey) { $0 }]
            return cuckoo_manager.verify(
    """
    getBool(forKey: Prefs.Key) -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getFloat<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.__DoNotUse<(Prefs.Key), Float> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: forKey) { $0 }]
            return cuckoo_manager.verify(
    """
    getFloat(forKey: Prefs.Key) -> Float
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getInt<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.__DoNotUse<(Prefs.Key), Int> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: forKey) { $0 }]
            return cuckoo_manager.verify(
    """
    getInt(forKey: Prefs.Key) -> Int
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func remove<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.__DoNotUse<(Prefs.Key), Void> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: forKey) { $0 }]
            return cuckoo_manager.verify(
    """
    remove(forKey: Prefs.Key)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getValue<M1: Cuckoo.Matchable>(forKey: M1) -> Cuckoo.__DoNotUse<(Prefs.Key), Any?> where M1.MatchedType == Prefs.Key {
            let matchers: [Cuckoo.ParameterMatcher<(Prefs.Key)>] = [wrap(matchable: forKey) { $0 }]
            return cuckoo_manager.verify(
    """
    getValue(forKey: Prefs.Key) -> Any?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getUserLocale() -> Cuckoo.__DoNotUse<(), String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getUserLocale() -> String
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class PrefsControllerStub: PrefsController {
    

    

    
    
    
    
    public func setValue(_ value: Any?, forKey: Prefs.Key)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func getString(forKey: Prefs.Key) -> String?  {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    
    
    
    
    public func getOptionalString(forKey: Prefs.Key) -> String  {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
    
    
    
    
    
    public func getBool(forKey: Prefs.Key) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
    public func getFloat(forKey: Prefs.Key) -> Float  {
        return DefaultValueRegistry.defaultValue(for: (Float).self)
    }
    
    
    
    
    
    public func getInt(forKey: Prefs.Key) -> Int  {
        return DefaultValueRegistry.defaultValue(for: (Int).self)
    }
    
    
    
    
    
    public func remove(forKey: Prefs.Key)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func getValue(forKey: Prefs.Key) -> Any?  {
        return DefaultValueRegistry.defaultValue(for: (Any?).self)
    }
    
    
    
    
    
    public func getUserLocale() -> String  {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
    
    
}





import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import BluetoothKit
import Combine
import Foundation
import Network
import UIKit






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
    

    
    
    
    
    public var networkPath: NWPath {
        get {
            return cuckoo_manager.getter("networkPath",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.networkPath)
        }
        
    }
    
    

    

    
    
    
    
    public func getBleAvailibity() -> AnyPublisher<Reachability.BleAvailibity, Never> {
        
    return cuckoo_manager.call(
    """
    getBleAvailibity() -> AnyPublisher<Reachability.BleAvailibity, Never>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getBleAvailibity())
        
    }
    
    
    
    
    
    public func openBleSettings()  {
        
    return cuckoo_manager.call(
    """
    openBleSettings()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.openBleSettings())
        
    }
    
    

    public struct __StubbingProxy_ReachabilityController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var networkPath: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockReachabilityController, NWPath> {
            return .init(manager: cuckoo_manager, name: "networkPath")
        }
        
        
        
        
        
        func getBleAvailibity() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<Reachability.BleAvailibity, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockReachabilityController.self, method:
    """
    getBleAvailibity() -> AnyPublisher<Reachability.BleAvailibity, Never>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func openBleSettings() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockReachabilityController.self, method:
    """
    openBleSettings()
    """, parameterMatchers: matchers))
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
    """
    getBleAvailibity() -> AnyPublisher<Reachability.BleAvailibity, Never>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func openBleSettings() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    openBleSettings()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class ReachabilityControllerStub: ReachabilityController {
    
    
    
    
    public var networkPath: NWPath {
        get {
            return DefaultValueRegistry.defaultValue(for: (NWPath).self)
        }
        
    }
    
    

    

    
    
    
    
    public func getBleAvailibity() -> AnyPublisher<Reachability.BleAvailibity, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Reachability.BleAvailibity, Never>).self)
    }
    
    
    
    
    
    public func openBleSettings()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Combine
import Foundation
import IOSSecuritySuite
import UIKit






public class MockSecurityController: SecurityController, Cuckoo.ProtocolMock {
    
    public typealias MocksType = SecurityController
    
    public typealias Stubbing = __StubbingProxy_SecurityController
    public typealias Verification = __VerificationProxy_SecurityController

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: SecurityController?

    public func enableDefaultImplementation(_ stub: SecurityController) {
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
    
    
    
    
    
    public func isApplicationSecure() -> AnyPublisher<SecurityValidation.Result, Never> {
        
    return cuckoo_manager.call(
    """
    isApplicationSecure() -> AnyPublisher<SecurityValidation.Result, Never>
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
    
    

    public struct __StubbingProxy_SecurityController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func isRunningOnEmulator() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityController.self, method:
    """
    isRunningOnEmulator() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isDeviceJailBroken() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityController.self, method:
    """
    isDeviceJailBroken() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isReverseEngineered() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityController.self, method:
    """
    isReverseEngineered() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isSignatureValid() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityController.self, method:
    """
    isSignatureValid() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isDebuggable() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityController.self, method:
    """
    isDebuggable() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isApplicationSecure() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<SecurityValidation.Result, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityController.self, method:
    """
    isApplicationSecure() -> AnyPublisher<SecurityValidation.Result, Never>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isScreenCaptureDisabled() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityController.self, method:
    """
    isScreenCaptureDisabled() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isBlockUnsecureWebContentEnabled() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityController.self, method:
    """
    isBlockUnsecureWebContentEnabled() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isDeviceBindingValid() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSecurityController.self, method:
    """
    isDeviceBindingValid() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_SecurityController: Cuckoo.VerificationProxy {
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
        func isApplicationSecure() -> Cuckoo.__DoNotUse<(), AnyPublisher<SecurityValidation.Result, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    isApplicationSecure() -> AnyPublisher<SecurityValidation.Result, Never>
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


public class SecurityControllerStub: SecurityController {
    

    

    
    
    
    
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
    
    
    
    
    
    public func isApplicationSecure() -> AnyPublisher<SecurityValidation.Result, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<SecurityValidation.Result, Never>).self)
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
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Swinject






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
    

    
    
    
    
    public var assembler: Assembler {
        get {
            return cuckoo_manager.getter("assembler",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.assembler)
        }
        
    }
    
    

    

    
    
    
    
    public func lazyLoad(with assemblies: [Assembly])  {
        
    return cuckoo_manager.call(
    """
    lazyLoad(with: [Assembly])
    """,
            parameters: (assemblies),
            escapingParameters: (assemblies),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.lazyLoad(with: assemblies))
        
    }
    
    

    public struct __StubbingProxy_DIGraphType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var assembler: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockDIGraphType, Assembler> {
            return .init(manager: cuckoo_manager, name: "assembler")
        }
        
        
        
        
        
        func lazyLoad<M1: Cuckoo.Matchable>(with assemblies: M1) -> Cuckoo.ProtocolStubNoReturnFunction<([Assembly])> where M1.MatchedType == [Assembly] {
            let matchers: [Cuckoo.ParameterMatcher<([Assembly])>] = [wrap(matchable: assemblies) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDIGraphType.self, method:
    """
    lazyLoad(with: [Assembly])
    """, parameterMatchers: matchers))
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
        func lazyLoad<M1: Cuckoo.Matchable>(with assemblies: M1) -> Cuckoo.__DoNotUse<([Assembly]), Void> where M1.MatchedType == [Assembly] {
            let matchers: [Cuckoo.ParameterMatcher<([Assembly])>] = [wrap(matchable: assemblies) { $0 }]
            return cuckoo_manager.verify(
    """
    lazyLoad(with: [Assembly])
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class DIGraphTypeStub: DIGraphType {
    
    
    
    
    public var assembler: Assembler {
        get {
            return DefaultValueRegistry.defaultValue(for: (Assembler).self)
        }
        
    }
    
    

    

    
    
    
    
    public func lazyLoad(with assemblies: [Assembly])   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Swinject

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Combine
import Foundation

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import UIKit

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Combine
import Foundation
import Peppermint
import libPhoneNumber






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
    
    

    public struct __StubbingProxy_FormValidator: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func validateForm<M1: Cuckoo.Matchable>(form: M1) -> Cuckoo.ProtocolStubFunction<(ValidatableForm), AnyPublisher<FormValidationResult, Never>> where M1.MatchedType == ValidatableForm {
            let matchers: [Cuckoo.ParameterMatcher<(ValidatableForm)>] = [wrap(matchable: form) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFormValidator.self, method:
    """
    validateForm(form: ValidatableForm) -> AnyPublisher<FormValidationResult, Never>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func validateForms<M1: Cuckoo.Matchable>(forms: M1) -> Cuckoo.ProtocolStubFunction<([ValidatableForm]), AnyPublisher<FormsValidationResult, Never>> where M1.MatchedType == [ValidatableForm] {
            let matchers: [Cuckoo.ParameterMatcher<([ValidatableForm])>] = [wrap(matchable: forms) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFormValidator.self, method:
    """
    validateForms(forms: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never>
    """, parameterMatchers: matchers))
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


public class FormValidatorStub: FormValidator {
    

    

    
    
    
    
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
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation






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
            return cuckoo_manager.getter("verifierConfig",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.verifierConfig)
        }
        
    }
    
    
    
    
    
     var vciConfig: VciConfig {
        get {
            return cuckoo_manager.getter("vciConfig",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.vciConfig)
        }
        
    }
    
    
    
    
    
     var proximityConfig: ProximityConfig {
        get {
            return cuckoo_manager.getter("proximityConfig",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.proximityConfig)
        }
        
    }
    
    
    
    
    
     var userAuthenticationRequired: Bool {
        get {
            return cuckoo_manager.getter("userAuthenticationRequired",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.userAuthenticationRequired)
        }
        
    }
    
    

    

    

     struct __StubbingProxy_WalletKitConfig: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
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


 class WalletKitConfigStub: WalletKitConfig {
    
    
    
    
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





import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Combine
import Foundation
import logic_business
import logic_resources






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
    

    
    
    
    
    public var wallet: EudiWallet {
        get {
            return cuckoo_manager.getter("wallet",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.wallet)
        }
        
    }
    
    
    
    
    
    public var activeCoordinator: PresentationSessionCoordinator? {
        get {
            return cuckoo_manager.getter("activeCoordinator",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.activeCoordinator)
        }
        
    }
    
    

    

    
    
    
    
    public func startProximityPresentation() -> PresentationSessionCoordinator {
        
    return cuckoo_manager.call(
    """
    startProximityPresentation() -> PresentationSessionCoordinator
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.startProximityPresentation())
        
    }
    
    
    
    
    
    public func startSameDevicePresentation(deepLink: URLComponents) -> PresentationSessionCoordinator {
        
    return cuckoo_manager.call(
    """
    startSameDevicePresentation(deepLink: URLComponents) -> PresentationSessionCoordinator
    """,
            parameters: (deepLink),
            escapingParameters: (deepLink),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.startSameDevicePresentation(deepLink: deepLink))
        
    }
    
    
    
    
    
    public func startCrossDevicePresentation(urlString: String) -> PresentationSessionCoordinator {
        
    return cuckoo_manager.call(
    """
    startCrossDevicePresentation(urlString: String) -> PresentationSessionCoordinator
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
    
    

    public struct __StubbingProxy_WalletKitController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var wallet: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitController, EudiWallet> {
            return .init(manager: cuckoo_manager, name: "wallet")
        }
        
        
        
        
        var activeCoordinator: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitController, PresentationSessionCoordinator?> {
            return .init(manager: cuckoo_manager, name: "activeCoordinator")
        }
        
        
        
        
        
        func startProximityPresentation() -> Cuckoo.ProtocolStubFunction<(), PresentationSessionCoordinator> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self, method:
    """
    startProximityPresentation() -> PresentationSessionCoordinator
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func startSameDevicePresentation<M1: Cuckoo.Matchable>(deepLink: M1) -> Cuckoo.ProtocolStubFunction<(URLComponents), PresentationSessionCoordinator> where M1.MatchedType == URLComponents {
            let matchers: [Cuckoo.ParameterMatcher<(URLComponents)>] = [wrap(matchable: deepLink) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self, method:
    """
    startSameDevicePresentation(deepLink: URLComponents) -> PresentationSessionCoordinator
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func startCrossDevicePresentation<M1: Cuckoo.Matchable>(urlString: M1) -> Cuckoo.ProtocolStubFunction<(String), PresentationSessionCoordinator> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: urlString) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self, method:
    """
    startCrossDevicePresentation(urlString: String) -> PresentationSessionCoordinator
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func stopPresentation() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self, method:
    """
    stopPresentation()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fetchDocuments() -> Cuckoo.ProtocolStubFunction<(), [MdocDecodable]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self, method:
    """
    fetchDocuments() -> [MdocDecodable]
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fetchDocument<M1: Cuckoo.Matchable>(with id: M1) -> Cuckoo.ProtocolStubFunction<(String), MdocDecodable?> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: id) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self, method:
    """
    fetchDocument(with: String) -> MdocDecodable?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func loadSampleData<M1: Cuckoo.Matchable>(dataFiles: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<([String])> where M1.MatchedType == [String] {
            let matchers: [Cuckoo.ParameterMatcher<([String])>] = [wrap(matchable: dataFiles) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self, method:
    """
    loadSampleData(dataFiles: [String]) async throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func clearDocuments() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self, method:
    """
    clearDocuments() async throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func deleteDocument<M1: Cuckoo.Matchable>(with type: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: type) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self, method:
    """
    deleteDocument(with: String) async throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func loadDocuments() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self, method:
    """
    loadDocuments() async throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func issueDocument<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(docType: M1, format: M2) -> Cuckoo.ProtocolStubThrowingFunction<(String, DataFormat), WalletStorage.Document> where M1.MatchedType == String, M2.MatchedType == DataFormat {
            let matchers: [Cuckoo.ParameterMatcher<(String, DataFormat)>] = [wrap(matchable: docType) { $0.0 }, wrap(matchable: format) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self, method:
    """
    issueDocument(docType: String, format: DataFormat) async throws -> WalletStorage.Document
    """, parameterMatchers: matchers))
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
    """
    startProximityPresentation() -> PresentationSessionCoordinator
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func startSameDevicePresentation<M1: Cuckoo.Matchable>(deepLink: M1) -> Cuckoo.__DoNotUse<(URLComponents), PresentationSessionCoordinator> where M1.MatchedType == URLComponents {
            let matchers: [Cuckoo.ParameterMatcher<(URLComponents)>] = [wrap(matchable: deepLink) { $0 }]
            return cuckoo_manager.verify(
    """
    startSameDevicePresentation(deepLink: URLComponents) -> PresentationSessionCoordinator
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func startCrossDevicePresentation<M1: Cuckoo.Matchable>(urlString: M1) -> Cuckoo.__DoNotUse<(String), PresentationSessionCoordinator> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: urlString) { $0 }]
            return cuckoo_manager.verify(
    """
    startCrossDevicePresentation(urlString: String) -> PresentationSessionCoordinator
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


public class WalletKitControllerStub: WalletKitController {
    
    
    
    
    public var wallet: EudiWallet {
        get {
            return DefaultValueRegistry.defaultValue(for: (EudiWallet).self)
        }
        
    }
    
    
    
    
    
    public var activeCoordinator: PresentationSessionCoordinator? {
        get {
            return DefaultValueRegistry.defaultValue(for: (PresentationSessionCoordinator?).self)
        }
        
    }
    
    

    

    
    
    
    
    public func startProximityPresentation() -> PresentationSessionCoordinator  {
        return DefaultValueRegistry.defaultValue(for: (PresentationSessionCoordinator).self)
    }
    
    
    
    
    
    public func startSameDevicePresentation(deepLink: URLComponents) -> PresentationSessionCoordinator  {
        return DefaultValueRegistry.defaultValue(for: (PresentationSessionCoordinator).self)
    }
    
    
    
    
    
    public func startCrossDevicePresentation(urlString: String) -> PresentationSessionCoordinator  {
        return DefaultValueRegistry.defaultValue(for: (PresentationSessionCoordinator).self)
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
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Combine
import Foundation
import logic_resources






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
    
    

    public struct __StubbingProxy_PresentationSessionCoordinator: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var presentationStateSubject: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockPresentationSessionCoordinator, CurrentValueSubject<PresentationState, Never>> {
            return .init(manager: cuckoo_manager, name: "presentationStateSubject")
        }
        
        
        
        
        
        func initialize() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinator.self, method:
    """
    initialize() async
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func startQrEngagement() -> Cuckoo.ProtocolStubThrowingFunction<(), Data> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinator.self, method:
    """
    startQrEngagement() async throws -> Data
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func requestReceived() -> Cuckoo.ProtocolStubThrowingFunction<(), PresentationRequest> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinator.self, method:
    """
    requestReceived() async throws -> PresentationRequest
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func sendResponse<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.OptionalMatchable>(response: M1, onSuccess: M2, onCancel: M3) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(RequestItemConvertible, ((URL?) -> Void)?, (() -> Void)?)> where M1.MatchedType == RequestItemConvertible, M2.OptionalMatchedType == ((URL?) -> Void), M3.OptionalMatchedType == (() -> Void) {
            let matchers: [Cuckoo.ParameterMatcher<(RequestItemConvertible, ((URL?) -> Void)?, (() -> Void)?)>] = [wrap(matchable: response) { $0.0 }, wrap(matchable: onSuccess) { $0.1 }, wrap(matchable: onCancel) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinator.self, method:
    """
    sendResponse(response: RequestItemConvertible, onSuccess: ((URL?) -> Void)?, onCancel: (() -> Void)?) async throws
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func onSuccess<M1: Cuckoo.Matchable>(completion: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(() -> Void)> where M1.MatchedType == () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: completion) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinator.self, method:
    """
    onSuccess(completion: () -> Void)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getState() -> Cuckoo.ProtocolStubFunction<(), PresentationState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinator.self, method:
    """
    getState() async -> PresentationState
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func setState<M1: Cuckoo.Matchable>(presentationState: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(PresentationState)> where M1.MatchedType == PresentationState {
            let matchers: [Cuckoo.ParameterMatcher<(PresentationState)>] = [wrap(matchable: presentationState) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinator.self, method:
    """
    setState(presentationState: PresentationState)
    """, parameterMatchers: matchers))
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


public class PresentationSessionCoordinatorStub: PresentationSessionCoordinator {
    
    
    
    
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
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Combine
import Foundation
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Combine
import Foundation
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Swinject

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import EudiWalletKit
import MdocDataModel18013
import MdocDataTransfer18013
import MdocSecurity18013
import WalletStorage

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

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
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

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
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

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
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

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
    

    
    
    
    
    public var log: String {
        get {
            return cuckoo_manager.getter("log",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.log)
        }
        
    }
    
    

    

    

    public struct __StubbingProxy_UIConfigType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var log: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockUIConfigType, String> {
            return .init(manager: cuckoo_manager, name: "log")
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
    
        
        
        
        var log: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "log", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
    }
}


public class UIConfigTypeStub: UIConfigType {
    
    
    
    
    public var log: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
    

    

    
}





import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import logic_business
import logic_core






public class MockDeepLinkController: DeepLinkController, Cuckoo.ProtocolMock {
    
    public typealias MocksType = DeepLinkController
    
    public typealias Stubbing = __StubbingProxy_DeepLinkController
    public typealias Verification = __VerificationProxy_DeepLinkController

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: DeepLinkController?

    public func enableDefaultImplementation(_ stub: DeepLinkController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
    public func hasDeepLink(url: URL) -> DeepLink.Executable? {
        
    return cuckoo_manager.call(
    """
    hasDeepLink(url: URL) -> DeepLink.Executable?
    """,
            parameters: (url),
            escapingParameters: (url),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.hasDeepLink(url: url))
        
    }
    
    
    
    
    
    public func handleDeepLinkAction(routerHost: RouterHost, deepLinkExecutable: DeepLink.Executable)  {
        
    return cuckoo_manager.call(
    """
    handleDeepLinkAction(routerHost: RouterHost, deepLinkExecutable: DeepLink.Executable)
    """,
            parameters: (routerHost, deepLinkExecutable),
            escapingParameters: (routerHost, deepLinkExecutable),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.handleDeepLinkAction(routerHost: routerHost, deepLinkExecutable: deepLinkExecutable))
        
    }
    
    
    
    
    
    public func getPendingDeepLinkAction() -> DeepLink.Executable? {
        
    return cuckoo_manager.call(
    """
    getPendingDeepLinkAction() -> DeepLink.Executable?
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getPendingDeepLinkAction())
        
    }
    
    
    
    
    
    public func cacheDeepLinkURL(url: URL)  {
        
    return cuckoo_manager.call(
    """
    cacheDeepLinkURL(url: URL)
    """,
            parameters: (url),
            escapingParameters: (url),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.cacheDeepLinkURL(url: url))
        
    }
    
    

    public struct __StubbingProxy_DeepLinkController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func hasDeepLink<M1: Cuckoo.Matchable>(url: M1) -> Cuckoo.ProtocolStubFunction<(URL), DeepLink.Executable?> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: url) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDeepLinkController.self, method:
    """
    hasDeepLink(url: URL) -> DeepLink.Executable?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func handleDeepLinkAction<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(routerHost: M1, deepLinkExecutable: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(RouterHost, DeepLink.Executable)> where M1.MatchedType == RouterHost, M2.MatchedType == DeepLink.Executable {
            let matchers: [Cuckoo.ParameterMatcher<(RouterHost, DeepLink.Executable)>] = [wrap(matchable: routerHost) { $0.0 }, wrap(matchable: deepLinkExecutable) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDeepLinkController.self, method:
    """
    handleDeepLinkAction(routerHost: RouterHost, deepLinkExecutable: DeepLink.Executable)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getPendingDeepLinkAction() -> Cuckoo.ProtocolStubFunction<(), DeepLink.Executable?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockDeepLinkController.self, method:
    """
    getPendingDeepLinkAction() -> DeepLink.Executable?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func cacheDeepLinkURL<M1: Cuckoo.Matchable>(url: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(URL)> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: url) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDeepLinkController.self, method:
    """
    cacheDeepLinkURL(url: URL)
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_DeepLinkController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func hasDeepLink<M1: Cuckoo.Matchable>(url: M1) -> Cuckoo.__DoNotUse<(URL), DeepLink.Executable?> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: url) { $0 }]
            return cuckoo_manager.verify(
    """
    hasDeepLink(url: URL) -> DeepLink.Executable?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func handleDeepLinkAction<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(routerHost: M1, deepLinkExecutable: M2) -> Cuckoo.__DoNotUse<(RouterHost, DeepLink.Executable), Void> where M1.MatchedType == RouterHost, M2.MatchedType == DeepLink.Executable {
            let matchers: [Cuckoo.ParameterMatcher<(RouterHost, DeepLink.Executable)>] = [wrap(matchable: routerHost) { $0.0 }, wrap(matchable: deepLinkExecutable) { $0.1 }]
            return cuckoo_manager.verify(
    """
    handleDeepLinkAction(routerHost: RouterHost, deepLinkExecutable: DeepLink.Executable)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getPendingDeepLinkAction() -> Cuckoo.__DoNotUse<(), DeepLink.Executable?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getPendingDeepLinkAction() -> DeepLink.Executable?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func cacheDeepLinkURL<M1: Cuckoo.Matchable>(url: M1) -> Cuckoo.__DoNotUse<(URL), Void> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: url) { $0 }]
            return cuckoo_manager.verify(
    """
    cacheDeepLinkURL(url: URL)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


public class DeepLinkControllerStub: DeepLinkController {
    

    

    
    
    
    
    public func hasDeepLink(url: URL) -> DeepLink.Executable?  {
        return DefaultValueRegistry.defaultValue(for: (DeepLink.Executable?).self)
    }
    
    
    
    
    
    public func handleDeepLinkAction(routerHost: RouterHost, deepLinkExecutable: DeepLink.Executable)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
    public func getPendingDeepLinkAction() -> DeepLink.Executable?  {
        return DefaultValueRegistry.defaultValue(for: (DeepLink.Executable?).self)
    }
    
    
    
    
    
    public func cacheDeepLinkURL(url: URL)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Swinject
import logic_business
import logic_core

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import SwiftUI
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_business
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import SwiftUI
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import ActivityIndicatorView
import SwiftUI
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import UIPilot
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import SwiftUI

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import PartialSheet
import SwiftUI
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import SwiftUI
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_business
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import SwiftUI

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_resources

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import UIKit

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import SwiftUI

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import Foundation
import UIKit

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import AlertToast
import PartialSheet
import Shimmer
import SwiftUI

import Cuckoo
@testable import feature_presentation
@testable import logic_business
@testable import logic_core
@testable import logic_analytics
@testable import logic_api
@testable import logic_ui
@testable import logic_authentication

import SwiftUI
import logic_business
import logic_core






public class MockRouterHost: RouterHost, Cuckoo.ProtocolMock {
    
    public typealias MocksType = RouterHost
    
    public typealias Stubbing = __StubbingProxy_RouterHost
    public typealias Verification = __VerificationProxy_RouterHost

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: RouterHost?

    public func enableDefaultImplementation(_ stub: RouterHost) {
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
    
    

    public struct __StubbingProxy_RouterHost: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func push<M1: Cuckoo.Matchable>(with route: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(AppRoute)> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: route) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self, method:
    """
    push(with: AppRoute)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func popTo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(with route: M1, inclusive: M2, animated: M3) -> Cuckoo.ProtocolStubNoReturnFunction<(AppRoute, Bool, Bool)> where M1.MatchedType == AppRoute, M2.MatchedType == Bool, M3.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute, Bool, Bool)>] = [wrap(matchable: route) { $0.0 }, wrap(matchable: inclusive) { $0.1 }, wrap(matchable: animated) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self, method:
    """
    popTo(with: AppRoute, inclusive: Bool, animated: Bool)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func pop<M1: Cuckoo.Matchable>(animated: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: animated) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self, method:
    """
    pop(animated: Bool)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func pop() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self, method:
    """
    pop()
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func popTo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(with route: M1, inclusive: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(AppRoute, Bool)> where M1.MatchedType == AppRoute, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute, Bool)>] = [wrap(matchable: route) { $0.0 }, wrap(matchable: inclusive) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self, method:
    """
    popTo(with: AppRoute, inclusive: Bool)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func popTo<M1: Cuckoo.Matchable>(with route: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(AppRoute)> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: route) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self, method:
    """
    popTo(with: AppRoute)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func composeApplication() -> Cuckoo.ProtocolStubFunction<(), AnyView> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self, method:
    """
    composeApplication() -> AnyView
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getCurrentScreen() -> Cuckoo.ProtocolStubFunction<(), AppRoute?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self, method:
    """
    getCurrentScreen() -> AppRoute?
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getToolbarConfig() -> Cuckoo.ProtocolStubFunction<(), UIConfig.ToolBar> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self, method:
    """
    getToolbarConfig() -> UIConfig.ToolBar
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isAfterAuthorization() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self, method:
    """
    isAfterAuthorization() -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func isScreenForeground<M1: Cuckoo.Matchable>(with route: M1) -> Cuckoo.ProtocolStubFunction<(AppRoute), Bool> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: route) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self, method:
    """
    isScreenForeground(with: AppRoute) -> Bool
    """, parameterMatchers: matchers))
        }
        
        
    }

    public struct __VerificationProxy_RouterHost: Cuckoo.VerificationProxy {
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


public class RouterHostStub: RouterHost {
    

    

    
    
    
    
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




