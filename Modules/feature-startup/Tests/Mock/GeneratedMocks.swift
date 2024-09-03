// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/Config/BiometricUiConfig.swift'

import Cuckoo
import logic_resources
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/Config/Issuance/IssuanceCodeUiConfig.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/Config/Issuance/IssuanceDetailUiConfig.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/Config/Issuance/IssuanceFlowUiConfig.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/Config/QuickPinUiConfig.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/Config/ScannerUiConfig.swift'

import Cuckoo
import Foundation
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/Config/SuccessUiConfig.swift'

import Cuckoo
import logic_resources
import Foundation
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/Interactor/BiometryInteractor.swift'

import Cuckoo
import Foundation
import SwiftUI
import Combine
import LocalAuthentication
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

public class MockBiometryInteractor: BiometryInteractor, Cuckoo.ProtocolMock {
    public typealias MocksType = BiometryInteractor
    public typealias Stubbing = __StubbingProxy_BiometryInteractor
    public typealias Verification = __VerificationProxy_BiometryInteractor

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any BiometryInteractor)?

    public func enableDefaultImplementation(_ stub: any BiometryInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    
    public var biometricsImage: Image? {
        get {
            return cuckoo_manager.getter(
                "biometricsImage",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.biometricsImage
            )
        }
    }
    
    public var currentBiometricsMethod: String {
        get {
            return cuckoo_manager.getter(
                "currentBiometricsMethod",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.currentBiometricsMethod
            )
        }
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

    
    public func authenticate() -> AnyPublisher<BiometricsState, Never> {
        return cuckoo_manager.call(
            "authenticate() -> AnyPublisher<BiometricsState, Never>",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.authenticate()
        )
    }
    
    public func openSettingsURL(action p0: @escaping () -> Void) {
        return cuckoo_manager.call(
            "openSettingsURL(action p0: @escaping () -> Void)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.openSettingsURL(action: p0)
        )
    }
    
    public func isBiometryEnabled() -> Bool {
        return cuckoo_manager.call(
            "isBiometryEnabled() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.isBiometryEnabled()
        )
    }
    
    public func setBiometrySelection(isEnabled p0: Bool) {
        return cuckoo_manager.call(
            "setBiometrySelection(isEnabled p0: Bool)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setBiometrySelection(isEnabled: p0)
        )
    }
    
    public func isPinValid(with p0: String) -> QuickPinPartialState {
        return cuckoo_manager.call(
            "isPinValid(with p0: String) -> QuickPinPartialState",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.isPinValid(with: p0)
        )
    }

    public struct __StubbingProxy_BiometryInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var biometricsImage: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockBiometryInteractor,Image?> {
            return .init(manager: cuckoo_manager, name: "biometricsImage")
        }
        
        var currentBiometricsMethod: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockBiometryInteractor,String> {
            return .init(manager: cuckoo_manager, name: "currentBiometricsMethod")
        }
        
        var biometryType: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockBiometryInteractor,LABiometryType> {
            return .init(manager: cuckoo_manager, name: "biometryType")
        }
        
        func authenticate() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<BiometricsState, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBiometryInteractor.self,
                method: "authenticate() -> AnyPublisher<BiometricsState, Never>",
                parameterMatchers: matchers
            ))
        }
        
        func openSettingsURL<M1: Cuckoo.Matchable>(action p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<( () -> Void)> where M1.MatchedType ==  () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<( () -> Void)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockBiometryInteractor.self,
                method: "openSettingsURL(action p0: @escaping () -> Void)",
                parameterMatchers: matchers
            ))
        }
        
        func isBiometryEnabled() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBiometryInteractor.self,
                method: "isBiometryEnabled() -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func setBiometrySelection<M1: Cuckoo.Matchable>(isEnabled p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockBiometryInteractor.self,
                method: "setBiometrySelection(isEnabled p0: Bool)",
                parameterMatchers: matchers
            ))
        }
        
        func isPinValid<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubFunction<(String), QuickPinPartialState> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockBiometryInteractor.self,
                method: "isPinValid(with p0: String) -> QuickPinPartialState",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_BiometryInteractor: Cuckoo.VerificationProxy {
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
                "authenticate() -> AnyPublisher<BiometricsState, Never>",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func openSettingsURL<M1: Cuckoo.Matchable>(action p0: M1) -> Cuckoo.__DoNotUse<( () -> Void), Void> where M1.MatchedType ==  () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<( () -> Void)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "openSettingsURL(action p0: @escaping () -> Void)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func isBiometryEnabled() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "isBiometryEnabled() -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setBiometrySelection<M1: Cuckoo.Matchable>(isEnabled p0: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setBiometrySelection(isEnabled p0: Bool)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func isPinValid<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(String), QuickPinPartialState> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "isPinValid(with p0: String) -> QuickPinPartialState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class BiometryInteractorStub:BiometryInteractor {
    
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


    
    public func authenticate() -> AnyPublisher<BiometricsState, Never> {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<BiometricsState, Never>).self)
    }
    
    public func openSettingsURL(action p0: @escaping () -> Void) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func isBiometryEnabled() -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func setBiometrySelection(isEnabled p0: Bool) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func isPinValid(with p0: String) -> QuickPinPartialState {
        return DefaultValueRegistry.defaultValue(for: (QuickPinPartialState).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/Interactor/QuickPinInteractor.swift'

import Cuckoo
import Combine
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

public class MockQuickPinInteractor: QuickPinInteractor, Cuckoo.ProtocolMock {
    public typealias MocksType = QuickPinInteractor
    public typealias Stubbing = __StubbingProxy_QuickPinInteractor
    public typealias Verification = __VerificationProxy_QuickPinInteractor

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any QuickPinInteractor)?

    public func enableDefaultImplementation(_ stub: any QuickPinInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    
    public func setPin(newPin p0: String) {
        return cuckoo_manager.call(
            "setPin(newPin p0: String)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setPin(newPin: p0)
        )
    }
    
    public func isPinValid(pin p0: String) -> QuickPinPartialState {
        return cuckoo_manager.call(
            "isPinValid(pin p0: String) -> QuickPinPartialState",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.isPinValid(pin: p0)
        )
    }
    
    public func changePin(currentPin p0: String, newPin p1: String) -> QuickPinPartialState {
        return cuckoo_manager.call(
            "changePin(currentPin p0: String, newPin p1: String) -> QuickPinPartialState",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.changePin(currentPin: p0, newPin: p1)
        )
    }
    
    public func hasPin() -> Bool {
        return cuckoo_manager.call(
            "hasPin() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.hasPin()
        )
    }

    public struct __StubbingProxy_QuickPinInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func setPin<M1: Cuckoo.Matchable>(newPin p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockQuickPinInteractor.self,
                method: "setPin(newPin p0: String)",
                parameterMatchers: matchers
            ))
        }
        
        func isPinValid<M1: Cuckoo.Matchable>(pin p0: M1) -> Cuckoo.ProtocolStubFunction<(String), QuickPinPartialState> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockQuickPinInteractor.self,
                method: "isPinValid(pin p0: String) -> QuickPinPartialState",
                parameterMatchers: matchers
            ))
        }
        
        func changePin<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(currentPin p0: M1, newPin p1: M2) -> Cuckoo.ProtocolStubFunction<(String, String), QuickPinPartialState> where M1.MatchedType == String, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockQuickPinInteractor.self,
                method: "changePin(currentPin p0: String, newPin p1: String) -> QuickPinPartialState",
                parameterMatchers: matchers
            ))
        }
        
        func hasPin() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockQuickPinInteractor.self,
                method: "hasPin() -> Bool",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_QuickPinInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func setPin<M1: Cuckoo.Matchable>(newPin p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setPin(newPin p0: String)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func isPinValid<M1: Cuckoo.Matchable>(pin p0: M1) -> Cuckoo.__DoNotUse<(String), QuickPinPartialState> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "isPinValid(pin p0: String) -> QuickPinPartialState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func changePin<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(currentPin p0: M1, newPin p1: M2) -> Cuckoo.__DoNotUse<(String, String), QuickPinPartialState> where M1.MatchedType == String, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "changePin(currentPin p0: String, newPin p1: String) -> QuickPinPartialState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func hasPin() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "hasPin() -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class QuickPinInteractorStub:QuickPinInteractor {


    
    public func setPin(newPin p0: String) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func isPinValid(pin p0: String) -> QuickPinPartialState {
        return DefaultValueRegistry.defaultValue(for: (QuickPinPartialState).self)
    }
    
    public func changePin(currentPin p0: String, newPin p1: String) -> QuickPinPartialState {
        return DefaultValueRegistry.defaultValue(for: (QuickPinPartialState).self)
    }
    
    public func hasPin() -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/UI/Biometry/BiometryView.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/UI/Biometry/BiometryViewModel.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/UI/Button/FloatingActionButtonBarView.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/UI/Component/AddNewDocumentCellView.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/UI/Component/DocumentDetailsHeaderView.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/UI/Loading/BaseLoadingView.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/UI/Loading/BaseLoadingViewModel.swift'

import Cuckoo
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

class MockBaseLoadingViewModel<Router: RouterHost>: BaseLoadingViewModel<Router>, Cuckoo.ClassMock {
    typealias MocksType = BaseLoadingViewModel<Router>
    typealias Stubbing = __StubbingProxy_BaseLoadingViewModel
    typealias Verification = __VerificationProxy_BaseLoadingViewModel

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    private var __defaultImplStub: BaseLoadingViewModel<Router>?

    func enableDefaultImplementation(_ stub: BaseLoadingViewModel<Router>) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    
    override func getTitle() -> LocalizableString.Key {
        return cuckoo_manager.call(
            "getTitle() -> LocalizableString.Key",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.getTitle(),
            defaultCall: __defaultImplStub!.getTitle()
        )
    }
    
    override func getCaption() -> LocalizableString.Key {
        return cuckoo_manager.call(
            "getCaption() -> LocalizableString.Key",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.getCaption(),
            defaultCall: __defaultImplStub!.getCaption()
        )
    }
    
    override func getOnPopRoute() -> AppRoute? {
        return cuckoo_manager.call(
            "getOnPopRoute() -> AppRoute?",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.getOnPopRoute(),
            defaultCall: __defaultImplStub!.getOnPopRoute()
        )
    }
    
    override func doWork() async {
        return await cuckoo_manager.call(
            "doWork() async",
            parameters: (),
            escapingParameters: (),
            superclassCall: await super.doWork(),
            defaultCall: await __defaultImplStub!.doWork()
        )
    }
    
    public override func getOriginator() -> AppRoute {
        return cuckoo_manager.call(
            "getOriginator() -> AppRoute",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.getOriginator(),
            defaultCall: __defaultImplStub!.getOriginator()
        )
    }
    
    public override func onNavigate(type p0: UIConfig.ThreeWayNavigationType) {
        return cuckoo_manager.call(
            "onNavigate(type p0: UIConfig.ThreeWayNavigationType)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: super.onNavigate(type: p0),
            defaultCall: __defaultImplStub!.onNavigate(type: p0)
        )
    }
    
    public override func onError(with p0: Error) {
        return cuckoo_manager.call(
            "onError(with p0: Error)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: super.onError(with: p0),
            defaultCall: __defaultImplStub!.onError(with: p0)
        )
    }

    struct __StubbingProxy_BaseLoadingViewModel: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func getTitle() -> Cuckoo.ClassStubFunction<(), LocalizableString.Key> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseLoadingViewModel.self,
                method: "getTitle() -> LocalizableString.Key",
                parameterMatchers: matchers
            ))
        }
        
        func getCaption() -> Cuckoo.ClassStubFunction<(), LocalizableString.Key> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseLoadingViewModel.self,
                method: "getCaption() -> LocalizableString.Key",
                parameterMatchers: matchers
            ))
        }
        
        func getOnPopRoute() -> Cuckoo.ClassStubFunction<(), AppRoute?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseLoadingViewModel.self,
                method: "getOnPopRoute() -> AppRoute?",
                parameterMatchers: matchers
            ))
        }
        
        func doWork() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseLoadingViewModel.self,
                method: "doWork() async",
                parameterMatchers: matchers
            ))
        }
        
        func getOriginator() -> Cuckoo.ClassStubFunction<(), AppRoute> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseLoadingViewModel.self,
                method: "getOriginator() -> AppRoute",
                parameterMatchers: matchers
            ))
        }
        
        func onNavigate<M1: Cuckoo.Matchable>(type p0: M1) -> Cuckoo.ClassStubNoReturnFunction<(UIConfig.ThreeWayNavigationType)> where M1.MatchedType == UIConfig.ThreeWayNavigationType {
            let matchers: [Cuckoo.ParameterMatcher<(UIConfig.ThreeWayNavigationType)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockBaseLoadingViewModel.self,
                method: "onNavigate(type p0: UIConfig.ThreeWayNavigationType)",
                parameterMatchers: matchers
            ))
        }
        
        func onError<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ClassStubNoReturnFunction<(Error)> where M1.MatchedType == Error {
            let matchers: [Cuckoo.ParameterMatcher<(Error)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockBaseLoadingViewModel.self,
                method: "onError(with p0: Error)",
                parameterMatchers: matchers
            ))
        }
    }

    struct __VerificationProxy_BaseLoadingViewModel: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func getTitle() -> Cuckoo.__DoNotUse<(), LocalizableString.Key> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getTitle() -> LocalizableString.Key",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getCaption() -> Cuckoo.__DoNotUse<(), LocalizableString.Key> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getCaption() -> LocalizableString.Key",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getOnPopRoute() -> Cuckoo.__DoNotUse<(), AppRoute?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getOnPopRoute() -> AppRoute?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func doWork() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "doWork() async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getOriginator() -> Cuckoo.__DoNotUse<(), AppRoute> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getOriginator() -> AppRoute",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func onNavigate<M1: Cuckoo.Matchable>(type p0: M1) -> Cuckoo.__DoNotUse<(UIConfig.ThreeWayNavigationType), Void> where M1.MatchedType == UIConfig.ThreeWayNavigationType {
            let matchers: [Cuckoo.ParameterMatcher<(UIConfig.ThreeWayNavigationType)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "onNavigate(type p0: UIConfig.ThreeWayNavigationType)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func onError<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(Error), Void> where M1.MatchedType == Error {
            let matchers: [Cuckoo.ParameterMatcher<(Error)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "onError(with p0: Error)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

class BaseLoadingViewModelStub<Router: RouterHost>:BaseLoadingViewModel<Router> {


    
    override func getTitle() -> LocalizableString.Key {
        return DefaultValueRegistry.defaultValue(for: (LocalizableString.Key).self)
    }
    
    override func getCaption() -> LocalizableString.Key {
        return DefaultValueRegistry.defaultValue(for: (LocalizableString.Key).self)
    }
    
    override func getOnPopRoute() -> AppRoute? {
        return DefaultValueRegistry.defaultValue(for: (AppRoute?).self)
    }
    
    override func doWork() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func getOriginator() -> AppRoute {
        return DefaultValueRegistry.defaultValue(for: (AppRoute).self)
    }
    
    public override func onNavigate(type p0: UIConfig.ThreeWayNavigationType) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func onError(with p0: Error) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/UI/QuickPin/QuickPinView.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/UI/QuickPin/QuickPinViewModel.swift'

import Cuckoo
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/UI/Request/BaseRequestView.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/UI/Request/BaseRequestViewModel.swift'

import Cuckoo
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

class MockBaseRequestViewModel<Router: RouterHost>: BaseRequestViewModel<Router>, Cuckoo.ClassMock {
    typealias MocksType = BaseRequestViewModel<Router>
    typealias Stubbing = __StubbingProxy_BaseRequestViewModel
    typealias Verification = __VerificationProxy_BaseRequestViewModel

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    private var __defaultImplStub: BaseRequestViewModel<Router>?

    func enableDefaultImplementation(_ stub: BaseRequestViewModel<Router>) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    
    override var isCancelModalShowing: Bool {
        get {
            return cuckoo_manager.getter(
                "isCancelModalShowing",
                superclassCall: super.isCancelModalShowing,
                defaultCall: __defaultImplStub!.isCancelModalShowing
            )
        }
        set {
            cuckoo_manager.setter(
                "isCancelModalShowing",
                value: newValue,
                superclassCall: super.isCancelModalShowing = newValue,
                defaultCall: __defaultImplStub!.isCancelModalShowing = newValue
            )
        }
    }
    
    override var isRequestInfoModalShowing: Bool {
        get {
            return cuckoo_manager.getter(
                "isRequestInfoModalShowing",
                superclassCall: super.isRequestInfoModalShowing,
                defaultCall: __defaultImplStub!.isRequestInfoModalShowing
            )
        }
        set {
            cuckoo_manager.setter(
                "isRequestInfoModalShowing",
                value: newValue,
                superclassCall: super.isRequestInfoModalShowing = newValue,
                defaultCall: __defaultImplStub!.isRequestInfoModalShowing = newValue
            )
        }
    }
    
    override var isVerifiedEntityModalShowing: Bool {
        get {
            return cuckoo_manager.getter(
                "isVerifiedEntityModalShowing",
                superclassCall: super.isVerifiedEntityModalShowing,
                defaultCall: __defaultImplStub!.isVerifiedEntityModalShowing
            )
        }
        set {
            cuckoo_manager.setter(
                "isVerifiedEntityModalShowing",
                value: newValue,
                superclassCall: super.isVerifiedEntityModalShowing = newValue,
                defaultCall: __defaultImplStub!.isVerifiedEntityModalShowing = newValue
            )
        }
    }

    
    override func doWork() async {
        return await cuckoo_manager.call(
            "doWork() async",
            parameters: (),
            escapingParameters: (),
            superclassCall: await super.doWork(),
            defaultCall: await __defaultImplStub!.doWork()
        )
    }
    
    override func getTitle() -> LocalizableString.Key {
        return cuckoo_manager.call(
            "getTitle() -> LocalizableString.Key",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.getTitle(),
            defaultCall: __defaultImplStub!.getTitle()
        )
    }
    
    override func getRelyingParty() -> String {
        return cuckoo_manager.call(
            "getRelyingParty() -> String",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.getRelyingParty(),
            defaultCall: __defaultImplStub!.getRelyingParty()
        )
    }
    
    override func getCaption() -> LocalizableString.Key {
        return cuckoo_manager.call(
            "getCaption() -> LocalizableString.Key",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.getCaption(),
            defaultCall: __defaultImplStub!.getCaption()
        )
    }
    
    override func getDataRequestInfo() -> LocalizableString.Key {
        return cuckoo_manager.call(
            "getDataRequestInfo() -> LocalizableString.Key",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.getDataRequestInfo(),
            defaultCall: __defaultImplStub!.getDataRequestInfo()
        )
    }
    
    override func getSuccessRoute() -> AppRoute? {
        return cuckoo_manager.call(
            "getSuccessRoute() -> AppRoute?",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.getSuccessRoute(),
            defaultCall: __defaultImplStub!.getSuccessRoute()
        )
    }
    
    override func getTitleCaption() -> String {
        return cuckoo_manager.call(
            "getTitleCaption() -> String",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.getTitleCaption(),
            defaultCall: __defaultImplStub!.getTitleCaption()
        )
    }
    
    override func getTrustedRelyingParty() -> LocalizableString.Key {
        return cuckoo_manager.call(
            "getTrustedRelyingParty() -> LocalizableString.Key",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.getTrustedRelyingParty(),
            defaultCall: __defaultImplStub!.getTrustedRelyingParty()
        )
    }
    
    override func getTrustedRelyingPartyInfo() -> LocalizableString.Key {
        return cuckoo_manager.call(
            "getTrustedRelyingPartyInfo() -> LocalizableString.Key",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.getTrustedRelyingPartyInfo(),
            defaultCall: __defaultImplStub!.getTrustedRelyingPartyInfo()
        )
    }
    
    override func onShare() {
        return cuckoo_manager.call(
            "onShare()",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.onShare(),
            defaultCall: __defaultImplStub!.onShare()
        )
    }
    
    override func getPopRoute() -> AppRoute? {
        return cuckoo_manager.call(
            "getPopRoute() -> AppRoute?",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.getPopRoute(),
            defaultCall: __defaultImplStub!.getPopRoute()
        )
    }
    
    public override func getOriginator() -> AppRoute {
        return cuckoo_manager.call(
            "getOriginator() -> AppRoute",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.getOriginator(),
            defaultCall: __defaultImplStub!.getOriginator()
        )
    }
    
    public override func onStartLoading() {
        return cuckoo_manager.call(
            "onStartLoading()",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.onStartLoading(),
            defaultCall: __defaultImplStub!.onStartLoading()
        )
    }
    
    public override func onError(with p0: Error) {
        return cuckoo_manager.call(
            "onError(with p0: Error)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: super.onError(with: p0),
            defaultCall: __defaultImplStub!.onError(with: p0)
        )
    }
    
    public override func onEmptyDocuments() {
        return cuckoo_manager.call(
            "onEmptyDocuments()",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.onEmptyDocuments(),
            defaultCall: __defaultImplStub!.onEmptyDocuments()
        )
    }
    
    public override func onReceivedItems(with p0: [RequestDataUIModel], title p1: LocalizableString.Key, relyingParty p2: String, isTrusted p3: Bool) {
        return cuckoo_manager.call(
            "onReceivedItems(with p0: [RequestDataUIModel], title p1: LocalizableString.Key, relyingParty p2: String, isTrusted p3: Bool)",
            parameters: (p0, p1, p2, p3),
            escapingParameters: (p0, p1, p2, p3),
            superclassCall: super.onReceivedItems(with: p0, title: p1, relyingParty: p2, isTrusted: p3),
            defaultCall: __defaultImplStub!.onReceivedItems(with: p0, title: p1, relyingParty: p2, isTrusted: p3)
        )
    }
    
    public override func resetState() {
        return cuckoo_manager.call(
            "resetState()",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.resetState(),
            defaultCall: __defaultImplStub!.resetState()
        )
    }
    
    override func onPop() {
        return cuckoo_manager.call(
            "onPop()",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.onPop(),
            defaultCall: __defaultImplStub!.onPop()
        )
    }
    
    override func onShowCancelModal() {
        return cuckoo_manager.call(
            "onShowCancelModal()",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.onShowCancelModal(),
            defaultCall: __defaultImplStub!.onShowCancelModal()
        )
    }
    
    override func onShowRequestInfoModal() {
        return cuckoo_manager.call(
            "onShowRequestInfoModal()",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.onShowRequestInfoModal(),
            defaultCall: __defaultImplStub!.onShowRequestInfoModal()
        )
    }
    
    override func onVerifiedEntityModal() {
        return cuckoo_manager.call(
            "onVerifiedEntityModal()",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.onVerifiedEntityModal(),
            defaultCall: __defaultImplStub!.onVerifiedEntityModal()
        )
    }
    
    override func onContentVisibilityChange() {
        return cuckoo_manager.call(
            "onContentVisibilityChange()",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.onContentVisibilityChange(),
            defaultCall: __defaultImplStub!.onContentVisibilityChange()
        )
    }
    
    override func onSelectionChanged(id p0: String) {
        return cuckoo_manager.call(
            "onSelectionChanged(id p0: String)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: super.onSelectionChanged(id: p0),
            defaultCall: __defaultImplStub!.onSelectionChanged(id: p0)
        )
    }

    struct __StubbingProxy_BaseRequestViewModel: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var isCancelModalShowing: Cuckoo.ClassToBeStubbedProperty<MockBaseRequestViewModel,Bool> {
            return .init(manager: cuckoo_manager, name: "isCancelModalShowing")
        }
        
        var isRequestInfoModalShowing: Cuckoo.ClassToBeStubbedProperty<MockBaseRequestViewModel,Bool> {
            return .init(manager: cuckoo_manager, name: "isRequestInfoModalShowing")
        }
        
        var isVerifiedEntityModalShowing: Cuckoo.ClassToBeStubbedProperty<MockBaseRequestViewModel,Bool> {
            return .init(manager: cuckoo_manager, name: "isVerifiedEntityModalShowing")
        }
        
        func doWork() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseRequestViewModel.self,
                method: "doWork() async",
                parameterMatchers: matchers
            ))
        }
        
        func getTitle() -> Cuckoo.ClassStubFunction<(), LocalizableString.Key> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseRequestViewModel.self,
                method: "getTitle() -> LocalizableString.Key",
                parameterMatchers: matchers
            ))
        }
        
        func getRelyingParty() -> Cuckoo.ClassStubFunction<(), String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseRequestViewModel.self,
                method: "getRelyingParty() -> String",
                parameterMatchers: matchers
            ))
        }
        
        func getCaption() -> Cuckoo.ClassStubFunction<(), LocalizableString.Key> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseRequestViewModel.self,
                method: "getCaption() -> LocalizableString.Key",
                parameterMatchers: matchers
            ))
        }
        
        func getDataRequestInfo() -> Cuckoo.ClassStubFunction<(), LocalizableString.Key> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseRequestViewModel.self,
                method: "getDataRequestInfo() -> LocalizableString.Key",
                parameterMatchers: matchers
            ))
        }
        
        func getSuccessRoute() -> Cuckoo.ClassStubFunction<(), AppRoute?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseRequestViewModel.self,
                method: "getSuccessRoute() -> AppRoute?",
                parameterMatchers: matchers
            ))
        }
        
        func getTitleCaption() -> Cuckoo.ClassStubFunction<(), String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseRequestViewModel.self,
                method: "getTitleCaption() -> String",
                parameterMatchers: matchers
            ))
        }
        
        func getTrustedRelyingParty() -> Cuckoo.ClassStubFunction<(), LocalizableString.Key> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseRequestViewModel.self,
                method: "getTrustedRelyingParty() -> LocalizableString.Key",
                parameterMatchers: matchers
            ))
        }
        
        func getTrustedRelyingPartyInfo() -> Cuckoo.ClassStubFunction<(), LocalizableString.Key> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseRequestViewModel.self,
                method: "getTrustedRelyingPartyInfo() -> LocalizableString.Key",
                parameterMatchers: matchers
            ))
        }
        
        func onShare() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseRequestViewModel.self,
                method: "onShare()",
                parameterMatchers: matchers
            ))
        }
        
        func getPopRoute() -> Cuckoo.ClassStubFunction<(), AppRoute?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseRequestViewModel.self,
                method: "getPopRoute() -> AppRoute?",
                parameterMatchers: matchers
            ))
        }
        
        func getOriginator() -> Cuckoo.ClassStubFunction<(), AppRoute> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseRequestViewModel.self,
                method: "getOriginator() -> AppRoute",
                parameterMatchers: matchers
            ))
        }
        
        func onStartLoading() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseRequestViewModel.self,
                method: "onStartLoading()",
                parameterMatchers: matchers
            ))
        }
        
        func onError<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ClassStubNoReturnFunction<(Error)> where M1.MatchedType == Error {
            let matchers: [Cuckoo.ParameterMatcher<(Error)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockBaseRequestViewModel.self,
                method: "onError(with p0: Error)",
                parameterMatchers: matchers
            ))
        }
        
        func onEmptyDocuments() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseRequestViewModel.self,
                method: "onEmptyDocuments()",
                parameterMatchers: matchers
            ))
        }
        
        func onReceivedItems<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(with p0: M1, title p1: M2, relyingParty p2: M3, isTrusted p3: M4) -> Cuckoo.ClassStubNoReturnFunction<([RequestDataUIModel], LocalizableString.Key, String, Bool)> where M1.MatchedType == [RequestDataUIModel], M2.MatchedType == LocalizableString.Key, M3.MatchedType == String, M4.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<([RequestDataUIModel], LocalizableString.Key, String, Bool)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }]
            return .init(stub: cuckoo_manager.createStub(for: MockBaseRequestViewModel.self,
                method: "onReceivedItems(with p0: [RequestDataUIModel], title p1: LocalizableString.Key, relyingParty p2: String, isTrusted p3: Bool)",
                parameterMatchers: matchers
            ))
        }
        
        func resetState() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseRequestViewModel.self,
                method: "resetState()",
                parameterMatchers: matchers
            ))
        }
        
        func onPop() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseRequestViewModel.self,
                method: "onPop()",
                parameterMatchers: matchers
            ))
        }
        
        func onShowCancelModal() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseRequestViewModel.self,
                method: "onShowCancelModal()",
                parameterMatchers: matchers
            ))
        }
        
        func onShowRequestInfoModal() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseRequestViewModel.self,
                method: "onShowRequestInfoModal()",
                parameterMatchers: matchers
            ))
        }
        
        func onVerifiedEntityModal() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseRequestViewModel.self,
                method: "onVerifiedEntityModal()",
                parameterMatchers: matchers
            ))
        }
        
        func onContentVisibilityChange() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBaseRequestViewModel.self,
                method: "onContentVisibilityChange()",
                parameterMatchers: matchers
            ))
        }
        
        func onSelectionChanged<M1: Cuckoo.Matchable>(id p0: M1) -> Cuckoo.ClassStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockBaseRequestViewModel.self,
                method: "onSelectionChanged(id p0: String)",
                parameterMatchers: matchers
            ))
        }
    }

    struct __VerificationProxy_BaseRequestViewModel: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var isCancelModalShowing: Cuckoo.VerifyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "isCancelModalShowing", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var isRequestInfoModalShowing: Cuckoo.VerifyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "isRequestInfoModalShowing", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var isVerifiedEntityModalShowing: Cuckoo.VerifyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "isVerifiedEntityModalShowing", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        @discardableResult
        func doWork() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "doWork() async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getTitle() -> Cuckoo.__DoNotUse<(), LocalizableString.Key> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getTitle() -> LocalizableString.Key",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getRelyingParty() -> Cuckoo.__DoNotUse<(), String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getRelyingParty() -> String",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getCaption() -> Cuckoo.__DoNotUse<(), LocalizableString.Key> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getCaption() -> LocalizableString.Key",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getDataRequestInfo() -> Cuckoo.__DoNotUse<(), LocalizableString.Key> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getDataRequestInfo() -> LocalizableString.Key",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getSuccessRoute() -> Cuckoo.__DoNotUse<(), AppRoute?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getSuccessRoute() -> AppRoute?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getTitleCaption() -> Cuckoo.__DoNotUse<(), String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getTitleCaption() -> String",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getTrustedRelyingParty() -> Cuckoo.__DoNotUse<(), LocalizableString.Key> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getTrustedRelyingParty() -> LocalizableString.Key",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getTrustedRelyingPartyInfo() -> Cuckoo.__DoNotUse<(), LocalizableString.Key> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getTrustedRelyingPartyInfo() -> LocalizableString.Key",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func onShare() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "onShare()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getPopRoute() -> Cuckoo.__DoNotUse<(), AppRoute?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getPopRoute() -> AppRoute?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getOriginator() -> Cuckoo.__DoNotUse<(), AppRoute> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getOriginator() -> AppRoute",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func onStartLoading() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "onStartLoading()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func onError<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(Error), Void> where M1.MatchedType == Error {
            let matchers: [Cuckoo.ParameterMatcher<(Error)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "onError(with p0: Error)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func onEmptyDocuments() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "onEmptyDocuments()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func onReceivedItems<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(with p0: M1, title p1: M2, relyingParty p2: M3, isTrusted p3: M4) -> Cuckoo.__DoNotUse<([RequestDataUIModel], LocalizableString.Key, String, Bool), Void> where M1.MatchedType == [RequestDataUIModel], M2.MatchedType == LocalizableString.Key, M3.MatchedType == String, M4.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<([RequestDataUIModel], LocalizableString.Key, String, Bool)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }]
            return cuckoo_manager.verify(
                "onReceivedItems(with p0: [RequestDataUIModel], title p1: LocalizableString.Key, relyingParty p2: String, isTrusted p3: Bool)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func resetState() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "resetState()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func onPop() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "onPop()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func onShowCancelModal() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "onShowCancelModal()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func onShowRequestInfoModal() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "onShowRequestInfoModal()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func onVerifiedEntityModal() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "onVerifiedEntityModal()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func onContentVisibilityChange() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "onContentVisibilityChange()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func onSelectionChanged<M1: Cuckoo.Matchable>(id p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "onSelectionChanged(id p0: String)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

class BaseRequestViewModelStub<Router: RouterHost>:BaseRequestViewModel<Router> {
    
    override var isCancelModalShowing: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        set {}
    }
    
    override var isRequestInfoModalShowing: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        set {}
    }
    
    override var isVerifiedEntityModalShowing: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        set {}
    }


    
    override func doWork() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    override func getTitle() -> LocalizableString.Key {
        return DefaultValueRegistry.defaultValue(for: (LocalizableString.Key).self)
    }
    
    override func getRelyingParty() -> String {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
    
    override func getCaption() -> LocalizableString.Key {
        return DefaultValueRegistry.defaultValue(for: (LocalizableString.Key).self)
    }
    
    override func getDataRequestInfo() -> LocalizableString.Key {
        return DefaultValueRegistry.defaultValue(for: (LocalizableString.Key).self)
    }
    
    override func getSuccessRoute() -> AppRoute? {
        return DefaultValueRegistry.defaultValue(for: (AppRoute?).self)
    }
    
    override func getTitleCaption() -> String {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
    
    override func getTrustedRelyingParty() -> LocalizableString.Key {
        return DefaultValueRegistry.defaultValue(for: (LocalizableString.Key).self)
    }
    
    override func getTrustedRelyingPartyInfo() -> LocalizableString.Key {
        return DefaultValueRegistry.defaultValue(for: (LocalizableString.Key).self)
    }
    
    override func onShare() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    override func getPopRoute() -> AppRoute? {
        return DefaultValueRegistry.defaultValue(for: (AppRoute?).self)
    }
    
    public override func getOriginator() -> AppRoute {
        return DefaultValueRegistry.defaultValue(for: (AppRoute).self)
    }
    
    public override func onStartLoading() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func onError(with p0: Error) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func onEmptyDocuments() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func onReceivedItems(with p0: [RequestDataUIModel], title p1: LocalizableString.Key, relyingParty p2: String, isTrusted p3: Bool) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func resetState() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    override func onPop() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    override func onShowCancelModal() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    override func onShowRequestInfoModal() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    override func onVerifiedEntityModal() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    override func onContentVisibilityChange() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    override func onSelectionChanged(id p0: String) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/UI/Request/Cell/RequestDataCellView.swift'

import Cuckoo
import Foundation
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/UI/Request/Model/RequestDataUIModel.swift'

import Cuckoo
import Foundation
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/UI/Scanner/ScannerView.swift'

import Cuckoo
import Foundation
import SwiftUI
import logic_resources
import CodeScanner
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/UI/Scanner/ScannerViewModel.swift'

import Cuckoo
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/UI/Success/SuccessView.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/feature-common/Sources/UI/Success/SuccessViewModel.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/feature-startup/Sources/Interactor/StartupInteractor.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

public class MockStartupInteractor: StartupInteractor, Cuckoo.ProtocolMock {
    public typealias MocksType = StartupInteractor
    public typealias Stubbing = __StubbingProxy_StartupInteractor
    public typealias Verification = __VerificationProxy_StartupInteractor

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any StartupInteractor)?

    public func enableDefaultImplementation(_ stub: any StartupInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    
    public func initialize(with p0: TimeInterval) async -> AppRoute {
        return await cuckoo_manager.call(
            "initialize(with p0: TimeInterval) async -> AppRoute",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.initialize(with: p0)
        )
    }

    public struct __StubbingProxy_StartupInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func initialize<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubFunction<(TimeInterval), AppRoute> where M1.MatchedType == TimeInterval {
            let matchers: [Cuckoo.ParameterMatcher<(TimeInterval)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockStartupInteractor.self,
                method: "initialize(with p0: TimeInterval) async -> AppRoute",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_StartupInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func initialize<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(TimeInterval), AppRoute> where M1.MatchedType == TimeInterval {
            let matchers: [Cuckoo.ParameterMatcher<(TimeInterval)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "initialize(with p0: TimeInterval) async -> AppRoute",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class StartupInteractorStub:StartupInteractor {


    
    public func initialize(with p0: TimeInterval) async -> AppRoute {
        return DefaultValueRegistry.defaultValue(for: (AppRoute).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/feature-startup/Sources/UI/StartupView.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/feature-startup/Sources/UI/StartupViewModel.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-analytics/Sources/Config/AnalyticsConfig.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

class MockAnalyticsConfig: AnalyticsConfig, Cuckoo.ProtocolMock {
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

class AnalyticsConfigStub:AnalyticsConfig {
    
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
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

public class MockAnalyticsController: AnalyticsController, Cuckoo.ProtocolMock {
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

public class AnalyticsControllerStub:AnalyticsController {


    
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
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-analytics/Sources/Provider/AnalyticsProvider.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

class MockAnalyticsProvider: AnalyticsProvider, Cuckoo.ProtocolMock {
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

class AnalyticsProviderStub:AnalyticsProvider {


    
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




// MARK: - Mocks generated from file: 'Modules/logic-api/Sources/Api/SampleApi.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-api/Sources/Core/NetworkManager.swift'

import Cuckoo
import Foundation
import Alamofire
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

class MockNetworkManager: NetworkManager, Cuckoo.ProtocolMock {
    typealias MocksType = NetworkManager
    typealias Stubbing = __StubbingProxy_NetworkManager
    typealias Verification = __VerificationProxy_NetworkManager

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any NetworkManager)?

    func enableDefaultImplementation(_ stub: any NetworkManager) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    
    func execute<R: NetworkRequest, T: Decodable> (with p0: R, parameters p1: [NetworkParameter]?) async throws -> T {
        return try await cuckoo_manager.callThrows(
            "execute<R: NetworkRequest, T: Decodable> (with p0: R, parameters p1: [NetworkParameter]?) async throws -> T",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.execute(with: p0, parameters: p1)
        )
    }
    
    func prepare<R: NetworkRequest> (request p0: R, parameters p1: [NetworkParameter]?, baseHost p2: String) async -> URLRequest {
        return await cuckoo_manager.call(
            "prepare<R: NetworkRequest> (request p0: R, parameters p1: [NetworkParameter]?, baseHost p2: String) async -> URLRequest",
            parameters: (p0, p1, p2),
            escapingParameters: (p0, p1, p2),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.prepare(request: p0, parameters: p1, baseHost: p2)
        )
    }
    
    func log(request p0: URLRequest, responseData p1: Data?) {
        return cuckoo_manager.call(
            "log(request p0: URLRequest, responseData p1: Data?)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.log(request: p0, responseData: p1)
        )
    }

    struct __StubbingProxy_NetworkManager: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func execute<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, R: NetworkRequest, T: Decodable>(with p0: M1, parameters p1: M2) -> Cuckoo.ProtocolStubThrowingFunction<(R, [NetworkParameter]?), T> where M1.MatchedType == R, M2.OptionalMatchedType == [NetworkParameter] {
            let matchers: [Cuckoo.ParameterMatcher<(R, [NetworkParameter]?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockNetworkManager.self,
                method: "execute<R: NetworkRequest, T: Decodable> (with p0: R, parameters p1: [NetworkParameter]?) async throws -> T",
                parameterMatchers: matchers
            ))
        }
        
        func prepare<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, R: NetworkRequest>(request p0: M1, parameters p1: M2, baseHost p2: M3) -> Cuckoo.ProtocolStubFunction<(R, [NetworkParameter]?, String), URLRequest> where M1.MatchedType == R, M2.OptionalMatchedType == [NetworkParameter], M3.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(R, [NetworkParameter]?, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockNetworkManager.self,
                method: "prepare<R: NetworkRequest> (request p0: R, parameters p1: [NetworkParameter]?, baseHost p2: String) async -> URLRequest",
                parameterMatchers: matchers
            ))
        }
        
        func log<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(request p0: M1, responseData p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(URLRequest, Data?)> where M1.MatchedType == URLRequest, M2.OptionalMatchedType == Data {
            let matchers: [Cuckoo.ParameterMatcher<(URLRequest, Data?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockNetworkManager.self,
                method: "log(request p0: URLRequest, responseData p1: Data?)",
                parameterMatchers: matchers
            ))
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
        func execute<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, R: NetworkRequest, T: Decodable>(with p0: M1, parameters p1: M2) -> Cuckoo.__DoNotUse<(R, [NetworkParameter]?), T> where M1.MatchedType == R, M2.OptionalMatchedType == [NetworkParameter] {
            let matchers: [Cuckoo.ParameterMatcher<(R, [NetworkParameter]?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "execute<R: NetworkRequest, T: Decodable> (with p0: R, parameters p1: [NetworkParameter]?) async throws -> T",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func prepare<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, R: NetworkRequest>(request p0: M1, parameters p1: M2, baseHost p2: M3) -> Cuckoo.__DoNotUse<(R, [NetworkParameter]?, String), URLRequest> where M1.MatchedType == R, M2.OptionalMatchedType == [NetworkParameter], M3.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(R, [NetworkParameter]?, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return cuckoo_manager.verify(
                "prepare<R: NetworkRequest> (request p0: R, parameters p1: [NetworkParameter]?, baseHost p2: String) async -> URLRequest",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func log<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(request p0: M1, responseData p1: M2) -> Cuckoo.__DoNotUse<(URLRequest, Data?), Void> where M1.MatchedType == URLRequest, M2.OptionalMatchedType == Data {
            let matchers: [Cuckoo.ParameterMatcher<(URLRequest, Data?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "log(request p0: URLRequest, responseData p1: Data?)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

class NetworkManagerStub:NetworkManager {


    
    func execute<R: NetworkRequest, T: Decodable> (with p0: R, parameters p1: [NetworkParameter]?) async throws -> T {
        return DefaultValueRegistry.defaultValue(for: (T).self)
    }
    
    func prepare<R: NetworkRequest> (request p0: R, parameters p1: [NetworkParameter]?, baseHost p2: String) async -> URLRequest {
        return DefaultValueRegistry.defaultValue(for: (URLRequest).self)
    }
    
    func log(request p0: URLRequest, responseData p1: Data?) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-api/Sources/Core/NetworkParameter.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-api/Sources/Core/NetworkRequest.swift'

import Cuckoo
import struct Foundation.Data
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

class MockNetworkRequest<Response>: NetworkRequest, Cuckoo.ProtocolMock {
    typealias MocksType = DefaultImplCaller
    typealias Stubbing = __StubbingProxy_NetworkRequest
    typealias Verification = __VerificationProxy_NetworkRequest

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    class DefaultImplCaller: NetworkRequest {
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

    private var __defaultImplStub: DefaultImplCaller?

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
            return cuckoo_manager.getter(
                "method",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.method
            )
        }
    }
    
    var path: String {
        get {
            return cuckoo_manager.getter(
                "path",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.path
            )
        }
    }
    
    var additionalHeaders: [String: String] {
        get {
            return cuckoo_manager.getter(
                "additionalHeaders",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.additionalHeaders
            )
        }
    }
    
    var body: Data? {
        get {
            return cuckoo_manager.getter(
                "body",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.body
            )
        }
    }


    struct __StubbingProxy_NetworkRequest: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var method: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockNetworkRequest,NetworkMethod> {
            return .init(manager: cuckoo_manager, name: "method")
        }
        
        var path: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockNetworkRequest,String> {
            return .init(manager: cuckoo_manager, name: "path")
        }
        
        var additionalHeaders: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockNetworkRequest,[String: String]> {
            return .init(manager: cuckoo_manager, name: "additionalHeaders")
        }
        
        var body: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockNetworkRequest,Data?> {
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

class NetworkRequestStub<Response>:NetworkRequest {
    
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




// MARK: - Mocks generated from file: 'Modules/logic-api/Sources/Model/Request/SampleRequestDTO.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-api/Sources/Model/Response/SampleResponseDTO.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-api/Sources/Repository/SampleRepository.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

public class MockSampleRepository: SampleRepository, Cuckoo.ProtocolMock {
    public typealias MocksType = SampleRepository
    public typealias Stubbing = __StubbingProxy_SampleRepository
    public typealias Verification = __VerificationProxy_SampleRepository

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any SampleRepository)?

    public func enableDefaultImplementation(_ stub: any SampleRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    
    public func sampleCall() async throws -> SampleResponseDTO {
        return try await cuckoo_manager.callThrows(
            "sampleCall() async throws -> SampleResponseDTO",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.sampleCall()
        )
    }

    public struct __StubbingProxy_SampleRepository: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func sampleCall() -> Cuckoo.ProtocolStubThrowingFunction<(), SampleResponseDTO> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSampleRepository.self,
                method: "sampleCall() async throws -> SampleResponseDTO",
                parameterMatchers: matchers
            ))
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
                "sampleCall() async throws -> SampleResponseDTO",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class SampleRepositoryStub:SampleRepository {


    
    public func sampleCall() async throws -> SampleResponseDTO {
        return DefaultValueRegistry.defaultValue(for: (SampleResponseDTO).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-authentication/Sources/Controller/PinStorageController.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

public class MockPinStorageController: PinStorageController, Cuckoo.ProtocolMock {
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

public class PinStorageControllerStub:PinStorageController {


    
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
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

public class MockSystemBiometryController: SystemBiometryController, Cuckoo.ProtocolMock {
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

public class SystemBiometryControllerStub:SystemBiometryController {
    
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
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-authentication/Sources/Interactor/SystemBiometryInteractor.swift'

import Cuckoo
import Foundation
import Combine
import LocalAuthentication
import UIKit
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

public class MockSystemBiometryInteractor: SystemBiometryInteractor, Cuckoo.ProtocolMock {
    public typealias MocksType = SystemBiometryInteractor
    public typealias Stubbing = __StubbingProxy_SystemBiometryInteractor
    public typealias Verification = __VerificationProxy_SystemBiometryInteractor

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any SystemBiometryInteractor)?

    public func enableDefaultImplementation(_ stub: any SystemBiometryInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    
    public var biometricsImage: Image? {
        get {
            return cuckoo_manager.getter(
                "biometricsImage",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.biometricsImage
            )
        }
    }
    
    public var currentBiometricsMethod: String {
        get {
            return cuckoo_manager.getter(
                "currentBiometricsMethod",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.currentBiometricsMethod
            )
        }
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

    
    public func authenticate() -> AnyPublisher<BiometricsState, Never> {
        return cuckoo_manager.call(
            "authenticate() -> AnyPublisher<BiometricsState, Never>",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.authenticate()
        )
    }
    
    public func openSettingsURL(action p0: @escaping () -> Void) {
        return cuckoo_manager.call(
            "openSettingsURL(action p0: @escaping () -> Void)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.openSettingsURL(action: p0)
        )
    }

    public struct __StubbingProxy_SystemBiometryInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var biometricsImage: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSystemBiometryInteractor,Image?> {
            return .init(manager: cuckoo_manager, name: "biometricsImage")
        }
        
        var currentBiometricsMethod: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSystemBiometryInteractor,String> {
            return .init(manager: cuckoo_manager, name: "currentBiometricsMethod")
        }
        
        var biometryType: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSystemBiometryInteractor,LABiometryType> {
            return .init(manager: cuckoo_manager, name: "biometryType")
        }
        
        func authenticate() -> Cuckoo.ProtocolStubFunction<(), AnyPublisher<BiometricsState, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometryInteractor.self,
                method: "authenticate() -> AnyPublisher<BiometricsState, Never>",
                parameterMatchers: matchers
            ))
        }
        
        func openSettingsURL<M1: Cuckoo.Matchable>(action p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<( () -> Void)> where M1.MatchedType ==  () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<( () -> Void)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometryInteractor.self,
                method: "openSettingsURL(action p0: @escaping () -> Void)",
                parameterMatchers: matchers
            ))
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
                "authenticate() -> AnyPublisher<BiometricsState, Never>",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func openSettingsURL<M1: Cuckoo.Matchable>(action p0: M1) -> Cuckoo.__DoNotUse<( () -> Void), Void> where M1.MatchedType ==  () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<( () -> Void)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "openSettingsURL(action p0: @escaping () -> Void)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class SystemBiometryInteractorStub:SystemBiometryInteractor {
    
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


    
    public func authenticate() -> AnyPublisher<BiometricsState, Never> {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<BiometricsState, Never>).self)
    }
    
    public func openSettingsURL(action p0: @escaping () -> Void) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}


class MockSystemBiometryInteractorImpl: SystemBiometryInteractorImpl, Cuckoo.ClassMock {
    typealias MocksType = SystemBiometryInteractorImpl
    typealias Stubbing = __StubbingProxy_SystemBiometryInteractorImpl
    typealias Verification = __VerificationProxy_SystemBiometryInteractorImpl

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    private var __defaultImplStub: SystemBiometryInteractorImpl?

    func enableDefaultImplementation(_ stub: SystemBiometryInteractorImpl) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    
    public override var biometryType: LABiometryType {
        get {
            return cuckoo_manager.getter(
                "biometryType",
                superclassCall: super.biometryType,
                defaultCall: __defaultImplStub!.biometryType
            )
        }
    }
    
    override var biometricsImage: Image? {
        get {
            return cuckoo_manager.getter(
                "biometricsImage",
                superclassCall: super.biometricsImage,
                defaultCall: __defaultImplStub!.biometricsImage
            )
        }
    }
    
    public override var currentBiometricsMethod: String {
        get {
            return cuckoo_manager.getter(
                "currentBiometricsMethod",
                superclassCall: super.currentBiometricsMethod,
                defaultCall: __defaultImplStub!.currentBiometricsMethod
            )
        }
    }

    
    public override func authenticate() -> AnyPublisher<BiometricsState, Never> {
        return cuckoo_manager.call(
            "authenticate() -> AnyPublisher<BiometricsState, Never>",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.authenticate(),
            defaultCall: __defaultImplStub!.authenticate()
        )
    }
    
    public override func openSettingsURL(action p0: @escaping () -> Void) {
        return cuckoo_manager.call(
            "openSettingsURL(action p0: @escaping () -> Void)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: super.openSettingsURL(action: p0),
            defaultCall: __defaultImplStub!.openSettingsURL(action: p0)
        )
    }

    struct __StubbingProxy_SystemBiometryInteractorImpl: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var biometryType: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockSystemBiometryInteractorImpl,LABiometryType> {
            return .init(manager: cuckoo_manager, name: "biometryType")
        }
        
        var biometricsImage: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockSystemBiometryInteractorImpl,Image?> {
            return .init(manager: cuckoo_manager, name: "biometricsImage")
        }
        
        var currentBiometricsMethod: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockSystemBiometryInteractorImpl,String> {
            return .init(manager: cuckoo_manager, name: "currentBiometricsMethod")
        }
        
        func authenticate() -> Cuckoo.ClassStubFunction<(), AnyPublisher<BiometricsState, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometryInteractorImpl.self,
                method: "authenticate() -> AnyPublisher<BiometricsState, Never>",
                parameterMatchers: matchers
            ))
        }
        
        func openSettingsURL<M1: Cuckoo.Matchable>(action p0: M1) -> Cuckoo.ClassStubNoReturnFunction<( () -> Void)> where M1.MatchedType ==  () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<( () -> Void)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometryInteractorImpl.self,
                method: "openSettingsURL(action p0: @escaping () -> Void)",
                parameterMatchers: matchers
            ))
        }
    }

    struct __VerificationProxy_SystemBiometryInteractorImpl: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var biometryType: Cuckoo.VerifyReadOnlyProperty<LABiometryType> {
            return .init(manager: cuckoo_manager, name: "biometryType", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var biometricsImage: Cuckoo.VerifyReadOnlyProperty<Image?> {
            return .init(manager: cuckoo_manager, name: "biometricsImage", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var currentBiometricsMethod: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "currentBiometricsMethod", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        @discardableResult
        func authenticate() -> Cuckoo.__DoNotUse<(), AnyPublisher<BiometricsState, Never>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "authenticate() -> AnyPublisher<BiometricsState, Never>",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func openSettingsURL<M1: Cuckoo.Matchable>(action p0: M1) -> Cuckoo.__DoNotUse<( () -> Void), Void> where M1.MatchedType ==  () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<( () -> Void)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "openSettingsURL(action p0: @escaping () -> Void)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

class SystemBiometryInteractorImplStub:SystemBiometryInteractorImpl {
    
    public override var biometryType: LABiometryType {
        get {
            return DefaultValueRegistry.defaultValue(for: (LABiometryType).self)
        }
    }
    
    override var biometricsImage: Image? {
        get {
            return DefaultValueRegistry.defaultValue(for: (Image?).self)
        }
    }
    
    public override var currentBiometricsMethod: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }


    
    public override func authenticate() -> AnyPublisher<BiometricsState, Never> {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<BiometricsState, Never>).self)
    }
    
    public override func openSettingsURL(action p0: @escaping () -> Void) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-authentication/Sources/Provider/PinStorageProvider.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

class MockPinStorageProvider: PinStorageProvider, Cuckoo.ProtocolMock {
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

class PinStorageProviderStub:PinStorageProvider {


    
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
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Builder/ArrayBuilder.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Config/ConfigLogic.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

public class MockConfigLogic: ConfigLogic, Cuckoo.ProtocolMock {
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
    
    public var appVersion: String {
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




// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Controller/KeyChainController.swift'

import Cuckoo
import Foundation
import KeychainAccess
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

public class MockKeychainWrapper: KeychainWrapper, Cuckoo.ProtocolMock {
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

public class KeychainWrapperStub:KeychainWrapper {
    
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

public class KeyChainControllerStub:KeyChainController {


    
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
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

public class MockPrefsController: PrefsController, Cuckoo.ProtocolMock {
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

public class PrefsControllerStub:PrefsController {


    
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
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

public class MockReachabilityController: ReachabilityController, Cuckoo.ProtocolMock {
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
    
    public var networkPath: NWPath {
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
    
    public var networkPath: NWPath {
        get {
            return DefaultValueRegistry.defaultValue(for: (NWPath).self)
        }
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
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

public class MockDIGraphType: DIGraphType, Cuckoo.ProtocolMock {
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

public class DIGraphTypeStub:DIGraphType {
    
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
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Array+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Data+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Encodable+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Error+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Int+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Locale+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/NSNotification+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Publisher+Extensions.swift'

import Cuckoo
import Foundation
import Combine
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/String+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/Task+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/TimeInterval+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Extension/URL+Extensions.swift'

import Cuckoo
import Foundation
import UIKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Functions/ConfigLogic+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Validator/FormValidator.swift'

import Cuckoo
import Foundation
import Combine
import Peppermint
import libPhoneNumber
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

public class MockFormValidator: FormValidator, Cuckoo.ProtocolMock {
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


    
    public func validateForm(form p0: ValidatableForm) -> AnyPublisher<FormValidationResult, Never> {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<FormValidationResult, Never>).self)
    }
    
    public func validateForms(forms p0: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never> {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<FormsValidationResult, Never>).self)
    }
}


public class MockFormValidatorInteractor: FormValidatorInteractor, Cuckoo.ProtocolMock {
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


    
    public func validateForm(form p0: ValidatableForm) -> AnyPublisher<FormValidationResult, Never> {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<FormValidationResult, Never>).self)
    }
    
    public func validateForms(forms p0: [ValidatableForm]) -> AnyPublisher<FormsValidationResult, Never> {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<FormsValidationResult, Never>).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-business/Sources/Wrapper/EquatableNoop.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Config/WalletKitConfig.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

class MockWalletKitConfig: WalletKitConfig, Cuckoo.ProtocolMock {
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
    
    var verifierConfig: VerifierConfig {
        get {
            return cuckoo_manager.getter(
                "verifierConfig",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.verifierConfig
            )
        }
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
        
        var verifierConfig: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,VerifierConfig> {
            return .init(manager: cuckoo_manager, name: "verifierConfig")
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
        
        var verifierConfig: Cuckoo.VerifyReadOnlyProperty<VerifierConfig> {
            return .init(manager: cuckoo_manager, name: "verifierConfig", callMatcher: callMatcher, sourceLocation: sourceLocation)
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

class WalletKitConfigStub:WalletKitConfig {
    
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
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

public class MockWalletKitController: WalletKitController, Cuckoo.ProtocolMock {
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
    
    public var activeCoordinator: PresentationSessionCoordinator? {
        get {
            return cuckoo_manager.getter(
                "activeCoordinator",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.activeCoordinator
            )
        }
    }

    
    public func startProximityPresentation() -> PresentationSessionCoordinator {
        return cuckoo_manager.call(
            "startProximityPresentation() -> PresentationSessionCoordinator",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.startProximityPresentation()
        )
    }
    
    public func startSameDevicePresentation(deepLink p0: URLComponents) -> PresentationSessionCoordinator {
        return cuckoo_manager.call(
            "startSameDevicePresentation(deepLink p0: URLComponents) -> PresentationSessionCoordinator",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.startSameDevicePresentation(deepLink: p0)
        )
    }
    
    public func startCrossDevicePresentation(urlString p0: String) -> PresentationSessionCoordinator {
        return cuckoo_manager.call(
            "startCrossDevicePresentation(urlString p0: String) -> PresentationSessionCoordinator",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.startCrossDevicePresentation(urlString: p0)
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
    
    public func getDynamicIssuancePendingData() async -> (pendingDoc: WalletStorage.Document, url: URL)? {
        return await cuckoo_manager.call(
            "getDynamicIssuancePendingData() async -> (pendingDoc: WalletStorage.Document, url: URL)?",
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
        
        var activeCoordinator: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitController,PresentationSessionCoordinator?> {
            return .init(manager: cuckoo_manager, name: "activeCoordinator")
        }
        
        func startProximityPresentation() -> Cuckoo.ProtocolStubFunction<(), PresentationSessionCoordinator> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "startProximityPresentation() -> PresentationSessionCoordinator",
                parameterMatchers: matchers
            ))
        }
        
        func startSameDevicePresentation<M1: Cuckoo.Matchable>(deepLink p0: M1) -> Cuckoo.ProtocolStubFunction<(URLComponents), PresentationSessionCoordinator> where M1.MatchedType == URLComponents {
            let matchers: [Cuckoo.ParameterMatcher<(URLComponents)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "startSameDevicePresentation(deepLink p0: URLComponents) -> PresentationSessionCoordinator",
                parameterMatchers: matchers
            ))
        }
        
        func startCrossDevicePresentation<M1: Cuckoo.Matchable>(urlString p0: M1) -> Cuckoo.ProtocolStubFunction<(String), PresentationSessionCoordinator> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "startCrossDevicePresentation(urlString p0: String) -> PresentationSessionCoordinator",
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
        
        func getDynamicIssuancePendingData() -> Cuckoo.ProtocolStubFunction<(), (pendingDoc: WalletStorage.Document, url: URL)?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "getDynamicIssuancePendingData() async -> (pendingDoc: WalletStorage.Document, url: URL)?",
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
        
        var activeCoordinator: Cuckoo.VerifyReadOnlyProperty<PresentationSessionCoordinator?> {
            return .init(manager: cuckoo_manager, name: "activeCoordinator", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        @discardableResult
        func startProximityPresentation() -> Cuckoo.__DoNotUse<(), PresentationSessionCoordinator> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "startProximityPresentation() -> PresentationSessionCoordinator",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func startSameDevicePresentation<M1: Cuckoo.Matchable>(deepLink p0: M1) -> Cuckoo.__DoNotUse<(URLComponents), PresentationSessionCoordinator> where M1.MatchedType == URLComponents {
            let matchers: [Cuckoo.ParameterMatcher<(URLComponents)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "startSameDevicePresentation(deepLink p0: URLComponents) -> PresentationSessionCoordinator",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func startCrossDevicePresentation<M1: Cuckoo.Matchable>(urlString p0: M1) -> Cuckoo.__DoNotUse<(String), PresentationSessionCoordinator> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "startCrossDevicePresentation(urlString p0: String) -> PresentationSessionCoordinator",
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
        func getDynamicIssuancePendingData() -> Cuckoo.__DoNotUse<(), (pendingDoc: WalletStorage.Document, url: URL)?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getDynamicIssuancePendingData() async -> (pendingDoc: WalletStorage.Document, url: URL)?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class WalletKitControllerStub:WalletKitController {
    
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


    
    public func startProximityPresentation() -> PresentationSessionCoordinator {
        return DefaultValueRegistry.defaultValue(for: (PresentationSessionCoordinator).self)
    }
    
    public func startSameDevicePresentation(deepLink p0: URLComponents) -> PresentationSessionCoordinator {
        return DefaultValueRegistry.defaultValue(for: (PresentationSessionCoordinator).self)
    }
    
    public func startCrossDevicePresentation(urlString p0: String) -> PresentationSessionCoordinator {
        return DefaultValueRegistry.defaultValue(for: (PresentationSessionCoordinator).self)
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
    
    public func getDynamicIssuancePendingData() async -> (pendingDoc: WalletStorage.Document, url: URL)? {
        return DefaultValueRegistry.defaultValue(for: ((pendingDoc: WalletStorage.Document, url: URL)?).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Coordinator/PresentationSessionCoordinator.swift'

import Cuckoo
import Foundation
import Combine
import logic_resources
import UIKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

public class MockPresentationSessionCoordinator: PresentationSessionCoordinator, Cuckoo.ProtocolMock {
    public typealias MocksType = PresentationSessionCoordinator
    public typealias Stubbing = __StubbingProxy_PresentationSessionCoordinator
    public typealias Verification = __VerificationProxy_PresentationSessionCoordinator

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any PresentationSessionCoordinator)?

    public func enableDefaultImplementation(_ stub: any PresentationSessionCoordinator) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    
    public var presentationStateSubject: CurrentValueSubject<PresentationState, Never> {
        get {
            return cuckoo_manager.getter(
                "presentationStateSubject",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.presentationStateSubject
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
    
    public func sendResponse(response p0: RequestItemConvertible, onSuccess p1: ((URL?) -> Void)?, onCancel p2: (() -> Void)?) async throws {
        return try await cuckoo_manager.callThrows(
            "sendResponse(response p0: RequestItemConvertible, onSuccess p1: ((URL?) -> Void)?, onCancel p2: (() -> Void)?) async throws",
            parameters: (p0, p1, p2),
            escapingParameters: (p0, p1, p2),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.sendResponse(response: p0, onSuccess: p1, onCancel: p2)
        )
    }
    
    public func onSuccess(completion p0: () -> Void) {
        
		return withoutActuallyEscaping(p0, do: { (p0: @escaping () -> Void) in
return cuckoo_manager.call(
            "onSuccess(completion p0: () -> Void)",
            parameters: (p0),
            escapingParameters: ({ () in fatalError("This is a stub! It's not supposed to be called!") }),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.onSuccess(completion: p0)
        )
		})

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

    public struct __StubbingProxy_PresentationSessionCoordinator: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var presentationStateSubject: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockPresentationSessionCoordinator,CurrentValueSubject<PresentationState, Never>> {
            return .init(manager: cuckoo_manager, name: "presentationStateSubject")
        }
        
        func initialize() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinator.self,
                method: "initialize() async",
                parameterMatchers: matchers
            ))
        }
        
        func startQrEngagement() -> Cuckoo.ProtocolStubThrowingFunction<(), UIImage> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinator.self,
                method: "startQrEngagement() async throws -> UIImage",
                parameterMatchers: matchers
            ))
        }
        
        func requestReceived() -> Cuckoo.ProtocolStubThrowingFunction<(), PresentationRequest> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinator.self,
                method: "requestReceived() async throws -> PresentationRequest",
                parameterMatchers: matchers
            ))
        }
        
        func sendResponse<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.OptionalMatchable>(response p0: M1, onSuccess p1: M2, onCancel p2: M3) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(RequestItemConvertible, ((URL?) -> Void)?, (() -> Void)?)> where M1.MatchedType == RequestItemConvertible, M2.OptionalMatchedType == ((URL?) -> Void), M3.OptionalMatchedType == (() -> Void) {
            let matchers: [Cuckoo.ParameterMatcher<(RequestItemConvertible, ((URL?) -> Void)?, (() -> Void)?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinator.self,
                method: "sendResponse(response p0: RequestItemConvertible, onSuccess p1: ((URL?) -> Void)?, onCancel p2: (() -> Void)?) async throws",
                parameterMatchers: matchers
            ))
        }
        
        func onSuccess<M1: Cuckoo.Matchable>(completion p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(() -> Void)> where M1.MatchedType == () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinator.self,
                method: "onSuccess(completion p0: () -> Void)",
                parameterMatchers: matchers
            ))
        }
        
        func getState() -> Cuckoo.ProtocolStubFunction<(), PresentationState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinator.self,
                method: "getState() async -> PresentationState",
                parameterMatchers: matchers
            ))
        }
        
        func setState<M1: Cuckoo.Matchable>(presentationState p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(PresentationState)> where M1.MatchedType == PresentationState {
            let matchers: [Cuckoo.ParameterMatcher<(PresentationState)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationSessionCoordinator.self,
                method: "setState(presentationState p0: PresentationState)",
                parameterMatchers: matchers
            ))
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
        func sendResponse<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.OptionalMatchable>(response p0: M1, onSuccess p1: M2, onCancel p2: M3) -> Cuckoo.__DoNotUse<(RequestItemConvertible, ((URL?) -> Void)?, (() -> Void)?), Void> where M1.MatchedType == RequestItemConvertible, M2.OptionalMatchedType == ((URL?) -> Void), M3.OptionalMatchedType == (() -> Void) {
            let matchers: [Cuckoo.ParameterMatcher<(RequestItemConvertible, ((URL?) -> Void)?, (() -> Void)?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return cuckoo_manager.verify(
                "sendResponse(response p0: RequestItemConvertible, onSuccess p1: ((URL?) -> Void)?, onCancel p2: (() -> Void)?) async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func onSuccess<M1: Cuckoo.Matchable>(completion p0: M1) -> Cuckoo.__DoNotUse<(() -> Void), Void> where M1.MatchedType == () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(() -> Void)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "onSuccess(completion p0: () -> Void)",
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
    }
}

public class PresentationSessionCoordinatorStub:PresentationSessionCoordinator {
    
    public var presentationStateSubject: CurrentValueSubject<PresentationState, Never> {
        get {
            return DefaultValueRegistry.defaultValue(for: (CurrentValueSubject<PresentationState, Never>).self)
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
    
    public func sendResponse(response p0: RequestItemConvertible, onSuccess p1: ((URL?) -> Void)?, onCancel p2: (() -> Void)?) async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func onSuccess(completion p0: () -> Void) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getState() async -> PresentationState {
        return DefaultValueRegistry.defaultValue(for: (PresentationState).self)
    }
    
    public func setState(presentationState p0: PresentationState) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Error/WalletCoreError.swift'

import Cuckoo
import Foundation
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Extension/MdocDecodable+Extensions.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Extension/NameValue+Extensions.swift'

import Cuckoo
import Foundation
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Extension/String+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Extension/URLComponents+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Extension/WalletKitConfig+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Extension/WalletStorage.Document+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Model/DeferrredDocument.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Model/DocumentIdentifier.swift'

import Cuckoo
import Foundation
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Model/MdocValue.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-core/Sources/Model/RequestItemConvertible.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

public class MockRequestItemConvertible: RequestItemConvertible, Cuckoo.ProtocolMock {
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

public class RequestItemConvertibleStub:RequestItemConvertible {


    
    public func asRequestItems() -> RequestConvertibleItems {
        return DefaultValueRegistry.defaultValue(for: (RequestConvertibleItems).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/Architecture/BaseViewModel.swift'

import Cuckoo
import SwiftUI
import Combine
import Copyable
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

public class MockViewState: ViewState, Cuckoo.ProtocolMock {
    public typealias MocksType = ViewState
    public typealias Stubbing = __StubbingProxy_ViewState
    public typealias Verification = __VerificationProxy_ViewState

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any ViewState)?

    public func enableDefaultImplementation(_ stub: any ViewState) {
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

public class ViewStateStub:ViewState {


}


class MockBaseViewModel<Router: RouterHost, UiState: ViewState>: BaseViewModel<Router, UiState>, Cuckoo.ClassMock {
    typealias MocksType = BaseViewModel<Router, UiState>
    typealias Stubbing = __StubbingProxy_BaseViewModel
    typealias Verification = __VerificationProxy_BaseViewModel

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    private var __defaultImplStub: BaseViewModel<Router, UiState>?

    func enableDefaultImplementation(_ stub: BaseViewModel<Router, UiState>) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    
    public override var cancellables: Set<AnyCancellable> {
        get {
            return cuckoo_manager.getter(
                "cancellables",
                superclassCall: super.cancellables,
                defaultCall: __defaultImplStub!.cancellables
            )
        }
        set {
            cuckoo_manager.setter(
                "cancellables",
                value: newValue,
                superclassCall: super.cancellables = newValue,
                defaultCall: __defaultImplStub!.cancellables = newValue
            )
        }
    }
    
    public override var viewState: UiState {
        get {
            return cuckoo_manager.getter(
                "viewState",
                superclassCall: super.viewState,
                defaultCall: __defaultImplStub!.viewState
            )
        }
    }

    
    public override func setState(_ p0: (UiState) -> UiState) {
        
		return withoutActuallyEscaping(p0, do: { (p0: @escaping (UiState) -> UiState) in
return cuckoo_manager.call(
            "setState(_ p0: (UiState) -> UiState)",
            parameters: (p0),
            escapingParameters: ({ _ in fatalError("This is a stub! It's not supposed to be called!") }),
            superclassCall: super.setState(p0),
            defaultCall: __defaultImplStub!.setState(p0)
        )
		})

    }

    struct __StubbingProxy_BaseViewModel: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var cancellables: Cuckoo.ClassToBeStubbedProperty<MockBaseViewModel,Set<AnyCancellable>> {
            return .init(manager: cuckoo_manager, name: "cancellables")
        }
        
        var viewState: Cuckoo.ClassToBeStubbedReadOnlyProperty<MockBaseViewModel,UiState> {
            return .init(manager: cuckoo_manager, name: "viewState")
        }
        
        func setState<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.ClassStubNoReturnFunction<((UiState) -> UiState)> where M1.MatchedType == (UiState) -> UiState {
            let matchers: [Cuckoo.ParameterMatcher<((UiState) -> UiState)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockBaseViewModel.self,
                method: "setState(_ p0: (UiState) -> UiState)",
                parameterMatchers: matchers
            ))
        }
    }

    struct __VerificationProxy_BaseViewModel: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var cancellables: Cuckoo.VerifyProperty<Set<AnyCancellable>> {
            return .init(manager: cuckoo_manager, name: "cancellables", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var viewState: Cuckoo.VerifyReadOnlyProperty<UiState> {
            return .init(manager: cuckoo_manager, name: "viewState", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        @discardableResult
        func setState<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.__DoNotUse<((UiState) -> UiState), Void> where M1.MatchedType == (UiState) -> UiState {
            let matchers: [Cuckoo.ParameterMatcher<((UiState) -> UiState)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setState(_ p0: (UiState) -> UiState)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

class BaseViewModelStub<Router: RouterHost, UiState: ViewState>:BaseViewModel<Router, UiState> {
    
    public override var cancellables: Set<AnyCancellable> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Set<AnyCancellable>).self)
        }
        set {}
    }
    
    public override var viewState: UiState {
        get {
            return DefaultValueRegistry.defaultValue(for: (UiState).self)
        }
    }


    
    public override func setState(_ p0: (UiState) -> UiState) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/Config/ConfigUiLogic.swift'

import Cuckoo
import Foundation
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

public class MockConfigUiLogic: ConfigUiLogic, Cuckoo.ProtocolMock {
    public typealias MocksType = ConfigUiLogic
    public typealias Stubbing = __StubbingProxy_ConfigUiLogic
    public typealias Verification = __VerificationProxy_ConfigUiLogic

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any ConfigUiLogic)?

    public func enableDefaultImplementation(_ stub: any ConfigUiLogic) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    
    public var dashboardRoute: AppRoute {
        get {
            return cuckoo_manager.getter(
                "dashboardRoute",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.dashboardRoute
            )
        }
    }
    
    public var issuanceRoute: AppRoute {
        get {
            return cuckoo_manager.getter(
                "issuanceRoute",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.issuanceRoute
            )
        }
    }
    
    public var backgroundColorForScreenDictionary: [AppRouteKey: UIConfig.ToolBar] {
        get {
            return cuckoo_manager.getter(
                "backgroundColorForScreenDictionary",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.backgroundColorForScreenDictionary
            )
        }
    }

    public required init(themeConfiguration p0: ThemeConfiguration) {}

    public struct __StubbingProxy_ConfigUiLogic: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var dashboardRoute: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigUiLogic,AppRoute> {
            return .init(manager: cuckoo_manager, name: "dashboardRoute")
        }
        
        var issuanceRoute: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigUiLogic,AppRoute> {
            return .init(manager: cuckoo_manager, name: "issuanceRoute")
        }
        
        var backgroundColorForScreenDictionary: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigUiLogic,[AppRouteKey: UIConfig.ToolBar]> {
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
        
        var dashboardRoute: Cuckoo.VerifyReadOnlyProperty<AppRoute> {
            return .init(manager: cuckoo_manager, name: "dashboardRoute", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var issuanceRoute: Cuckoo.VerifyReadOnlyProperty<AppRoute> {
            return .init(manager: cuckoo_manager, name: "issuanceRoute", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var backgroundColorForScreenDictionary: Cuckoo.VerifyReadOnlyProperty<[AppRouteKey: UIConfig.ToolBar]> {
            return .init(manager: cuckoo_manager, name: "backgroundColorForScreenDictionary", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    }
}

public class ConfigUiLogicStub:ConfigUiLogic {
    
    public var dashboardRoute: AppRoute {
        get {
            return DefaultValueRegistry.defaultValue(for: (AppRoute).self)
        }
    }
    
    public var issuanceRoute: AppRoute {
        get {
            return DefaultValueRegistry.defaultValue(for: (AppRoute).self)
        }
    }
    
    public var backgroundColorForScreenDictionary: [AppRouteKey: UIConfig.ToolBar] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([AppRouteKey: UIConfig.ToolBar]).self)
        }
    }

    
    public required init(themeConfiguration p0: ThemeConfiguration) {}

}




// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/Config/UIConfig.swift'

import Cuckoo
import Foundation
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

public class MockUIConfigType: UIConfigType, Cuckoo.ProtocolMock {
    public typealias MocksType = UIConfigType
    public typealias Stubbing = __StubbingProxy_UIConfigType
    public typealias Verification = __VerificationProxy_UIConfigType

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any UIConfigType)?

    public func enableDefaultImplementation(_ stub: any UIConfigType) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    
    public var log: String {
        get {
            return cuckoo_manager.getter(
                "log",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.log
            )
        }
    }


    public struct __StubbingProxy_UIConfigType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var log: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockUIConfigType,String> {
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

public class UIConfigTypeStub:UIConfigType {
    
    public var log: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }


}




// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/Controller/DeepLinkController.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

public class MockDeepLinkController: DeepLinkController, Cuckoo.ProtocolMock {
    public typealias MocksType = DeepLinkController
    public typealias Stubbing = __StubbingProxy_DeepLinkController
    public typealias Verification = __VerificationProxy_DeepLinkController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any DeepLinkController)?

    public func enableDefaultImplementation(_ stub: any DeepLinkController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    
    public func hasDeepLink(url p0: URL) -> DeepLink.Executable? {
        return cuckoo_manager.call(
            "hasDeepLink(url p0: URL) -> DeepLink.Executable?",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.hasDeepLink(url: p0)
        )
    }
    
    public func handleDeepLinkAction(routerHost p0: RouterHost, deepLinkExecutable p1: DeepLink.Executable) {
        return cuckoo_manager.call(
            "handleDeepLinkAction(routerHost p0: RouterHost, deepLinkExecutable p1: DeepLink.Executable)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.handleDeepLinkAction(routerHost: p0, deepLinkExecutable: p1)
        )
    }
    
    public func getPendingDeepLinkAction() -> DeepLink.Executable? {
        return cuckoo_manager.call(
            "getPendingDeepLinkAction() -> DeepLink.Executable?",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getPendingDeepLinkAction()
        )
    }
    
    public func cacheDeepLinkURL(url p0: URL) {
        return cuckoo_manager.call(
            "cacheDeepLinkURL(url p0: URL)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.cacheDeepLinkURL(url: p0)
        )
    }
    
    public func removeCachedDeepLinkURL() {
        return cuckoo_manager.call(
            "removeCachedDeepLinkURL()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.removeCachedDeepLinkURL()
        )
    }

    public struct __StubbingProxy_DeepLinkController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func hasDeepLink<M1: Cuckoo.Matchable>(url p0: M1) -> Cuckoo.ProtocolStubFunction<(URL), DeepLink.Executable?> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDeepLinkController.self,
                method: "hasDeepLink(url p0: URL) -> DeepLink.Executable?",
                parameterMatchers: matchers
            ))
        }
        
        func handleDeepLinkAction<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(routerHost p0: M1, deepLinkExecutable p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(RouterHost, DeepLink.Executable)> where M1.MatchedType == RouterHost, M2.MatchedType == DeepLink.Executable {
            let matchers: [Cuckoo.ParameterMatcher<(RouterHost, DeepLink.Executable)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDeepLinkController.self,
                method: "handleDeepLinkAction(routerHost p0: RouterHost, deepLinkExecutable p1: DeepLink.Executable)",
                parameterMatchers: matchers
            ))
        }
        
        func getPendingDeepLinkAction() -> Cuckoo.ProtocolStubFunction<(), DeepLink.Executable?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockDeepLinkController.self,
                method: "getPendingDeepLinkAction() -> DeepLink.Executable?",
                parameterMatchers: matchers
            ))
        }
        
        func cacheDeepLinkURL<M1: Cuckoo.Matchable>(url p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(URL)> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDeepLinkController.self,
                method: "cacheDeepLinkURL(url p0: URL)",
                parameterMatchers: matchers
            ))
        }
        
        func removeCachedDeepLinkURL() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockDeepLinkController.self,
                method: "removeCachedDeepLinkURL()",
                parameterMatchers: matchers
            ))
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
        func hasDeepLink<M1: Cuckoo.Matchable>(url p0: M1) -> Cuckoo.__DoNotUse<(URL), DeepLink.Executable?> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "hasDeepLink(url p0: URL) -> DeepLink.Executable?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func handleDeepLinkAction<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(routerHost p0: M1, deepLinkExecutable p1: M2) -> Cuckoo.__DoNotUse<(RouterHost, DeepLink.Executable), Void> where M1.MatchedType == RouterHost, M2.MatchedType == DeepLink.Executable {
            let matchers: [Cuckoo.ParameterMatcher<(RouterHost, DeepLink.Executable)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "handleDeepLinkAction(routerHost p0: RouterHost, deepLinkExecutable p1: DeepLink.Executable)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getPendingDeepLinkAction() -> Cuckoo.__DoNotUse<(), DeepLink.Executable?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getPendingDeepLinkAction() -> DeepLink.Executable?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func cacheDeepLinkURL<M1: Cuckoo.Matchable>(url p0: M1) -> Cuckoo.__DoNotUse<(URL), Void> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "cacheDeepLinkURL(url p0: URL)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func removeCachedDeepLinkURL() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "removeCachedDeepLinkURL()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class DeepLinkControllerStub:DeepLinkController {


    
    public func hasDeepLink(url p0: URL) -> DeepLink.Executable? {
        return DefaultValueRegistry.defaultValue(for: (DeepLink.Executable?).self)
    }
    
    public func handleDeepLinkAction(routerHost p0: RouterHost, deepLinkExecutable p1: DeepLink.Executable) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getPendingDeepLinkAction() -> DeepLink.Executable? {
        return DefaultValueRegistry.defaultValue(for: (DeepLink.Executable?).self)
    }
    
    public func cacheDeepLinkURL(url p0: URL) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func removeCachedDeepLinkURL() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/Controller/UrlSchemaController.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

class MockUrlSchemaController: UrlSchemaController, Cuckoo.ProtocolMock {
    typealias MocksType = UrlSchemaController
    typealias Stubbing = __StubbingProxy_UrlSchemaController
    typealias Verification = __VerificationProxy_UrlSchemaController

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any UrlSchemaController)?

    func enableDefaultImplementation(_ stub: any UrlSchemaController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    
    func retrieveSchemas(with p0: String) -> [String] {
        return cuckoo_manager.call(
            "retrieveSchemas(with p0: String) -> [String]",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.retrieveSchemas(with: p0)
        )
    }

    struct __StubbingProxy_UrlSchemaController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func retrieveSchemas<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubFunction<(String), [String]> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockUrlSchemaController.self,
                method: "retrieveSchemas(with p0: String) -> [String]",
                parameterMatchers: matchers
            ))
        }
    }

    struct __VerificationProxy_UrlSchemaController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func retrieveSchemas<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(String), [String]> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "retrieveSchemas(with p0: String) -> [String]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

class UrlSchemaControllerStub:UrlSchemaController {


    
    func retrieveSchemas(with p0: String) -> [String] {
        return DefaultValueRegistry.defaultValue(for: ([String]).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Button/ButtonStyles.swift'

import Cuckoo
import Foundation
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Button/ButtonViewStyle.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Button/FloatingActionButtonView.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Blur/BlurView.swift'

import Cuckoo
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Content/ContentEmptyView.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Content/ContentErrorView.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Content/ContentExpandableView.swift'

import Cuckoo
import Foundation
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Content/ContentHeaderView.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Content/ContentLoaderView.swift'

import Cuckoo
import SwiftUI
import ActivityIndicatorView
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Content/ContentScreenView.swift'

import Cuckoo
import SwiftUI
import logic_resources
import UIPilot
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Content/ContentSheetView.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Content/ContentTitleView.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Input/FloatingTextFieldView.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Input/PinTextFieldView.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Input/SearchBarView.swift'

import Cuckoo
import Foundation
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Progress/BlurProgressView.swift'

import Cuckoo
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Progress/NormalProgressView.swift'

import Cuckoo
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Sheet/SheetContentView.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Sheet/SheetStyle.swift'

import Cuckoo
import PartialSheet
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Splash/SplashBackgroundView.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Text/ExpandableTextView.swift'

import Cuckoo
import Foundation
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Text/KeyValueView.swift'

import Cuckoo
import Foundation
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Text/ScrollableTextView.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Type/AccesibilityLocatorViewModifier.swift'

import Cuckoo
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

public class MockLocatorType: LocatorType, Cuckoo.ProtocolMock {
    public typealias MocksType = LocatorType
    public typealias Stubbing = __StubbingProxy_LocatorType
    public typealias Verification = __VerificationProxy_LocatorType

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any LocatorType)?

    public func enableDefaultImplementation(_ stub: any LocatorType) {
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

    
    public func value() -> String {
        return cuckoo_manager.call(
            "value() -> String",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.value()
        )
    }

    public struct __StubbingProxy_LocatorType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var id: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockLocatorType,String> {
            return .init(manager: cuckoo_manager, name: "id")
        }
        
        func value() -> Cuckoo.ProtocolStubFunction<(), String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockLocatorType.self,
                method: "value() -> String",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_LocatorType: Cuckoo.VerificationProxy {
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
        
        
        @discardableResult
        func value() -> Cuckoo.__DoNotUse<(), String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "value() -> String",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class LocatorTypeStub:LocatorType {
    
    public var id: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }


    
    public func value() -> String {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
}




// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Type/FastenedDynamicModifier.swift'

import Cuckoo
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Wrap/WrapButtonView.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Wrap/WrapCheckBoxView.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Component/Wrap/WrapIconView.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/EasySpacer.swift'

import Cuckoo
import SwiftUI
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/DesignSystem/Shape/RoundedCornerShape.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/Extension/Image+Extensions.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/Extension/LocalizedStringKey+Extensions.swift'

import Cuckoo
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/Extension/TextField+Extensions.swift'

import Cuckoo
import SwiftUI
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/Extension/UIApplication+Extensions.swift'

import Cuckoo
import Foundation
import UIKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/Extension/UIDevice+Extensions.swift'

import Cuckoo
import Foundation
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/Extension/UIScreen+Extensions.swift'

import Cuckoo
import Foundation
import UIKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/Extension/View+Extensions.swift'

import Cuckoo
import SwiftUI
import AlertToast
import PartialSheet
import Shimmer
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup



// MARK: - Mocks generated from file: 'Modules/logic-ui/Sources/Navigation/RouterContract.swift'

import Cuckoo
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_startup

public class MockRouterHost: RouterHost, Cuckoo.ProtocolMock {
    public typealias MocksType = RouterHost
    public typealias Stubbing = __StubbingProxy_RouterHost
    public typealias Verification = __VerificationProxy_RouterHost

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any RouterHost)?

    public func enableDefaultImplementation(_ stub: any RouterHost) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    
    public func push(with p0: AppRoute) {
        return cuckoo_manager.call(
            "push(with p0: AppRoute)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.push(with: p0)
        )
    }
    
    public func popTo(with p0: AppRoute, inclusive p1: Bool, animated p2: Bool) {
        return cuckoo_manager.call(
            "popTo(with p0: AppRoute, inclusive p1: Bool, animated p2: Bool)",
            parameters: (p0, p1, p2),
            escapingParameters: (p0, p1, p2),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.popTo(with: p0, inclusive: p1, animated: p2)
        )
    }
    
    public func pop(animated p0: Bool) {
        return cuckoo_manager.call(
            "pop(animated p0: Bool)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.pop(animated: p0)
        )
    }
    
    public func pop() {
        return cuckoo_manager.call(
            "pop()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.pop()
        )
    }
    
    public func popTo(with p0: AppRoute, inclusive p1: Bool) {
        return cuckoo_manager.call(
            "popTo(with p0: AppRoute, inclusive p1: Bool)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.popTo(with: p0, inclusive: p1)
        )
    }
    
    public func popTo(with p0: AppRoute) {
        return cuckoo_manager.call(
            "popTo(with p0: AppRoute)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.popTo(with: p0)
        )
    }
    
    public func composeApplication() -> AnyView {
        return cuckoo_manager.call(
            "composeApplication() -> AnyView",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.composeApplication()
        )
    }
    
    public func getCurrentScreen() -> AppRoute? {
        return cuckoo_manager.call(
            "getCurrentScreen() -> AppRoute?",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getCurrentScreen()
        )
    }
    
    public func getToolbarConfig() -> UIConfig.ToolBar {
        return cuckoo_manager.call(
            "getToolbarConfig() -> UIConfig.ToolBar",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getToolbarConfig()
        )
    }
    
    public func userIsLoggedInWithDocuments() -> Bool {
        return cuckoo_manager.call(
            "userIsLoggedInWithDocuments() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.userIsLoggedInWithDocuments()
        )
    }
    
    public func userIsLoggedInWithNoDocuments() -> Bool {
        return cuckoo_manager.call(
            "userIsLoggedInWithNoDocuments() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.userIsLoggedInWithNoDocuments()
        )
    }
    
    public func isScreenForeground(with p0: AppRoute) -> Bool {
        return cuckoo_manager.call(
            "isScreenForeground(with p0: AppRoute) -> Bool",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.isScreenForeground(with: p0)
        )
    }
    
    public func isScreenOnBackStack(with p0: AppRoute) -> Bool {
        return cuckoo_manager.call(
            "isScreenOnBackStack(with p0: AppRoute) -> Bool",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.isScreenOnBackStack(with: p0)
        )
    }

    public struct __StubbingProxy_RouterHost: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func push<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(AppRoute)> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self,
                method: "push(with p0: AppRoute)",
                parameterMatchers: matchers
            ))
        }
        
        func popTo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(with p0: M1, inclusive p1: M2, animated p2: M3) -> Cuckoo.ProtocolStubNoReturnFunction<(AppRoute, Bool, Bool)> where M1.MatchedType == AppRoute, M2.MatchedType == Bool, M3.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute, Bool, Bool)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self,
                method: "popTo(with p0: AppRoute, inclusive p1: Bool, animated p2: Bool)",
                parameterMatchers: matchers
            ))
        }
        
        func pop<M1: Cuckoo.Matchable>(animated p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self,
                method: "pop(animated p0: Bool)",
                parameterMatchers: matchers
            ))
        }
        
        func pop() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self,
                method: "pop()",
                parameterMatchers: matchers
            ))
        }
        
        func popTo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(with p0: M1, inclusive p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(AppRoute, Bool)> where M1.MatchedType == AppRoute, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute, Bool)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self,
                method: "popTo(with p0: AppRoute, inclusive p1: Bool)",
                parameterMatchers: matchers
            ))
        }
        
        func popTo<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(AppRoute)> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self,
                method: "popTo(with p0: AppRoute)",
                parameterMatchers: matchers
            ))
        }
        
        func composeApplication() -> Cuckoo.ProtocolStubFunction<(), AnyView> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self,
                method: "composeApplication() -> AnyView",
                parameterMatchers: matchers
            ))
        }
        
        func getCurrentScreen() -> Cuckoo.ProtocolStubFunction<(), AppRoute?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self,
                method: "getCurrentScreen() -> AppRoute?",
                parameterMatchers: matchers
            ))
        }
        
        func getToolbarConfig() -> Cuckoo.ProtocolStubFunction<(), UIConfig.ToolBar> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self,
                method: "getToolbarConfig() -> UIConfig.ToolBar",
                parameterMatchers: matchers
            ))
        }
        
        func userIsLoggedInWithDocuments() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self,
                method: "userIsLoggedInWithDocuments() -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func userIsLoggedInWithNoDocuments() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self,
                method: "userIsLoggedInWithNoDocuments() -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func isScreenForeground<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubFunction<(AppRoute), Bool> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self,
                method: "isScreenForeground(with p0: AppRoute) -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func isScreenOnBackStack<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubFunction<(AppRoute), Bool> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self,
                method: "isScreenOnBackStack(with p0: AppRoute) -> Bool",
                parameterMatchers: matchers
            ))
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
        func push<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(AppRoute), Void> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "push(with p0: AppRoute)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func popTo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(with p0: M1, inclusive p1: M2, animated p2: M3) -> Cuckoo.__DoNotUse<(AppRoute, Bool, Bool), Void> where M1.MatchedType == AppRoute, M2.MatchedType == Bool, M3.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute, Bool, Bool)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return cuckoo_manager.verify(
                "popTo(with p0: AppRoute, inclusive p1: Bool, animated p2: Bool)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func pop<M1: Cuckoo.Matchable>(animated p0: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "pop(animated p0: Bool)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func pop() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "pop()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func popTo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(with p0: M1, inclusive p1: M2) -> Cuckoo.__DoNotUse<(AppRoute, Bool), Void> where M1.MatchedType == AppRoute, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute, Bool)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "popTo(with p0: AppRoute, inclusive p1: Bool)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func popTo<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(AppRoute), Void> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "popTo(with p0: AppRoute)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func composeApplication() -> Cuckoo.__DoNotUse<(), AnyView> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "composeApplication() -> AnyView",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getCurrentScreen() -> Cuckoo.__DoNotUse<(), AppRoute?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getCurrentScreen() -> AppRoute?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getToolbarConfig() -> Cuckoo.__DoNotUse<(), UIConfig.ToolBar> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getToolbarConfig() -> UIConfig.ToolBar",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func userIsLoggedInWithDocuments() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "userIsLoggedInWithDocuments() -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func userIsLoggedInWithNoDocuments() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "userIsLoggedInWithNoDocuments() -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func isScreenForeground<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(AppRoute), Bool> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "isScreenForeground(with p0: AppRoute) -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func isScreenOnBackStack<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(AppRoute), Bool> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "isScreenOnBackStack(with p0: AppRoute) -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class RouterHostStub:RouterHost {


    
    public func push(with p0: AppRoute) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func popTo(with p0: AppRoute, inclusive p1: Bool, animated p2: Bool) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func pop(animated p0: Bool) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func pop() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func popTo(with p0: AppRoute, inclusive p1: Bool) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func popTo(with p0: AppRoute) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func composeApplication() -> AnyView {
        return DefaultValueRegistry.defaultValue(for: (AnyView).self)
    }
    
    public func getCurrentScreen() -> AppRoute? {
        return DefaultValueRegistry.defaultValue(for: (AppRoute?).self)
    }
    
    public func getToolbarConfig() -> UIConfig.ToolBar {
        return DefaultValueRegistry.defaultValue(for: (UIConfig.ToolBar).self)
    }
    
    public func userIsLoggedInWithDocuments() -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func userIsLoggedInWithNoDocuments() -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func isScreenForeground(with p0: AppRoute) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func isScreenOnBackStack(with p0: AppRoute) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
}


public class MockPreviewRouter: PreviewRouter, Cuckoo.ClassMock {
    public typealias MocksType = PreviewRouter
    public typealias Stubbing = __StubbingProxy_PreviewRouter
    public typealias Verification = __VerificationProxy_PreviewRouter

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    private var __defaultImplStub: PreviewRouter?

    public func enableDefaultImplementation(_ stub: PreviewRouter) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    
    public override func push(with p0: AppRoute) {
        return cuckoo_manager.call(
            "push(with p0: AppRoute)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: super.push(with: p0),
            defaultCall: __defaultImplStub!.push(with: p0)
        )
    }
    
    public override func popTo(with p0: AppRoute, inclusive p1: Bool, animated p2: Bool) {
        return cuckoo_manager.call(
            "popTo(with p0: AppRoute, inclusive p1: Bool, animated p2: Bool)",
            parameters: (p0, p1, p2),
            escapingParameters: (p0, p1, p2),
            superclassCall: super.popTo(with: p0, inclusive: p1, animated: p2),
            defaultCall: __defaultImplStub!.popTo(with: p0, inclusive: p1, animated: p2)
        )
    }
    
    public override func popTo(with p0: AppRoute, inclusive p1: Bool) {
        return cuckoo_manager.call(
            "popTo(with p0: AppRoute, inclusive p1: Bool)",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: super.popTo(with: p0, inclusive: p1),
            defaultCall: __defaultImplStub!.popTo(with: p0, inclusive: p1)
        )
    }
    
    public override func popTo(with p0: AppRoute) {
        return cuckoo_manager.call(
            "popTo(with p0: AppRoute)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: super.popTo(with: p0),
            defaultCall: __defaultImplStub!.popTo(with: p0)
        )
    }
    
    public override func pop(animated p0: Bool) {
        return cuckoo_manager.call(
            "pop(animated p0: Bool)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: super.pop(animated: p0),
            defaultCall: __defaultImplStub!.pop(animated: p0)
        )
    }
    
    public override func pop() {
        return cuckoo_manager.call(
            "pop()",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.pop(),
            defaultCall: __defaultImplStub!.pop()
        )
    }
    
    public override func composeApplication() -> AnyView {
        return cuckoo_manager.call(
            "composeApplication() -> AnyView",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.composeApplication(),
            defaultCall: __defaultImplStub!.composeApplication()
        )
    }
    
    public override func getCurrentScreen() -> AppRoute? {
        return cuckoo_manager.call(
            "getCurrentScreen() -> AppRoute?",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.getCurrentScreen(),
            defaultCall: __defaultImplStub!.getCurrentScreen()
        )
    }
    
    public override func getToolbarConfig() -> UIConfig.ToolBar {
        return cuckoo_manager.call(
            "getToolbarConfig() -> UIConfig.ToolBar",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.getToolbarConfig(),
            defaultCall: __defaultImplStub!.getToolbarConfig()
        )
    }
    
    public override func userIsLoggedInWithDocuments() -> Bool {
        return cuckoo_manager.call(
            "userIsLoggedInWithDocuments() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.userIsLoggedInWithDocuments(),
            defaultCall: __defaultImplStub!.userIsLoggedInWithDocuments()
        )
    }
    
    public override func userIsLoggedInWithNoDocuments() -> Bool {
        return cuckoo_manager.call(
            "userIsLoggedInWithNoDocuments() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: super.userIsLoggedInWithNoDocuments(),
            defaultCall: __defaultImplStub!.userIsLoggedInWithNoDocuments()
        )
    }
    
    public override func isScreenForeground(with p0: AppRoute) -> Bool {
        return cuckoo_manager.call(
            "isScreenForeground(with p0: AppRoute) -> Bool",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: super.isScreenForeground(with: p0),
            defaultCall: __defaultImplStub!.isScreenForeground(with: p0)
        )
    }
    
    public override func isScreenOnBackStack(with p0: AppRoute) -> Bool {
        return cuckoo_manager.call(
            "isScreenOnBackStack(with p0: AppRoute) -> Bool",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: super.isScreenOnBackStack(with: p0),
            defaultCall: __defaultImplStub!.isScreenOnBackStack(with: p0)
        )
    }

    public struct __StubbingProxy_PreviewRouter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func push<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ClassStubNoReturnFunction<(AppRoute)> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPreviewRouter.self,
                method: "push(with p0: AppRoute)",
                parameterMatchers: matchers
            ))
        }
        
        func popTo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(with p0: M1, inclusive p1: M2, animated p2: M3) -> Cuckoo.ClassStubNoReturnFunction<(AppRoute, Bool, Bool)> where M1.MatchedType == AppRoute, M2.MatchedType == Bool, M3.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute, Bool, Bool)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPreviewRouter.self,
                method: "popTo(with p0: AppRoute, inclusive p1: Bool, animated p2: Bool)",
                parameterMatchers: matchers
            ))
        }
        
        func popTo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(with p0: M1, inclusive p1: M2) -> Cuckoo.ClassStubNoReturnFunction<(AppRoute, Bool)> where M1.MatchedType == AppRoute, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute, Bool)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPreviewRouter.self,
                method: "popTo(with p0: AppRoute, inclusive p1: Bool)",
                parameterMatchers: matchers
            ))
        }
        
        func popTo<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ClassStubNoReturnFunction<(AppRoute)> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPreviewRouter.self,
                method: "popTo(with p0: AppRoute)",
                parameterMatchers: matchers
            ))
        }
        
        func pop<M1: Cuckoo.Matchable>(animated p0: M1) -> Cuckoo.ClassStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPreviewRouter.self,
                method: "pop(animated p0: Bool)",
                parameterMatchers: matchers
            ))
        }
        
        func pop() -> Cuckoo.ClassStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPreviewRouter.self,
                method: "pop()",
                parameterMatchers: matchers
            ))
        }
        
        func composeApplication() -> Cuckoo.ClassStubFunction<(), AnyView> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPreviewRouter.self,
                method: "composeApplication() -> AnyView",
                parameterMatchers: matchers
            ))
        }
        
        func getCurrentScreen() -> Cuckoo.ClassStubFunction<(), AppRoute?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPreviewRouter.self,
                method: "getCurrentScreen() -> AppRoute?",
                parameterMatchers: matchers
            ))
        }
        
        func getToolbarConfig() -> Cuckoo.ClassStubFunction<(), UIConfig.ToolBar> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPreviewRouter.self,
                method: "getToolbarConfig() -> UIConfig.ToolBar",
                parameterMatchers: matchers
            ))
        }
        
        func userIsLoggedInWithDocuments() -> Cuckoo.ClassStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPreviewRouter.self,
                method: "userIsLoggedInWithDocuments() -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func userIsLoggedInWithNoDocuments() -> Cuckoo.ClassStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPreviewRouter.self,
                method: "userIsLoggedInWithNoDocuments() -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func isScreenForeground<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ClassStubFunction<(AppRoute), Bool> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPreviewRouter.self,
                method: "isScreenForeground(with p0: AppRoute) -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func isScreenOnBackStack<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ClassStubFunction<(AppRoute), Bool> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPreviewRouter.self,
                method: "isScreenOnBackStack(with p0: AppRoute) -> Bool",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_PreviewRouter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func push<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(AppRoute), Void> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "push(with p0: AppRoute)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func popTo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(with p0: M1, inclusive p1: M2, animated p2: M3) -> Cuckoo.__DoNotUse<(AppRoute, Bool, Bool), Void> where M1.MatchedType == AppRoute, M2.MatchedType == Bool, M3.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute, Bool, Bool)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return cuckoo_manager.verify(
                "popTo(with p0: AppRoute, inclusive p1: Bool, animated p2: Bool)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func popTo<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(with p0: M1, inclusive p1: M2) -> Cuckoo.__DoNotUse<(AppRoute, Bool), Void> where M1.MatchedType == AppRoute, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute, Bool)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "popTo(with p0: AppRoute, inclusive p1: Bool)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func popTo<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(AppRoute), Void> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "popTo(with p0: AppRoute)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func pop<M1: Cuckoo.Matchable>(animated p0: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "pop(animated p0: Bool)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func pop() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "pop()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func composeApplication() -> Cuckoo.__DoNotUse<(), AnyView> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "composeApplication() -> AnyView",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getCurrentScreen() -> Cuckoo.__DoNotUse<(), AppRoute?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getCurrentScreen() -> AppRoute?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getToolbarConfig() -> Cuckoo.__DoNotUse<(), UIConfig.ToolBar> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getToolbarConfig() -> UIConfig.ToolBar",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func userIsLoggedInWithDocuments() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "userIsLoggedInWithDocuments() -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func userIsLoggedInWithNoDocuments() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "userIsLoggedInWithNoDocuments() -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func isScreenForeground<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(AppRoute), Bool> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "isScreenForeground(with p0: AppRoute) -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func isScreenOnBackStack<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(AppRoute), Bool> where M1.MatchedType == AppRoute {
            let matchers: [Cuckoo.ParameterMatcher<(AppRoute)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "isScreenOnBackStack(with p0: AppRoute) -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class PreviewRouterStub:PreviewRouter {


    
    public override func push(with p0: AppRoute) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func popTo(with p0: AppRoute, inclusive p1: Bool, animated p2: Bool) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func popTo(with p0: AppRoute, inclusive p1: Bool) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func popTo(with p0: AppRoute) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func pop(animated p0: Bool) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func pop() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public override func composeApplication() -> AnyView {
        return DefaultValueRegistry.defaultValue(for: (AnyView).self)
    }
    
    public override func getCurrentScreen() -> AppRoute? {
        return DefaultValueRegistry.defaultValue(for: (AppRoute?).self)
    }
    
    public override func getToolbarConfig() -> UIConfig.ToolBar {
        return DefaultValueRegistry.defaultValue(for: (UIConfig.ToolBar).self)
    }
    
    public override func userIsLoggedInWithDocuments() -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public override func userIsLoggedInWithNoDocuments() -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public override func isScreenForeground(with p0: AppRoute) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public override func isScreenOnBackStack(with p0: AppRoute) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
}


