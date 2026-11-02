// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/Config/BiometricUiConfig.swift'

import Cuckoo
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/Config/Issuance/IssuanceCodeUiConfig.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/Config/Issuance/IssuanceFlowUiConfig.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/Config/Presentation/DocumentSuccessUIConfig.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/Config/QuickPinUiConfig.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/Config/ScannerUiConfig.swift'

import Cuckoo
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/Config/SuccessUiConfig.swift'

import Cuckoo
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/Config/TrustMarkUiConfig.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/Extension/DocClaimsDecodable+Extensions.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/Interactor/BiometryInteractor.swift'

import Cuckoo
import LocalAuthentication
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockBiometryInteractor: BiometryInteractor, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any BiometryInteractor
    public typealias Stubbing = __StubbingProxy_BiometryInteractor
    public typealias Verification = __VerificationProxy_BiometryInteractor

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any BiometryInteractor)?

    public func enableDefaultImplementation(_ stub: any BiometryInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public var maxFailedPinAttempts: Int {
        get {
            return cuckoo_manager.getter(
                "maxFailedPinAttempts",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.maxFailedPinAttempts
            )
        }
    }


    public func authenticate() async -> BiometricsState {
        return await cuckoo_manager.call(
            "authenticate() async -> BiometricsState",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.authenticate()
        )
    }

    public func openSettings(action p0: @escaping @Sendable () -> Void) async {
        return await cuckoo_manager.call(
            "openSettings(action p0: @escaping @Sendable () -> Void) async",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.openSettings(action: p0)
        )
    }

    public func getBiometricsImage() async -> Image? {
        return await cuckoo_manager.call(
            "getBiometricsImage() async -> Image?",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getBiometricsImage()
        )
    }

    public func getBiometricsMethod() async -> String {
        return await cuckoo_manager.call(
            "getBiometricsMethod() async -> String",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getBiometricsMethod()
        )
    }

    public func getBiometryType() async -> LABiometryType {
        return await cuckoo_manager.call(
            "getBiometryType() async -> LABiometryType",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getBiometryType()
        )
    }

    public func isBiometryEnabled() async -> Bool {
        return await cuckoo_manager.call(
            "isBiometryEnabled() async -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.isBiometryEnabled()
        )
    }

    public func setBiometrySelection(isEnabled p0: Bool) async -> BiometricsState {
        return await cuckoo_manager.call(
            "setBiometrySelection(isEnabled p0: Bool) async -> BiometricsState",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.setBiometrySelection(isEnabled: p0)
        )
    }

    public func isPinValid(with p0: String) async -> QuickPinPartialState {
        return await cuckoo_manager.call(
            "isPinValid(with p0: String) async -> QuickPinPartialState",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.isPinValid(with: p0)
        )
    }

    public func getPinLockoutState() async -> PinLockoutState {
        return await cuckoo_manager.call(
            "getPinLockoutState() async -> PinLockoutState",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getPinLockoutState()
        )
    }

    public func recordPinFailure() async -> PinLockoutState {
        return await cuckoo_manager.call(
            "recordPinFailure() async -> PinLockoutState",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.recordPinFailure()
        )
    }

    public func resetPinThrottle() async {
        return await cuckoo_manager.call(
            "resetPinThrottle() async",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.resetPinThrottle()
        )
    }

    public func unlockSession() async {
        return await cuckoo_manager.call(
            "unlockSession() async",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.unlockSession()
        )
    }

    public func getDeviceLockState() async -> DeviceLockState {
        return await cuckoo_manager.call(
            "getDeviceLockState() async -> DeviceLockState",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getDeviceLockState()
        )
    }

    public struct __StubbingProxy_BiometryInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var maxFailedPinAttempts: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockBiometryInteractor,Int> {
            return .init(manager: cuckoo_manager, name: "maxFailedPinAttempts")
        }
        
        func authenticate() -> Cuckoo.ProtocolStubFunction<(), BiometricsState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBiometryInteractor.self,
                method: "authenticate() async -> BiometricsState",
                parameterMatchers: matchers
            ))
        }
        
        func openSettings<M1: Cuckoo.Matchable>(action p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(@Sendable () -> Void)> where M1.MatchedType == @Sendable () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(@Sendable () -> Void)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockBiometryInteractor.self,
                method: "openSettings(action p0: @escaping @Sendable () -> Void) async",
                parameterMatchers: matchers
            ))
        }
        
        func getBiometricsImage() -> Cuckoo.ProtocolStubFunction<(), Image?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBiometryInteractor.self,
                method: "getBiometricsImage() async -> Image?",
                parameterMatchers: matchers
            ))
        }
        
        func getBiometricsMethod() -> Cuckoo.ProtocolStubFunction<(), String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBiometryInteractor.self,
                method: "getBiometricsMethod() async -> String",
                parameterMatchers: matchers
            ))
        }
        
        func getBiometryType() -> Cuckoo.ProtocolStubFunction<(), LABiometryType> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBiometryInteractor.self,
                method: "getBiometryType() async -> LABiometryType",
                parameterMatchers: matchers
            ))
        }
        
        func isBiometryEnabled() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBiometryInteractor.self,
                method: "isBiometryEnabled() async -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func setBiometrySelection<M1: Cuckoo.Matchable>(isEnabled p0: M1) -> Cuckoo.ProtocolStubFunction<(Bool), BiometricsState> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockBiometryInteractor.self,
                method: "setBiometrySelection(isEnabled p0: Bool) async -> BiometricsState",
                parameterMatchers: matchers
            ))
        }
        
        func isPinValid<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubFunction<(String), QuickPinPartialState> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockBiometryInteractor.self,
                method: "isPinValid(with p0: String) async -> QuickPinPartialState",
                parameterMatchers: matchers
            ))
        }
        
        func getPinLockoutState() -> Cuckoo.ProtocolStubFunction<(), PinLockoutState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBiometryInteractor.self,
                method: "getPinLockoutState() async -> PinLockoutState",
                parameterMatchers: matchers
            ))
        }
        
        func recordPinFailure() -> Cuckoo.ProtocolStubFunction<(), PinLockoutState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBiometryInteractor.self,
                method: "recordPinFailure() async -> PinLockoutState",
                parameterMatchers: matchers
            ))
        }
        
        func resetPinThrottle() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBiometryInteractor.self,
                method: "resetPinThrottle() async",
                parameterMatchers: matchers
            ))
        }
        
        func unlockSession() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBiometryInteractor.self,
                method: "unlockSession() async",
                parameterMatchers: matchers
            ))
        }
        
        func getDeviceLockState() -> Cuckoo.ProtocolStubFunction<(), DeviceLockState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockBiometryInteractor.self,
                method: "getDeviceLockState() async -> DeviceLockState",
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
        
        var maxFailedPinAttempts: Cuckoo.VerifyReadOnlyProperty<Int> {
            return .init(manager: cuckoo_manager, name: "maxFailedPinAttempts", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        @discardableResult
        func authenticate() -> Cuckoo.__DoNotUse<(), BiometricsState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "authenticate() async -> BiometricsState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func openSettings<M1: Cuckoo.Matchable>(action p0: M1) -> Cuckoo.__DoNotUse<(@Sendable () -> Void), Void> where M1.MatchedType == @Sendable () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(@Sendable () -> Void)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "openSettings(action p0: @escaping @Sendable () -> Void) async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getBiometricsImage() -> Cuckoo.__DoNotUse<(), Image?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getBiometricsImage() async -> Image?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getBiometricsMethod() -> Cuckoo.__DoNotUse<(), String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getBiometricsMethod() async -> String",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getBiometryType() -> Cuckoo.__DoNotUse<(), LABiometryType> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getBiometryType() async -> LABiometryType",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func isBiometryEnabled() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "isBiometryEnabled() async -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setBiometrySelection<M1: Cuckoo.Matchable>(isEnabled p0: M1) -> Cuckoo.__DoNotUse<(Bool), BiometricsState> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setBiometrySelection(isEnabled p0: Bool) async -> BiometricsState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func isPinValid<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(String), QuickPinPartialState> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "isPinValid(with p0: String) async -> QuickPinPartialState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getPinLockoutState() -> Cuckoo.__DoNotUse<(), PinLockoutState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getPinLockoutState() async -> PinLockoutState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func recordPinFailure() -> Cuckoo.__DoNotUse<(), PinLockoutState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "recordPinFailure() async -> PinLockoutState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func resetPinThrottle() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "resetPinThrottle() async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func unlockSession() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "unlockSession() async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getDeviceLockState() -> Cuckoo.__DoNotUse<(), DeviceLockState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getDeviceLockState() async -> DeviceLockState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class BiometryInteractorStub:BiometryInteractor, @unchecked Sendable {
    
    public var maxFailedPinAttempts: Int {
        get {
            return DefaultValueRegistry.defaultValue(for: (Int).self)
        }
    }


    
    public func authenticate() async -> BiometricsState {
        return DefaultValueRegistry.defaultValue(for: (BiometricsState).self)
    }
    
    public func openSettings(action p0: @escaping @Sendable () -> Void) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getBiometricsImage() async -> Image? {
        return DefaultValueRegistry.defaultValue(for: (Image?).self)
    }
    
    public func getBiometricsMethod() async -> String {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
    
    public func getBiometryType() async -> LABiometryType {
        return DefaultValueRegistry.defaultValue(for: (LABiometryType).self)
    }
    
    public func isBiometryEnabled() async -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func setBiometrySelection(isEnabled p0: Bool) async -> BiometricsState {
        return DefaultValueRegistry.defaultValue(for: (BiometricsState).self)
    }
    
    public func isPinValid(with p0: String) async -> QuickPinPartialState {
        return DefaultValueRegistry.defaultValue(for: (QuickPinPartialState).self)
    }
    
    public func getPinLockoutState() async -> PinLockoutState {
        return DefaultValueRegistry.defaultValue(for: (PinLockoutState).self)
    }
    
    public func recordPinFailure() async -> PinLockoutState {
        return DefaultValueRegistry.defaultValue(for: (PinLockoutState).self)
    }
    
    public func resetPinThrottle() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func unlockSession() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getDeviceLockState() async -> DeviceLockState {
        return DefaultValueRegistry.defaultValue(for: (DeviceLockState).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/Interactor/QuickPinInteractor.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockQuickPinInteractor: QuickPinInteractor, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any QuickPinInteractor
    public typealias Stubbing = __StubbingProxy_QuickPinInteractor
    public typealias Verification = __VerificationProxy_QuickPinInteractor

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any QuickPinInteractor)?

    public func enableDefaultImplementation(_ stub: any QuickPinInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public var maxFailedPinAttempts: Int {
        get {
            return cuckoo_manager.getter(
                "maxFailedPinAttempts",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.maxFailedPinAttempts
            )
        }
    }


    public func setPin(newPin p0: String) async -> QuickPinPartialState {
        return await cuckoo_manager.call(
            "setPin(newPin p0: String) async -> QuickPinPartialState",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.setPin(newPin: p0)
        )
    }

    public func updatePin(newPin p0: String) async -> QuickPinPartialState {
        return await cuckoo_manager.call(
            "updatePin(newPin p0: String) async -> QuickPinPartialState",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.updatePin(newPin: p0)
        )
    }

    public func checkNewPin(_ p0: String) async -> QuickPinPartialState {
        return await cuckoo_manager.call(
            "checkNewPin(_ p0: String) async -> QuickPinPartialState",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.checkNewPin(p0)
        )
    }

    public func getDeviceLockState() async -> DeviceLockState {
        return await cuckoo_manager.call(
            "getDeviceLockState() async -> DeviceLockState",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getDeviceLockState()
        )
    }

    public func isPinValid(pin p0: String) async -> QuickPinPartialState {
        return await cuckoo_manager.call(
            "isPinValid(pin p0: String) async -> QuickPinPartialState",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.isPinValid(pin: p0)
        )
    }

    public func changePin(currentPin p0: String, newPin p1: String) async -> QuickPinPartialState {
        return await cuckoo_manager.call(
            "changePin(currentPin p0: String, newPin p1: String) async -> QuickPinPartialState",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.changePin(currentPin: p0, newPin: p1)
        )
    }

    public func hasPin() async throws -> Bool {
        return try await cuckoo_manager.callThrows(
            "hasPin() async throws -> Bool",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.hasPin()
        )
    }

    public func getPinLockoutState() async -> PinLockoutState {
        return await cuckoo_manager.call(
            "getPinLockoutState() async -> PinLockoutState",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getPinLockoutState()
        )
    }

    public func recordPinFailure() async -> PinLockoutState {
        return await cuckoo_manager.call(
            "recordPinFailure() async -> PinLockoutState",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.recordPinFailure()
        )
    }

    public func resetPinThrottle() async {
        return await cuckoo_manager.call(
            "resetPinThrottle() async",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.resetPinThrottle()
        )
    }

    public func unlockSession() async {
        return await cuckoo_manager.call(
            "unlockSession() async",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.unlockSession()
        )
    }

    public struct __StubbingProxy_QuickPinInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var maxFailedPinAttempts: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockQuickPinInteractor,Int> {
            return .init(manager: cuckoo_manager, name: "maxFailedPinAttempts")
        }
        
        func setPin<M1: Cuckoo.Matchable>(newPin p0: M1) -> Cuckoo.ProtocolStubFunction<(String), QuickPinPartialState> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockQuickPinInteractor.self,
                method: "setPin(newPin p0: String) async -> QuickPinPartialState",
                parameterMatchers: matchers
            ))
        }
        
        func updatePin<M1: Cuckoo.Matchable>(newPin p0: M1) -> Cuckoo.ProtocolStubFunction<(String), QuickPinPartialState> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockQuickPinInteractor.self,
                method: "updatePin(newPin p0: String) async -> QuickPinPartialState",
                parameterMatchers: matchers
            ))
        }
        
        func checkNewPin<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.ProtocolStubFunction<(String), QuickPinPartialState> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockQuickPinInteractor.self,
                method: "checkNewPin(_ p0: String) async -> QuickPinPartialState",
                parameterMatchers: matchers
            ))
        }
        
        func getDeviceLockState() -> Cuckoo.ProtocolStubFunction<(), DeviceLockState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockQuickPinInteractor.self,
                method: "getDeviceLockState() async -> DeviceLockState",
                parameterMatchers: matchers
            ))
        }
        
        func isPinValid<M1: Cuckoo.Matchable>(pin p0: M1) -> Cuckoo.ProtocolStubFunction<(String), QuickPinPartialState> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockQuickPinInteractor.self,
                method: "isPinValid(pin p0: String) async -> QuickPinPartialState",
                parameterMatchers: matchers
            ))
        }
        
        func changePin<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(currentPin p0: M1, newPin p1: M2) -> Cuckoo.ProtocolStubFunction<(String, String), QuickPinPartialState> where M1.MatchedType == String, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockQuickPinInteractor.self,
                method: "changePin(currentPin p0: String, newPin p1: String) async -> QuickPinPartialState",
                parameterMatchers: matchers
            ))
        }
        
        func hasPin() -> Cuckoo.ProtocolStubThrowingFunction<(), Bool,Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockQuickPinInteractor.self,
                method: "hasPin() async throws -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func getPinLockoutState() -> Cuckoo.ProtocolStubFunction<(), PinLockoutState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockQuickPinInteractor.self,
                method: "getPinLockoutState() async -> PinLockoutState",
                parameterMatchers: matchers
            ))
        }
        
        func recordPinFailure() -> Cuckoo.ProtocolStubFunction<(), PinLockoutState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockQuickPinInteractor.self,
                method: "recordPinFailure() async -> PinLockoutState",
                parameterMatchers: matchers
            ))
        }
        
        func resetPinThrottle() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockQuickPinInteractor.self,
                method: "resetPinThrottle() async",
                parameterMatchers: matchers
            ))
        }
        
        func unlockSession() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockQuickPinInteractor.self,
                method: "unlockSession() async",
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
        
        var maxFailedPinAttempts: Cuckoo.VerifyReadOnlyProperty<Int> {
            return .init(manager: cuckoo_manager, name: "maxFailedPinAttempts", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        @discardableResult
        func setPin<M1: Cuckoo.Matchable>(newPin p0: M1) -> Cuckoo.__DoNotUse<(String), QuickPinPartialState> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setPin(newPin p0: String) async -> QuickPinPartialState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func updatePin<M1: Cuckoo.Matchable>(newPin p0: M1) -> Cuckoo.__DoNotUse<(String), QuickPinPartialState> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "updatePin(newPin p0: String) async -> QuickPinPartialState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func checkNewPin<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.__DoNotUse<(String), QuickPinPartialState> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "checkNewPin(_ p0: String) async -> QuickPinPartialState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getDeviceLockState() -> Cuckoo.__DoNotUse<(), DeviceLockState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getDeviceLockState() async -> DeviceLockState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func isPinValid<M1: Cuckoo.Matchable>(pin p0: M1) -> Cuckoo.__DoNotUse<(String), QuickPinPartialState> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "isPinValid(pin p0: String) async -> QuickPinPartialState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func changePin<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(currentPin p0: M1, newPin p1: M2) -> Cuckoo.__DoNotUse<(String, String), QuickPinPartialState> where M1.MatchedType == String, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "changePin(currentPin p0: String, newPin p1: String) async -> QuickPinPartialState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func hasPin() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "hasPin() async throws -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getPinLockoutState() -> Cuckoo.__DoNotUse<(), PinLockoutState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getPinLockoutState() async -> PinLockoutState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func recordPinFailure() -> Cuckoo.__DoNotUse<(), PinLockoutState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "recordPinFailure() async -> PinLockoutState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func resetPinThrottle() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "resetPinThrottle() async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func unlockSession() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "unlockSession() async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class QuickPinInteractorStub:QuickPinInteractor, @unchecked Sendable {
    
    public var maxFailedPinAttempts: Int {
        get {
            return DefaultValueRegistry.defaultValue(for: (Int).self)
        }
    }


    
    public func setPin(newPin p0: String) async -> QuickPinPartialState {
        return DefaultValueRegistry.defaultValue(for: (QuickPinPartialState).self)
    }
    
    public func updatePin(newPin p0: String) async -> QuickPinPartialState {
        return DefaultValueRegistry.defaultValue(for: (QuickPinPartialState).self)
    }
    
    public func checkNewPin(_ p0: String) async -> QuickPinPartialState {
        return DefaultValueRegistry.defaultValue(for: (QuickPinPartialState).self)
    }
    
    public func getDeviceLockState() async -> DeviceLockState {
        return DefaultValueRegistry.defaultValue(for: (DeviceLockState).self)
    }
    
    public func isPinValid(pin p0: String) async -> QuickPinPartialState {
        return DefaultValueRegistry.defaultValue(for: (QuickPinPartialState).self)
    }
    
    public func changePin(currentPin p0: String, newPin p1: String) async -> QuickPinPartialState {
        return DefaultValueRegistry.defaultValue(for: (QuickPinPartialState).self)
    }
    
    public func hasPin() async throws -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func getPinLockoutState() async -> PinLockoutState {
        return DefaultValueRegistry.defaultValue(for: (PinLockoutState).self)
    }
    
    public func recordPinFailure() async -> PinLockoutState {
        return DefaultValueRegistry.defaultValue(for: (PinLockoutState).self)
    }
    
    public func resetPinThrottle() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func unlockSession() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/Interactor/ScannerInteractor.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockScannerInteractor: ScannerInteractor, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any ScannerInteractor
    public typealias Stubbing = __StubbingProxy_ScannerInteractor
    public typealias Verification = __VerificationProxy_ScannerInteractor

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any ScannerInteractor)?

    public func enableDefaultImplementation(_ stub: any ScannerInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func startCrossDevicePresentation(scanResult p0: String) async -> RemoteSessionCoordinator {
        return await cuckoo_manager.call(
            "startCrossDevicePresentation(scanResult p0: String) async -> RemoteSessionCoordinator",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.startCrossDevicePresentation(scanResult: p0)
        )
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

    public struct __StubbingProxy_ScannerInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func startCrossDevicePresentation<M1: Cuckoo.Matchable>(scanResult p0: M1) -> Cuckoo.ProtocolStubFunction<(String), RemoteSessionCoordinator> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockScannerInteractor.self,
                method: "startCrossDevicePresentation(scanResult p0: String) async -> RemoteSessionCoordinator",
                parameterMatchers: matchers
            ))
        }
        
        func validateForm<M1: Cuckoo.Matchable>(form p0: M1) -> Cuckoo.ProtocolStubFunction<(ValidatableForm), FormValidationResult> where M1.MatchedType == ValidatableForm {
            let matchers: [Cuckoo.ParameterMatcher<(ValidatableForm)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockScannerInteractor.self,
                method: "validateForm(form p0: ValidatableForm) async -> FormValidationResult",
                parameterMatchers: matchers
            ))
        }
        
        func validateForms<M1: Cuckoo.Matchable>(forms p0: M1) -> Cuckoo.ProtocolStubFunction<([ValidatableForm]), FormsValidationResult> where M1.MatchedType == [ValidatableForm] {
            let matchers: [Cuckoo.ParameterMatcher<([ValidatableForm])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockScannerInteractor.self,
                method: "validateForms(forms p0: [ValidatableForm]) async -> FormsValidationResult",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_ScannerInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func startCrossDevicePresentation<M1: Cuckoo.Matchable>(scanResult p0: M1) -> Cuckoo.__DoNotUse<(String), RemoteSessionCoordinator> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "startCrossDevicePresentation(scanResult p0: String) async -> RemoteSessionCoordinator",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
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

public class ScannerInteractorStub:ScannerInteractor, @unchecked Sendable {


    
    public func startCrossDevicePresentation(scanResult p0: String) async -> RemoteSessionCoordinator {
        return DefaultValueRegistry.defaultValue(for: (RemoteSessionCoordinator).self)
    }
    
    public func validateForm(form p0: ValidatableForm) async -> FormValidationResult {
        return DefaultValueRegistry.defaultValue(for: (FormValidationResult).self)
    }
    
    public func validateForms(forms p0: [ValidatableForm]) async -> FormsValidationResult {
        return DefaultValueRegistry.defaultValue(for: (FormsValidationResult).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/Interactor/TrustMarkInteractor.swift'

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
@testable import feature_presentation

public class MockTrustMarkInteractor: TrustMarkInteractor, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any TrustMarkInteractor
    public typealias Stubbing = __StubbingProxy_TrustMarkInteractor
    public typealias Verification = __VerificationProxy_TrustMarkInteractor

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any TrustMarkInteractor)?

    public func enableDefaultImplementation(_ stub: any TrustMarkInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func getTrustMark() async -> LoadTrustMarkPartialState {
        return await cuckoo_manager.call(
            "getTrustMark() async -> LoadTrustMarkPartialState",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getTrustMark()
        )
    }

    public func completeIntroduction() async {
        return await cuckoo_manager.call(
            "completeIntroduction() async",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.completeIntroduction()
        )
    }

    public struct __StubbingProxy_TrustMarkInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func getTrustMark() -> Cuckoo.ProtocolStubFunction<(), LoadTrustMarkPartialState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockTrustMarkInteractor.self,
                method: "getTrustMark() async -> LoadTrustMarkPartialState",
                parameterMatchers: matchers
            ))
        }
        
        func completeIntroduction() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockTrustMarkInteractor.self,
                method: "completeIntroduction() async",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_TrustMarkInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func getTrustMark() -> Cuckoo.__DoNotUse<(), LoadTrustMarkPartialState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getTrustMark() async -> LoadTrustMarkPartialState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func completeIntroduction() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "completeIntroduction() async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class TrustMarkInteractorStub:TrustMarkInteractor, @unchecked Sendable {


    
    public func getTrustMark() async -> LoadTrustMarkPartialState {
        return DefaultValueRegistry.defaultValue(for: (LoadTrustMarkPartialState).self)
    }
    
    public func completeIntroduction() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/Accessibility/BaseRequestLocators.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/Accessibility/BiometryLocators.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/Accessibility/DocumentSuccessLocators.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/Accessibility/GenericSuccessLocators.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/Accessibility/QuickPinLocators.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/Biometry/BiometryView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/Biometry/BiometryViewModel.swift'

import Cuckoo
import logic_resources
import Observation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/Document/Model/DocumentUIModel.swift'

import Cuckoo
import Copyable
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/Loading/BaseLoadingView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/Loading/BaseLoadingViewModel.swift'

import Cuckoo
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/QuickPin/QuickPinView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/QuickPin/QuickPinViewModel.swift'

import Cuckoo
import logic_resources
import Observation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/Request/BaseRequestView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/Request/BaseRequestViewModel.swift'

import Cuckoo
import logic_resources
import Observation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/Request/Model/RelyingPartyRegistrationUiModel.swift'

import Cuckoo
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/Request/Model/RequestDataUIModel.swift'

import Cuckoo
import SwiftUI
import Copyable
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/Request/Model/RequestTransactionDataUiModel.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/Scanner/ScannerView.swift'

import Cuckoo
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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/Scanner/ScannerViewModel.swift'

import Cuckoo
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/Success/Document/DocumentSuccessView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/Success/Document/DocumentSuccessViewModel.swift'

import Cuckoo
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/Success/Generic/GenericSuccessView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/Success/Generic/GenericSuccessViewModel.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/TrustMark/Model/TrustMarkUIModel.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/TrustMark/TrustMarkView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-common/Sources/UI/TrustMark/TrustMarkViewModel.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-presentation/Sources/Interactor/PresentationInteractor.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockPresentationInteractor: PresentationInteractor, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any PresentationInteractor
    public typealias Stubbing = __StubbingProxy_PresentationInteractor
    public typealias Verification = __VerificationProxy_PresentationInteractor

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any PresentationInteractor)?

    public func enableDefaultImplementation(_ stub: any PresentationInteractor) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func getSessionStatePublisher() async -> RemotePublisherPartialState {
        return await cuckoo_manager.call(
            "getSessionStatePublisher() async -> RemotePublisherPartialState",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getSessionStatePublisher()
        )
    }

    public func getCoordinator() async -> PresentationCoordinatorPartialState {
        return await cuckoo_manager.call(
            "getCoordinator() async -> PresentationCoordinatorPartialState",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getCoordinator()
        )
    }

    public func onDeviceEngagement() async -> PresentationRequestPartialState {
        return await cuckoo_manager.call(
            "onDeviceEngagement() async -> PresentationRequestPartialState",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.onDeviceEngagement()
        )
    }

    public func onResponsePrepare(combinationIndex p0: Int) async -> Result<RequestItemConvertible, Error> {
        return await cuckoo_manager.call(
            "onResponsePrepare(combinationIndex p0: Int) async -> Result<RequestItemConvertible, Error>",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.onResponsePrepare(combinationIndex: p0)
        )
    }

    public func onRequestReceived() async -> PresentationRequestPartialState {
        return await cuckoo_manager.call(
            "onRequestReceived() async -> PresentationRequestPartialState",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.onRequestReceived()
        )
    }

    public func onSendResponse() async -> RemoteSentResponsePartialState {
        return await cuckoo_manager.call(
            "onSendResponse() async -> RemoteSentResponsePartialState",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.onSendResponse()
        )
    }

    public func onDeclineRequest() async {
        return await cuckoo_manager.call(
            "onDeclineRequest() async",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.onDeclineRequest()
        )
    }

    public func storeDynamicIssuancePendingUrl(with p0: URL) async {
        return await cuckoo_manager.call(
            "storeDynamicIssuancePendingUrl(with p0: URL) async",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.storeDynamicIssuancePendingUrl(with: p0)
        )
    }

    public func stopPresentation() async {
        return await cuckoo_manager.call(
            "stopPresentation() async",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.stopPresentation()
        )
    }

    public func registrationForFailedRequest() async -> RelyingPartyRegistration? {
        return await cuckoo_manager.call(
            "registrationForFailedRequest() async -> RelyingPartyRegistration?",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.registrationForFailedRequest()
        )
    }

    public struct __StubbingProxy_PresentationInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func getSessionStatePublisher() -> Cuckoo.ProtocolStubFunction<(), RemotePublisherPartialState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationInteractor.self,
                method: "getSessionStatePublisher() async -> RemotePublisherPartialState",
                parameterMatchers: matchers
            ))
        }
        
        func getCoordinator() -> Cuckoo.ProtocolStubFunction<(), PresentationCoordinatorPartialState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationInteractor.self,
                method: "getCoordinator() async -> PresentationCoordinatorPartialState",
                parameterMatchers: matchers
            ))
        }
        
        func onDeviceEngagement() -> Cuckoo.ProtocolStubFunction<(), PresentationRequestPartialState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationInteractor.self,
                method: "onDeviceEngagement() async -> PresentationRequestPartialState",
                parameterMatchers: matchers
            ))
        }
        
        func onResponsePrepare<M1: Cuckoo.Matchable>(combinationIndex p0: M1) -> Cuckoo.ProtocolStubFunction<(Int), Result<RequestItemConvertible, Error>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationInteractor.self,
                method: "onResponsePrepare(combinationIndex p0: Int) async -> Result<RequestItemConvertible, Error>",
                parameterMatchers: matchers
            ))
        }
        
        func onRequestReceived() -> Cuckoo.ProtocolStubFunction<(), PresentationRequestPartialState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationInteractor.self,
                method: "onRequestReceived() async -> PresentationRequestPartialState",
                parameterMatchers: matchers
            ))
        }
        
        func onSendResponse() -> Cuckoo.ProtocolStubFunction<(), RemoteSentResponsePartialState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationInteractor.self,
                method: "onSendResponse() async -> RemoteSentResponsePartialState",
                parameterMatchers: matchers
            ))
        }
        
        func onDeclineRequest() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationInteractor.self,
                method: "onDeclineRequest() async",
                parameterMatchers: matchers
            ))
        }
        
        func storeDynamicIssuancePendingUrl<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(URL)> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationInteractor.self,
                method: "storeDynamicIssuancePendingUrl(with p0: URL) async",
                parameterMatchers: matchers
            ))
        }
        
        func stopPresentation() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationInteractor.self,
                method: "stopPresentation() async",
                parameterMatchers: matchers
            ))
        }
        
        func registrationForFailedRequest() -> Cuckoo.ProtocolStubFunction<(), RelyingPartyRegistration?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPresentationInteractor.self,
                method: "registrationForFailedRequest() async -> RelyingPartyRegistration?",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_PresentationInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func getSessionStatePublisher() -> Cuckoo.__DoNotUse<(), RemotePublisherPartialState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getSessionStatePublisher() async -> RemotePublisherPartialState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getCoordinator() -> Cuckoo.__DoNotUse<(), PresentationCoordinatorPartialState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getCoordinator() async -> PresentationCoordinatorPartialState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func onDeviceEngagement() -> Cuckoo.__DoNotUse<(), PresentationRequestPartialState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "onDeviceEngagement() async -> PresentationRequestPartialState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func onResponsePrepare<M1: Cuckoo.Matchable>(combinationIndex p0: M1) -> Cuckoo.__DoNotUse<(Int), Result<RequestItemConvertible, Error>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "onResponsePrepare(combinationIndex p0: Int) async -> Result<RequestItemConvertible, Error>",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func onRequestReceived() -> Cuckoo.__DoNotUse<(), PresentationRequestPartialState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "onRequestReceived() async -> PresentationRequestPartialState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func onSendResponse() -> Cuckoo.__DoNotUse<(), RemoteSentResponsePartialState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "onSendResponse() async -> RemoteSentResponsePartialState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func onDeclineRequest() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "onDeclineRequest() async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func storeDynamicIssuancePendingUrl<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(URL), Void> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "storeDynamicIssuancePendingUrl(with p0: URL) async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stopPresentation() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stopPresentation() async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func registrationForFailedRequest() -> Cuckoo.__DoNotUse<(), RelyingPartyRegistration?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "registrationForFailedRequest() async -> RelyingPartyRegistration?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class PresentationInteractorStub:PresentationInteractor, @unchecked Sendable {


    
    public func getSessionStatePublisher() async -> RemotePublisherPartialState {
        return DefaultValueRegistry.defaultValue(for: (RemotePublisherPartialState).self)
    }
    
    public func getCoordinator() async -> PresentationCoordinatorPartialState {
        return DefaultValueRegistry.defaultValue(for: (PresentationCoordinatorPartialState).self)
    }
    
    public func onDeviceEngagement() async -> PresentationRequestPartialState {
        return DefaultValueRegistry.defaultValue(for: (PresentationRequestPartialState).self)
    }
    
    public func onResponsePrepare(combinationIndex p0: Int) async -> Result<RequestItemConvertible, Error> {
        return DefaultValueRegistry.defaultValue(for: (Result<RequestItemConvertible, Error>).self)
    }
    
    public func onRequestReceived() async -> PresentationRequestPartialState {
        return DefaultValueRegistry.defaultValue(for: (PresentationRequestPartialState).self)
    }
    
    public func onSendResponse() async -> RemoteSentResponsePartialState {
        return DefaultValueRegistry.defaultValue(for: (RemoteSentResponsePartialState).self)
    }
    
    public func onDeclineRequest() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func storeDynamicIssuancePendingUrl(with p0: URL) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func stopPresentation() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func registrationForFailedRequest() async -> RelyingPartyRegistration? {
        return DefaultValueRegistry.defaultValue(for: (RelyingPartyRegistration?).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/feature-presentation/Sources/UI/Presentation/Loading/PresentationLoadingView.swift'

import Cuckoo
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-presentation/Sources/UI/Presentation/Request/PresentationRequestView.swift'

import Cuckoo
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/feature-presentation/Sources/UI/Presentation/Success/PresentationSuccessView.swift'

import Cuckoo
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-analytics/Sources/Config/AnalyticsConfig.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

class MockAnalyticsConfig: AnalyticsConfig, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = any AnalyticsConfig
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

class AnalyticsConfigStub:AnalyticsConfig, @unchecked Sendable {
    
    var analyticsProviders: [String: AnalyticsProvider] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String: AnalyticsProvider]).self)
        }
    }


}




// MARK: - Mocks generated from file: '../Modules/logic-analytics/Sources/Controller/AnalyticsController.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockAnalyticsController: AnalyticsController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any AnalyticsController
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

public class AnalyticsControllerStub:AnalyticsController, @unchecked Sendable {


    
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




// MARK: - Mocks generated from file: '../Modules/logic-analytics/Sources/Provider/AnalyticsProvider.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

class MockAnalyticsProvider: AnalyticsProvider, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = any AnalyticsProvider
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

class AnalyticsProviderStub:AnalyticsProvider, @unchecked Sendable {


    
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




// MARK: - Mocks generated from file: '../Modules/logic-api/Sources/Api/WalletAttestationApi.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-api/Sources/Core/NetworkManager.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

class MockNetworkManager: NetworkManager, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = any NetworkManager
    typealias Stubbing = __StubbingProxy_NetworkManager
    typealias Verification = __VerificationProxy_NetworkManager

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any NetworkManager)?

    func enableDefaultImplementation(_ stub: any NetworkManager) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    func execute<R: NetworkRequest, T: Decodable & Sendable> (with p0: R, parameters p1: [NetworkParameter]?) async throws -> T {
        return try await cuckoo_manager.callThrows(
            "execute<R: NetworkRequest, T: Decodable & Sendable> (with p0: R, parameters p1: [NetworkParameter]?) async throws -> T",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            errorType: Swift.Error.self,
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
        
        func execute<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, R: NetworkRequest, T: Decodable & Sendable>(with p0: M1, parameters p1: M2) -> Cuckoo.ProtocolStubThrowingFunction<(R, [NetworkParameter]?), T,Swift.Error> where M1.MatchedType == R, M2.OptionalMatchedType == [NetworkParameter] {
            let matchers: [Cuckoo.ParameterMatcher<(R, [NetworkParameter]?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockNetworkManager.self,
                method: "execute<R: NetworkRequest, T: Decodable & Sendable> (with p0: R, parameters p1: [NetworkParameter]?) async throws -> T",
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
        func execute<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, R: NetworkRequest, T: Decodable & Sendable>(with p0: M1, parameters p1: M2) -> Cuckoo.__DoNotUse<(R, [NetworkParameter]?), T> where M1.MatchedType == R, M2.OptionalMatchedType == [NetworkParameter] {
            let matchers: [Cuckoo.ParameterMatcher<(R, [NetworkParameter]?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "execute<R: NetworkRequest, T: Decodable & Sendable> (with p0: R, parameters p1: [NetworkParameter]?) async throws -> T",
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

class NetworkManagerStub:NetworkManager, @unchecked Sendable {


    
    func execute<R: NetworkRequest, T: Decodable & Sendable> (with p0: R, parameters p1: [NetworkParameter]?) async throws -> T {
        return DefaultValueRegistry.defaultValue(for: (T).self)
    }
    
    func prepare<R: NetworkRequest> (request p0: R, parameters p1: [NetworkParameter]?, baseHost p2: String) async -> URLRequest {
        return DefaultValueRegistry.defaultValue(for: (URLRequest).self)
    }
    
    func log(request p0: URLRequest, responseData p1: Data?) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-api/Sources/Core/NetworkParameter.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-api/Sources/Core/NetworkRequest.swift'

import Cuckoo
import struct Foundation.Data
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

class MockNetworkRequest<Response>: NetworkRequest, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = DefaultImplCaller
    typealias Stubbing = __StubbingProxy_NetworkRequest
    typealias Verification = __VerificationProxy_NetworkRequest

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    class DefaultImplCaller: NetworkRequest, @unchecked Sendable {
        private let reference: () -> any NetworkRequest
    
        private let _getter_storage$$method: () -> NetworkMethod
        var method: NetworkMethod {
            get { return _getter_storage$$method() }
        }
    
        private let _getter_storage$$path: () -> String
        var path: String {
            get { return _getter_storage$$path() }
        }
    
        private let _getter_storage$$host: () -> String
        var host: String {
            get { return _getter_storage$$host() }
        }
    
        private let _getter_storage$$additionalHeaders: () -> [String: String]
        var additionalHeaders: [String: String] {
            get { return _getter_storage$$additionalHeaders() }
        }
    
        private let _getter_storage$$body: () -> Data?
        var body: Data? {
            get { return _getter_storage$$body() }
        }
    
        
        init<_CUCKOO$$GENERIC: NetworkRequest>(from defaultImpl: UnsafeMutablePointer<_CUCKOO$$GENERIC>, keeping reference: @escaping @autoclosure () -> _CUCKOO$$GENERIC) where _CUCKOO$$GENERIC.Response == Response {
            self.reference = reference
    
            _getter_storage$$method = { defaultImpl.pointee.method }
            _getter_storage$$path = { defaultImpl.pointee.path }
            _getter_storage$$host = { defaultImpl.pointee.host }
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
        __defaultImplStub = DefaultImplCaller(from: stub, keeping: stub.pointee)
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

    var host: String {
        get {
            return cuckoo_manager.getter(
                "host",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.host
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
        
        var host: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockNetworkRequest,String> {
            return .init(manager: cuckoo_manager, name: "host")
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
        
        var host: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "host", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var additionalHeaders: Cuckoo.VerifyReadOnlyProperty<[String: String]> {
            return .init(manager: cuckoo_manager, name: "additionalHeaders", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var body: Cuckoo.VerifyReadOnlyProperty<Data?> {
            return .init(manager: cuckoo_manager, name: "body", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    }
}

class NetworkRequestStub<Response>:NetworkRequest, @unchecked Sendable {
    
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
    
    var host: String {
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




// MARK: - Mocks generated from file: '../Modules/logic-api/Sources/Error/NetworkError.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-api/Sources/Model/Response/WalletInstanceAttestation.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-api/Sources/Model/Response/WalletKeyAttestation.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-api/Sources/Provider/NetworkSessionProvider.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockNetworkSessionProvider: NetworkSessionProvider, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any NetworkSessionProvider
    public typealias Stubbing = __StubbingProxy_NetworkSessionProvider
    public typealias Verification = __VerificationProxy_NetworkSessionProvider

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any NetworkSessionProvider)?

    public func enableDefaultImplementation(_ stub: any NetworkSessionProvider) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public var urlSession: URLSession {
        get {
            return cuckoo_manager.getter(
                "urlSession",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.urlSession
            )
        }
    }


    public struct __StubbingProxy_NetworkSessionProvider: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var urlSession: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockNetworkSessionProvider,URLSession> {
            return .init(manager: cuckoo_manager, name: "urlSession")
        }
    }

    public struct __VerificationProxy_NetworkSessionProvider: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var urlSession: Cuckoo.VerifyReadOnlyProperty<URLSession> {
            return .init(manager: cuckoo_manager, name: "urlSession", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    }
}

public class NetworkSessionProviderStub:NetworkSessionProvider, @unchecked Sendable {
    
    public var urlSession: URLSession {
        get {
            return DefaultValueRegistry.defaultValue(for: (URLSession).self)
        }
    }


}




// MARK: - Mocks generated from file: '../Modules/logic-api/Sources/Repository/WalletAttestationRepository.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockWalletAttestationRepository: WalletAttestationRepository, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any WalletAttestationRepository
    public typealias Stubbing = __StubbingProxy_WalletAttestationRepository
    public typealias Verification = __VerificationProxy_WalletAttestationRepository

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any WalletAttestationRepository)?

    public func enableDefaultImplementation(_ stub: any WalletAttestationRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func issueWalletKeyAttestation(host p0: String, payload p1: Data) async throws -> WalletKeyAttestation {
        return try await cuckoo_manager.callThrows(
            "issueWalletKeyAttestation(host p0: String, payload p1: Data) async throws -> WalletKeyAttestation",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.issueWalletKeyAttestation(host: p0, payload: p1)
        )
    }

    public func issueWalletInstanceAttestation(host p0: String, payload p1: Data) async throws -> WalletInstanceAttestation {
        return try await cuckoo_manager.callThrows(
            "issueWalletInstanceAttestation(host p0: String, payload p1: Data) async throws -> WalletInstanceAttestation",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.issueWalletInstanceAttestation(host: p0, payload: p1)
        )
    }

    public struct __StubbingProxy_WalletAttestationRepository: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func issueWalletKeyAttestation<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(host p0: M1, payload p1: M2) -> Cuckoo.ProtocolStubThrowingFunction<(String, Data), WalletKeyAttestation,Swift.Error> where M1.MatchedType == String, M2.MatchedType == Data {
            let matchers: [Cuckoo.ParameterMatcher<(String, Data)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletAttestationRepository.self,
                method: "issueWalletKeyAttestation(host p0: String, payload p1: Data) async throws -> WalletKeyAttestation",
                parameterMatchers: matchers
            ))
        }
        
        func issueWalletInstanceAttestation<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(host p0: M1, payload p1: M2) -> Cuckoo.ProtocolStubThrowingFunction<(String, Data), WalletInstanceAttestation,Swift.Error> where M1.MatchedType == String, M2.MatchedType == Data {
            let matchers: [Cuckoo.ParameterMatcher<(String, Data)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletAttestationRepository.self,
                method: "issueWalletInstanceAttestation(host p0: String, payload p1: Data) async throws -> WalletInstanceAttestation",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_WalletAttestationRepository: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func issueWalletKeyAttestation<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(host p0: M1, payload p1: M2) -> Cuckoo.__DoNotUse<(String, Data), WalletKeyAttestation> where M1.MatchedType == String, M2.MatchedType == Data {
            let matchers: [Cuckoo.ParameterMatcher<(String, Data)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "issueWalletKeyAttestation(host p0: String, payload p1: Data) async throws -> WalletKeyAttestation",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func issueWalletInstanceAttestation<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(host p0: M1, payload p1: M2) -> Cuckoo.__DoNotUse<(String, Data), WalletInstanceAttestation> where M1.MatchedType == String, M2.MatchedType == Data {
            let matchers: [Cuckoo.ParameterMatcher<(String, Data)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "issueWalletInstanceAttestation(host p0: String, payload p1: Data) async throws -> WalletInstanceAttestation",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class WalletAttestationRepositoryStub:WalletAttestationRepository, @unchecked Sendable {


    
    public func issueWalletKeyAttestation(host p0: String, payload p1: Data) async throws -> WalletKeyAttestation {
        return DefaultValueRegistry.defaultValue(for: (WalletKeyAttestation).self)
    }
    
    public func issueWalletInstanceAttestation(host p0: String, payload p1: Data) async throws -> WalletInstanceAttestation {
        return DefaultValueRegistry.defaultValue(for: (WalletInstanceAttestation).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-authentication/Sources/Config/AuthenticationConfig.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockAuthenticationConfig: AuthenticationConfig, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any AuthenticationConfig
    public typealias Stubbing = __StubbingProxy_AuthenticationConfig
    public typealias Verification = __VerificationProxy_AuthenticationConfig

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any AuthenticationConfig)?

    public func enableDefaultImplementation(_ stub: any AuthenticationConfig) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public var maxFailedPinAttempts: Int {
        get {
            return cuckoo_manager.getter(
                "maxFailedPinAttempts",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.maxFailedPinAttempts
            )
        }
    }

    public var pinLockoutDurations: [TimeInterval] {
        get {
            return cuckoo_manager.getter(
                "pinLockoutDurations",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.pinLockoutDurations
            )
        }
    }

    public var backgroundLockTimeout: TimeInterval {
        get {
            return cuckoo_manager.getter(
                "backgroundLockTimeout",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.backgroundLockTimeout
            )
        }
    }

    public var idleLockTimeout: TimeInterval {
        get {
            return cuckoo_manager.getter(
                "idleLockTimeout",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.idleLockTimeout
            )
        }
    }

    public var protectedFlowLockTimeout: TimeInterval {
        get {
            return cuckoo_manager.getter(
                "protectedFlowLockTimeout",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.protectedFlowLockTimeout
            )
        }
    }

    public var commonPins: Set<String> {
        get {
            return cuckoo_manager.getter(
                "commonPins",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.commonPins
            )
        }
    }

    public var requireDeviceSecure: Bool {
        get {
            return cuckoo_manager.getter(
                "requireDeviceSecure",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.requireDeviceSecure
            )
        }
    }


    public struct __StubbingProxy_AuthenticationConfig: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var maxFailedPinAttempts: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAuthenticationConfig,Int> {
            return .init(manager: cuckoo_manager, name: "maxFailedPinAttempts")
        }
        
        var pinLockoutDurations: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAuthenticationConfig,[TimeInterval]> {
            return .init(manager: cuckoo_manager, name: "pinLockoutDurations")
        }
        
        var backgroundLockTimeout: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAuthenticationConfig,TimeInterval> {
            return .init(manager: cuckoo_manager, name: "backgroundLockTimeout")
        }
        
        var idleLockTimeout: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAuthenticationConfig,TimeInterval> {
            return .init(manager: cuckoo_manager, name: "idleLockTimeout")
        }
        
        var protectedFlowLockTimeout: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAuthenticationConfig,TimeInterval> {
            return .init(manager: cuckoo_manager, name: "protectedFlowLockTimeout")
        }
        
        var commonPins: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAuthenticationConfig,Set<String>> {
            return .init(manager: cuckoo_manager, name: "commonPins")
        }
        
        var requireDeviceSecure: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAuthenticationConfig,Bool> {
            return .init(manager: cuckoo_manager, name: "requireDeviceSecure")
        }
    }

    public struct __VerificationProxy_AuthenticationConfig: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var maxFailedPinAttempts: Cuckoo.VerifyReadOnlyProperty<Int> {
            return .init(manager: cuckoo_manager, name: "maxFailedPinAttempts", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var pinLockoutDurations: Cuckoo.VerifyReadOnlyProperty<[TimeInterval]> {
            return .init(manager: cuckoo_manager, name: "pinLockoutDurations", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var backgroundLockTimeout: Cuckoo.VerifyReadOnlyProperty<TimeInterval> {
            return .init(manager: cuckoo_manager, name: "backgroundLockTimeout", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var idleLockTimeout: Cuckoo.VerifyReadOnlyProperty<TimeInterval> {
            return .init(manager: cuckoo_manager, name: "idleLockTimeout", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var protectedFlowLockTimeout: Cuckoo.VerifyReadOnlyProperty<TimeInterval> {
            return .init(manager: cuckoo_manager, name: "protectedFlowLockTimeout", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var commonPins: Cuckoo.VerifyReadOnlyProperty<Set<String>> {
            return .init(manager: cuckoo_manager, name: "commonPins", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var requireDeviceSecure: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "requireDeviceSecure", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    }
}

public class AuthenticationConfigStub:AuthenticationConfig, @unchecked Sendable {
    
    public var maxFailedPinAttempts: Int {
        get {
            return DefaultValueRegistry.defaultValue(for: (Int).self)
        }
    }
    
    public var pinLockoutDurations: [TimeInterval] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([TimeInterval]).self)
        }
    }
    
    public var backgroundLockTimeout: TimeInterval {
        get {
            return DefaultValueRegistry.defaultValue(for: (TimeInterval).self)
        }
    }
    
    public var idleLockTimeout: TimeInterval {
        get {
            return DefaultValueRegistry.defaultValue(for: (TimeInterval).self)
        }
    }
    
    public var protectedFlowLockTimeout: TimeInterval {
        get {
            return DefaultValueRegistry.defaultValue(for: (TimeInterval).self)
        }
    }
    
    public var commonPins: Set<String> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Set<String>).self)
        }
    }
    
    public var requireDeviceSecure: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
    }


}




// MARK: - Mocks generated from file: '../Modules/logic-authentication/Sources/Controller/DeviceLockController.swift'

import Cuckoo
import LocalAuthentication
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockDeviceLockController: DeviceLockController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any DeviceLockController
    public typealias Stubbing = __StubbingProxy_DeviceLockController
    public typealias Verification = __VerificationProxy_DeviceLockController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any DeviceLockController)?

    public func enableDefaultImplementation(_ stub: any DeviceLockController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func isDeviceSecure() -> Bool {
        return cuckoo_manager.call(
            "isDeviceSecure() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.isDeviceSecure()
        )
    }

    public struct __StubbingProxy_DeviceLockController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func isDeviceSecure() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockDeviceLockController.self,
                method: "isDeviceSecure() -> Bool",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_DeviceLockController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func isDeviceSecure() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "isDeviceSecure() -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class DeviceLockControllerStub:DeviceLockController, @unchecked Sendable {


    
    public func isDeviceSecure() -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-authentication/Sources/Controller/PinStorageController.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockPinStorageController: PinStorageController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any PinStorageController
    public typealias Stubbing = __StubbingProxy_PinStorageController
    public typealias Verification = __VerificationProxy_PinStorageController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any PinStorageController)?

    public func enableDefaultImplementation(_ stub: any PinStorageController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func hasPin() throws -> Bool {
        return try cuckoo_manager.callThrows(
            "hasPin() throws -> Bool",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.hasPin()
        )
    }

    public func setPin(with p0: String) throws {
        return try cuckoo_manager.callThrows(
            "setPin(with p0: String) throws",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
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
        
        func hasPin() -> Cuckoo.ProtocolStubThrowingFunction<(), Bool,Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPinStorageController.self,
                method: "hasPin() throws -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func setPin<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(String),Swift.Error> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPinStorageController.self,
                method: "setPin(with p0: String) throws",
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
        func hasPin() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "hasPin() throws -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setPin<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setPin(with p0: String) throws",
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

public class PinStorageControllerStub:PinStorageController, @unchecked Sendable {


    
    public func hasPin() throws -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func setPin(with p0: String) throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func isPinValid(with p0: String) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-authentication/Sources/Controller/PinThrottleController.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockPinThrottleController: PinThrottleController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any PinThrottleController
    public typealias Stubbing = __StubbingProxy_PinThrottleController
    public typealias Verification = __VerificationProxy_PinThrottleController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any PinThrottleController)?

    public func enableDefaultImplementation(_ stub: any PinThrottleController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func getState() -> PinLockoutState {
        return cuckoo_manager.call(
            "getState() -> PinLockoutState",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getState()
        )
    }

    public func recordFailure() -> PinLockoutState {
        return cuckoo_manager.call(
            "recordFailure() -> PinLockoutState",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.recordFailure()
        )
    }

    public func recordSuccess() {
        return cuckoo_manager.call(
            "recordSuccess()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.recordSuccess()
        )
    }

    public struct __StubbingProxy_PinThrottleController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func getState() -> Cuckoo.ProtocolStubFunction<(), PinLockoutState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPinThrottleController.self,
                method: "getState() -> PinLockoutState",
                parameterMatchers: matchers
            ))
        }
        
        func recordFailure() -> Cuckoo.ProtocolStubFunction<(), PinLockoutState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPinThrottleController.self,
                method: "recordFailure() -> PinLockoutState",
                parameterMatchers: matchers
            ))
        }
        
        func recordSuccess() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPinThrottleController.self,
                method: "recordSuccess()",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_PinThrottleController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func getState() -> Cuckoo.__DoNotUse<(), PinLockoutState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getState() -> PinLockoutState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func recordFailure() -> Cuckoo.__DoNotUse<(), PinLockoutState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "recordFailure() -> PinLockoutState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func recordSuccess() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "recordSuccess()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class PinThrottleControllerStub:PinThrottleController, @unchecked Sendable {


    
    public func getState() -> PinLockoutState {
        return DefaultValueRegistry.defaultValue(for: (PinLockoutState).self)
    }
    
    public func recordFailure() -> PinLockoutState {
        return DefaultValueRegistry.defaultValue(for: (PinLockoutState).self)
    }
    
    public func recordSuccess() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-authentication/Sources/Controller/SessionController.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockSessionController: SessionController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any SessionController
    public typealias Stubbing = __StubbingProxy_SessionController
    public typealias Verification = __VerificationProxy_SessionController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any SessionController)?

    public func enableDefaultImplementation(_ stub: any SessionController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public var isUnlocked: Bool {
        get {
            return cuckoo_manager.getter(
                "isUnlocked",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.isUnlocked
            )
        }
    }


    public func unlock() {
        return cuckoo_manager.call(
            "unlock()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.unlock()
        )
    }

    public func lock() {
        return cuckoo_manager.call(
            "lock()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.lock()
        )
    }

    public func recordInteraction() {
        return cuckoo_manager.call(
            "recordInteraction()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.recordInteraction()
        )
    }

    public func recordBackground(isProtectedFlow p0: Bool) {
        return cuckoo_manager.call(
            "recordBackground(isProtectedFlow p0: Bool)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.recordBackground(isProtectedFlow: p0)
        )
    }

    public func lockIfExpired() -> Bool {
        return cuckoo_manager.call(
            "lockIfExpired() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.lockIfExpired()
        )
    }

    public func setCovered(_ p0: Bool) {
        return cuckoo_manager.call(
            "setCovered(_ p0: Bool)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setCovered(p0)
        )
    }

    public func beginExternalFlow() -> Int {
        return cuckoo_manager.call(
            "beginExternalFlow() -> Int",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.beginExternalFlow()
        )
    }

    public func endExternalFlow(startedIn p0: Int) {
        return cuckoo_manager.call(
            "endExternalFlow(startedIn p0: Int)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.endExternalFlow(startedIn: p0)
        )
    }

    public struct __StubbingProxy_SessionController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var isUnlocked: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSessionController,Bool> {
            return .init(manager: cuckoo_manager, name: "isUnlocked")
        }
        
        func unlock() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSessionController.self,
                method: "unlock()",
                parameterMatchers: matchers
            ))
        }
        
        func lock() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSessionController.self,
                method: "lock()",
                parameterMatchers: matchers
            ))
        }
        
        func recordInteraction() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSessionController.self,
                method: "recordInteraction()",
                parameterMatchers: matchers
            ))
        }
        
        func recordBackground<M1: Cuckoo.Matchable>(isProtectedFlow p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockSessionController.self,
                method: "recordBackground(isProtectedFlow p0: Bool)",
                parameterMatchers: matchers
            ))
        }
        
        func lockIfExpired() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSessionController.self,
                method: "lockIfExpired() -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func setCovered<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockSessionController.self,
                method: "setCovered(_ p0: Bool)",
                parameterMatchers: matchers
            ))
        }
        
        func beginExternalFlow() -> Cuckoo.ProtocolStubFunction<(), Int> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSessionController.self,
                method: "beginExternalFlow() -> Int",
                parameterMatchers: matchers
            ))
        }
        
        func endExternalFlow<M1: Cuckoo.Matchable>(startedIn p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Int)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockSessionController.self,
                method: "endExternalFlow(startedIn p0: Int)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_SessionController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var isUnlocked: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "isUnlocked", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        @discardableResult
        func unlock() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "unlock()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func lock() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "lock()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func recordInteraction() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "recordInteraction()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func recordBackground<M1: Cuckoo.Matchable>(isProtectedFlow p0: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "recordBackground(isProtectedFlow p0: Bool)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func lockIfExpired() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "lockIfExpired() -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setCovered<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setCovered(_ p0: Bool)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func beginExternalFlow() -> Cuckoo.__DoNotUse<(), Int> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "beginExternalFlow() -> Int",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func endExternalFlow<M1: Cuckoo.Matchable>(startedIn p0: M1) -> Cuckoo.__DoNotUse<(Int), Void> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "endExternalFlow(startedIn p0: Int)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class SessionControllerStub:SessionController, @unchecked Sendable {
    
    public var isUnlocked: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
    }


    
    public func unlock() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func lock() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func recordInteraction() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func recordBackground(isProtectedFlow p0: Bool) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func lockIfExpired() -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func setCovered(_ p0: Bool) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func beginExternalFlow() -> Int {
        return DefaultValueRegistry.defaultValue(for: (Int).self)
    }
    
    public func endExternalFlow(startedIn p0: Int) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-authentication/Sources/Controller/SystemBiometryController.swift'

import Cuckoo
import LocalAuthentication
import logic_resources
import UIKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockSystemBiometryController: SystemBiometryController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any SystemBiometryController
    public typealias Stubbing = __StubbingProxy_SystemBiometryController
    public typealias Verification = __VerificationProxy_SystemBiometryController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any SystemBiometryController)?

    public func enableDefaultImplementation(_ stub: any SystemBiometryController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func getBiometryType() async -> LABiometryType {
        return await cuckoo_manager.call(
            "getBiometryType() async -> LABiometryType",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getBiometryType()
        )
    }

    public func requestBiometricUnlock() async throws {
        return try await cuckoo_manager.callThrows(
            "requestBiometricUnlock() async throws",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.requestBiometricUnlock()
        )
    }

    public func enableBiometricUnlock() async throws {
        return try await cuckoo_manager.callThrows(
            "enableBiometricUnlock() async throws",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.enableBiometricUnlock()
        )
    }

    public func disableBiometricUnlock() async throws {
        return try await cuckoo_manager.callThrows(
            "disableBiometricUnlock() async throws",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.disableBiometricUnlock()
        )
    }

    public func openSettings(action p0: @escaping @Sendable () -> Void) async {
        return await cuckoo_manager.call(
            "openSettings(action p0: @escaping @Sendable () -> Void) async",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.openSettings(action: p0)
        )
    }

    public struct __StubbingProxy_SystemBiometryController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func getBiometryType() -> Cuckoo.ProtocolStubFunction<(), LABiometryType> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometryController.self,
                method: "getBiometryType() async -> LABiometryType",
                parameterMatchers: matchers
            ))
        }
        
        func requestBiometricUnlock() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(),Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometryController.self,
                method: "requestBiometricUnlock() async throws",
                parameterMatchers: matchers
            ))
        }
        
        func enableBiometricUnlock() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(),Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometryController.self,
                method: "enableBiometricUnlock() async throws",
                parameterMatchers: matchers
            ))
        }
        
        func disableBiometricUnlock() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(),Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometryController.self,
                method: "disableBiometricUnlock() async throws",
                parameterMatchers: matchers
            ))
        }
        
        func openSettings<M1: Cuckoo.Matchable>(action p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(@Sendable () -> Void)> where M1.MatchedType == @Sendable () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(@Sendable () -> Void)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockSystemBiometryController.self,
                method: "openSettings(action p0: @escaping @Sendable () -> Void) async",
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
        
        
        @discardableResult
        func getBiometryType() -> Cuckoo.__DoNotUse<(), LABiometryType> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getBiometryType() async -> LABiometryType",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func requestBiometricUnlock() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "requestBiometricUnlock() async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func enableBiometricUnlock() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "enableBiometricUnlock() async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func disableBiometricUnlock() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "disableBiometricUnlock() async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func openSettings<M1: Cuckoo.Matchable>(action p0: M1) -> Cuckoo.__DoNotUse<(@Sendable () -> Void), Void> where M1.MatchedType == @Sendable () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(@Sendable () -> Void)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "openSettings(action p0: @escaping @Sendable () -> Void) async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class SystemBiometryControllerStub:SystemBiometryController, @unchecked Sendable {


    
    public func getBiometryType() async -> LABiometryType {
        return DefaultValueRegistry.defaultValue(for: (LABiometryType).self)
    }
    
    public func requestBiometricUnlock() async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func enableBiometricUnlock() async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func disableBiometricUnlock() async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func openSettings(action p0: @escaping @Sendable () -> Void) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-authentication/Sources/Controller/WalletResetController.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockWalletResetController: WalletResetController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any WalletResetController
    public typealias Stubbing = __StubbingProxy_WalletResetController
    public typealias Verification = __VerificationProxy_WalletResetController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any WalletResetController)?

    public func enableDefaultImplementation(_ stub: any WalletResetController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func resetWallet() async throws {
        return try await cuckoo_manager.callThrows(
            "resetWallet() async throws",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.resetWallet()
        )
    }

    public struct __StubbingProxy_WalletResetController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func resetWallet() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(),Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletResetController.self,
                method: "resetWallet() async throws",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_WalletResetController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func resetWallet() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "resetWallet() async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class WalletResetControllerStub:WalletResetController, @unchecked Sendable {


    
    public func resetWallet() async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-authentication/Sources/Error/AuthenticationError.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-authentication/Sources/Error/SystemBiometryError.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-authentication/Sources/Provider/PinStorageProvider.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

class MockPinStorageProvider: PinStorageProvider, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = any PinStorageProvider
    typealias Stubbing = __StubbingProxy_PinStorageProvider
    typealias Verification = __VerificationProxy_PinStorageProvider

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any PinStorageProvider)?

    func enableDefaultImplementation(_ stub: any PinStorageProvider) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    func hasPin() throws -> Bool {
        return try cuckoo_manager.callThrows(
            "hasPin() throws -> Bool",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.hasPin()
        )
    }

    func setPin(with p0: String) throws {
        return try cuckoo_manager.callThrows(
            "setPin(with p0: String) throws",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
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
        
        func hasPin() -> Cuckoo.ProtocolStubThrowingFunction<(), Bool,Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPinStorageProvider.self,
                method: "hasPin() throws -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func setPin<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(String),Swift.Error> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockPinStorageProvider.self,
                method: "setPin(with p0: String) throws",
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
        func hasPin() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "hasPin() throws -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setPin<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setPin(with p0: String) throws",
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

class PinStorageProviderStub:PinStorageProvider, @unchecked Sendable {


    
    func hasPin() throws -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    func setPin(with p0: String) throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    func isPinValid(with p0: String) -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-authentication/Sources/Provider/PinThrottleProvider.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

class MockPinThrottleProvider: PinThrottleProvider, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = any PinThrottleProvider
    typealias Stubbing = __StubbingProxy_PinThrottleProvider
    typealias Verification = __VerificationProxy_PinThrottleProvider

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any PinThrottleProvider)?

    func enableDefaultImplementation(_ stub: any PinThrottleProvider) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    func getState() -> PinLockoutState {
        return cuckoo_manager.call(
            "getState() -> PinLockoutState",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getState()
        )
    }

    func recordFailure() -> PinLockoutState {
        return cuckoo_manager.call(
            "recordFailure() -> PinLockoutState",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.recordFailure()
        )
    }

    func recordSuccess() {
        return cuckoo_manager.call(
            "recordSuccess()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.recordSuccess()
        )
    }

    struct __StubbingProxy_PinThrottleProvider: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func getState() -> Cuckoo.ProtocolStubFunction<(), PinLockoutState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPinThrottleProvider.self,
                method: "getState() -> PinLockoutState",
                parameterMatchers: matchers
            ))
        }
        
        func recordFailure() -> Cuckoo.ProtocolStubFunction<(), PinLockoutState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPinThrottleProvider.self,
                method: "recordFailure() -> PinLockoutState",
                parameterMatchers: matchers
            ))
        }
        
        func recordSuccess() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockPinThrottleProvider.self,
                method: "recordSuccess()",
                parameterMatchers: matchers
            ))
        }
    }

    struct __VerificationProxy_PinThrottleProvider: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func getState() -> Cuckoo.__DoNotUse<(), PinLockoutState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getState() -> PinLockoutState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func recordFailure() -> Cuckoo.__DoNotUse<(), PinLockoutState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "recordFailure() -> PinLockoutState",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func recordSuccess() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "recordSuccess()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

class PinThrottleProviderStub:PinThrottleProvider, @unchecked Sendable {


    
    func getState() -> PinLockoutState {
        return DefaultValueRegistry.defaultValue(for: (PinLockoutState).self)
    }
    
    func recordFailure() -> PinLockoutState {
        return DefaultValueRegistry.defaultValue(for: (PinLockoutState).self)
    }
    
    func recordSuccess() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-authentication/Sources/Storage/KeychainPinStorageProvider.swift'

import Cuckoo
import Foundation
import CommonCrypto
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-authentication/Sources/Storage/KeychainPinThrottleProvider.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Builder/ArrayBuilder.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Config/ConfigLogic.swift'

import Cuckoo
import Foundation
import EudiRQESUi
import MdocDataModel18013
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockConfigLogic: ConfigLogic, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any ConfigLogic
    public typealias Stubbing = __StubbingProxy_ConfigLogic
    public typealias Verification = __VerificationProxy_ConfigLogic

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any ConfigLogic)?

    public func enableDefaultImplementation(_ stub: any ConfigLogic) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
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

    public var forcePidActivation: Bool {
        get {
            return cuckoo_manager.getter(
                "forcePidActivation",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.forcePidActivation
            )
        }
    }

    public var keyChainConfig: KeyChainConfig {
        get {
            return cuckoo_manager.getter(
                "keyChainConfig",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.keyChainConfig
            )
        }
    }


    public struct __StubbingProxy_ConfigLogic: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
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
        
        var forcePidActivation: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigLogic,Bool> {
            return .init(manager: cuckoo_manager, name: "forcePidActivation")
        }
        
        var keyChainConfig: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigLogic,KeyChainConfig> {
            return .init(manager: cuckoo_manager, name: "keyChainConfig")
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
        
        var forcePidActivation: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "forcePidActivation", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var keyChainConfig: Cuckoo.VerifyReadOnlyProperty<KeyChainConfig> {
            return .init(manager: cuckoo_manager, name: "keyChainConfig", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    }
}

public class ConfigLogicStub:ConfigLogic, @unchecked Sendable {
    
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
    
    public var forcePidActivation: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
    }
    
    public var keyChainConfig: KeyChainConfig {
        get {
            return DefaultValueRegistry.defaultValue(for: (KeyChainConfig).self)
        }
    }


}




// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Config/KeyChainConfig.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Controller/KeyChainController.swift'

import Cuckoo
import Foundation
import Security
import os
import LocalAuthentication
import KeychainAccess
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockKeyChainWrapper: KeyChainWrapper, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any KeyChainWrapper
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
    public typealias MocksType = any KeyChainController
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

    public func fetchValue(key p0: KeyChainWrapper) throws -> String? {
        return try cuckoo_manager.callThrows(
            "fetchValue(key p0: KeyChainWrapper) throws -> String?",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.fetchValue(key: p0)
        )
    }

    public func fetchData(key p0: KeyChainWrapper) throws -> Data? {
        return try cuckoo_manager.callThrows(
            "fetchData(key p0: KeyChainWrapper) throws -> Data?",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.fetchData(key: p0)
        )
    }

    public func saveValue(key p0: KeyChainWrapper, value p1: String) throws {
        return try cuckoo_manager.callThrows(
            "saveValue(key p0: KeyChainWrapper, value p1: String) throws",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.saveValue(key: p0, value: p1)
        )
    }

    public func saveValue(key p0: KeyChainWrapper, value p1: Data) throws {
        return try cuckoo_manager.callThrows(
            "saveValue(key p0: KeyChainWrapper, value p1: Data) throws",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.saveValue(key: p0, value: p1)
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

    public func storeBiometricProbe() throws {
        return try cuckoo_manager.callThrows(
            "storeBiometricProbe() throws",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.storeBiometricProbe()
        )
    }

    public func validateKeyChainBiometry(with p0: LAContext) throws {
        return try cuckoo_manager.callThrows(
            "validateKeyChainBiometry(with p0: LAContext) throws",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.validateKeyChainBiometry(with: p0)
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

    public func clear() -> Bool {
        return cuckoo_manager.call(
            "clear() -> Bool",
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
        
        func fetchValue<M1: Cuckoo.Matchable>(key p0: M1) -> Cuckoo.ProtocolStubThrowingFunction<(KeyChainWrapper), String?,Swift.Error> where M1.MatchedType == KeyChainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeyChainWrapper)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self,
                method: "fetchValue(key p0: KeyChainWrapper) throws -> String?",
                parameterMatchers: matchers
            ))
        }
        
        func fetchData<M1: Cuckoo.Matchable>(key p0: M1) -> Cuckoo.ProtocolStubThrowingFunction<(KeyChainWrapper), Data?,Swift.Error> where M1.MatchedType == KeyChainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeyChainWrapper)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self,
                method: "fetchData(key p0: KeyChainWrapper) throws -> Data?",
                parameterMatchers: matchers
            ))
        }
        
        func saveValue<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(key p0: M1, value p1: M2) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(KeyChainWrapper, String),Swift.Error> where M1.MatchedType == KeyChainWrapper, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(KeyChainWrapper, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self,
                method: "saveValue(key p0: KeyChainWrapper, value p1: String) throws",
                parameterMatchers: matchers
            ))
        }
        
        func saveValue<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(key p0: M1, value p1: M2) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(KeyChainWrapper, Data),Swift.Error> where M1.MatchedType == KeyChainWrapper, M2.MatchedType == Data {
            let matchers: [Cuckoo.ParameterMatcher<(KeyChainWrapper, Data)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self,
                method: "saveValue(key p0: KeyChainWrapper, value p1: Data) throws",
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
        
        func storeBiometricProbe() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(),Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self,
                method: "storeBiometricProbe() throws",
                parameterMatchers: matchers
            ))
        }
        
        func validateKeyChainBiometry<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(LAContext),Swift.Error> where M1.MatchedType == LAContext {
            let matchers: [Cuckoo.ParameterMatcher<(LAContext)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self,
                method: "validateKeyChainBiometry(with p0: LAContext) throws",
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
        
        func clear() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainController.self,
                method: "clear() -> Bool",
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
        func fetchValue<M1: Cuckoo.Matchable>(key p0: M1) -> Cuckoo.__DoNotUse<(KeyChainWrapper), String?> where M1.MatchedType == KeyChainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeyChainWrapper)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "fetchValue(key p0: KeyChainWrapper) throws -> String?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func fetchData<M1: Cuckoo.Matchable>(key p0: M1) -> Cuckoo.__DoNotUse<(KeyChainWrapper), Data?> where M1.MatchedType == KeyChainWrapper {
            let matchers: [Cuckoo.ParameterMatcher<(KeyChainWrapper)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "fetchData(key p0: KeyChainWrapper) throws -> Data?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func saveValue<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(key p0: M1, value p1: M2) -> Cuckoo.__DoNotUse<(KeyChainWrapper, String), Void> where M1.MatchedType == KeyChainWrapper, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(KeyChainWrapper, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "saveValue(key p0: KeyChainWrapper, value p1: String) throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func saveValue<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(key p0: M1, value p1: M2) -> Cuckoo.__DoNotUse<(KeyChainWrapper, Data), Void> where M1.MatchedType == KeyChainWrapper, M2.MatchedType == Data {
            let matchers: [Cuckoo.ParameterMatcher<(KeyChainWrapper, Data)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "saveValue(key p0: KeyChainWrapper, value p1: Data) throws",
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
        func storeBiometricProbe() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "storeBiometricProbe() throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func validateKeyChainBiometry<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(LAContext), Void> where M1.MatchedType == LAContext {
            let matchers: [Cuckoo.ParameterMatcher<(LAContext)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "validateKeyChainBiometry(with p0: LAContext) throws",
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
        func clear() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "clear() -> Bool",
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
    
    public func fetchValue(key p0: KeyChainWrapper) throws -> String? {
        return DefaultValueRegistry.defaultValue(for: (String?).self)
    }
    
    public func fetchData(key p0: KeyChainWrapper) throws -> Data? {
        return DefaultValueRegistry.defaultValue(for: (Data?).self)
    }
    
    public func saveValue(key p0: KeyChainWrapper, value p1: String) throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func saveValue(key p0: KeyChainWrapper, value p1: Data) throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func removeObject(key p0: KeyChainWrapper) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func storeBiometricProbe() throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func validateKeyChainBiometry(with p0: LAContext) throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func clearKeyChainBiometry() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func clear() -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Controller/PrefsController.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockPrefsController: PrefsController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any PrefsController
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
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockReachabilityController: ReachabilityController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any ReachabilityController
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
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockDIGraphType: DIGraphType, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any DIGraphType
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




// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Error/KeyChainError.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Error/RuntimeError.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/Array+Extensions.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/Bundle+Extensions.swift'

import Cuckoo
import Foundation
import Security
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/ConfigLogic+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/Data+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/Date+Extensions.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/Encodable+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/Error+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/FileManager+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/Int+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/Locale+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/NSNotification+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/PrefsController+WalletReset.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/Publisher+Extensions.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/Resolver+Extensions.swift'

import Cuckoo
import Swinject
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/String+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/Task+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/TimeInterval+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Extension/URL+Extensions.swift'

import Cuckoo
import UIKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Model/MonotonicClock.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Model/Prefs.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Validator/FilterValidator.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockFilterValidator: FilterValidator, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any FilterValidator
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

    public func updateSort(filterId p0: String) async {
        return await cuckoo_manager.call(
            "updateSort(filterId p0: String) async",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.updateSort(filterId: p0)
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
        
        func updateSort<M1: Cuckoo.Matchable>(filterId p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFilterValidator.self,
                method: "updateSort(filterId p0: String) async",
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
        
        
        @discardableResult
        func updateSort<M1: Cuckoo.Matchable>(filterId p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "updateSort(filterId p0: String) async",
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
    
    public func updateSort(filterId p0: String) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Validator/FormValidator.swift'

import Cuckoo
import Foundation
import Peppermint
import PhoneNumberKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockFormValidator: FormValidator, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any FormValidator
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
    public typealias MocksType = any FormValidatorInteractor
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
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockFilterAction: FilterAction, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any FilterAction
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


public class MockSortFilterAction: SortFilterAction, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any SortFilterAction
    public typealias Stubbing = __StubbingProxy_SortFilterAction
    public typealias Verification = __VerificationProxy_SortFilterAction

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any SortFilterAction)?

    public func enableDefaultImplementation(_ stub: any SortFilterAction) {
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

    public struct __StubbingProxy_SortFilterAction: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func applyFilter<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(sortOrder p0: M1, filterableItems p1: M2, filter p2: M3) -> Cuckoo.ProtocolStubFunction<(SortOrderType, FilterableList, FilterItem), FilterableList> where M1.MatchedType == SortOrderType, M2.MatchedType == FilterableList, M3.MatchedType == FilterItem {
            let matchers: [Cuckoo.ParameterMatcher<(SortOrderType, FilterableList, FilterItem)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockSortFilterAction.self,
                method: "applyFilter(sortOrder p0: SortOrderType, filterableItems p1: FilterableList, filter p2: FilterItem) -> FilterableList",
                parameterMatchers: matchers
            ))
        }
        
        func applyFilterGroup<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(filterableItems p0: M1, filterGroup p1: M2) -> Cuckoo.ProtocolStubFunction<(FilterableList, FilterGroup), FilterableList> where M1.MatchedType == FilterableList, M2.MatchedType == FilterGroup {
            let matchers: [Cuckoo.ParameterMatcher<(FilterableList, FilterGroup)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockSortFilterAction.self,
                method: "applyFilterGroup(filterableItems p0: FilterableList, filterGroup p1: FilterGroup) -> FilterableList",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_SortFilterAction: Cuckoo.VerificationProxy {
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

public class SortFilterActionStub:SortFilterAction, @unchecked Sendable {


    
    public func applyFilter(sortOrder p0: SortOrderType, filterableItems p1: FilterableList, filter p2: FilterItem) -> FilterableList {
        return DefaultValueRegistry.defaultValue(for: (FilterableList).self)
    }
    
    public func applyFilterGroup(filterableItems p0: FilterableList, filterGroup p1: FilterGroup) -> FilterableList {
        return DefaultValueRegistry.defaultValue(for: (FilterableList).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Validator/Model/FilterIds.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-business/Sources/Validator/Model/Filterable.swift'

import Cuckoo
import Foundation
import Copyable
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockFilterableItemPayload: FilterableItemPayload, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any FilterableItemPayload
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
    public typealias MocksType = any FilterableAttributes
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
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockFilterGroup: FilterGroup, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any FilterGroup
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
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Config/DocumentIssuanceConfig.swift'

import Cuckoo
import EudiWalletKit
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Config/VciConfig.swift'

import Cuckoo
import Foundation
import EudiWalletKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Config/WalletKitConfig.swift'

import Cuckoo
import Foundation
import EudiWalletKit
import EudiEtsi1196x2
import MdocDataModel18013
import struct OpenID4VP.SupportedTransactionDataType
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

class MockWalletKitConfig: WalletKitConfig, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = any WalletKitConfig
    typealias Stubbing = __StubbingProxy_WalletKitConfig
    typealias Verification = __VerificationProxy_WalletKitConfig

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any WalletKitConfig)?

    func enableDefaultImplementation(_ stub: any WalletKitConfig) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    var issuersConfig: [String: VciConfig] {
        get {
            return cuckoo_manager.getter(
                "issuersConfig",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.issuersConfig
            )
        }
    }

    var validateIssuerRegistrationCertificate: Bool {
        get {
            return cuckoo_manager.getter(
                "validateIssuerRegistrationCertificate",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.validateIssuerRegistrationCertificate
            )
        }
    }

    var vpConfig: OpenId4VpConfiguration {
        get {
            return cuckoo_manager.getter(
                "vpConfig",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.vpConfig
            )
        }
    }

    var supportedTransactionDataTypes: [SupportedTransactionDataType] {
        get {
            return cuckoo_manager.getter(
                "supportedTransactionDataTypes",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.supportedTransactionDataTypes
            )
        }
    }

    var trustConfiguration: TrustConfiguration {
        get {
            return cuckoo_manager.getter(
                "trustConfiguration",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.trustConfiguration
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

    var keyOptions: KeyOptions? {
        get {
            return cuckoo_manager.getter(
                "keyOptions",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.keyOptions
            )
        }
    }

    var logFileName: String? {
        get {
            return cuckoo_manager.getter(
                "logFileName",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.logFileName
            )
        }
    }

    var documentsCategories: DocumentCategories {
        get {
            return cuckoo_manager.getter(
                "documentsCategories",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.documentsCategories
            )
        }
    }

    var transactionLogger: TransactionLogger {
        get {
            return cuckoo_manager.getter(
                "transactionLogger",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.transactionLogger
            )
        }
    }

    var revocationIntervalSeconds: TimeInterval {
        get {
            return cuckoo_manager.getter(
                "revocationIntervalSeconds",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.revocationIntervalSeconds
            )
        }
    }

    var workerStopTimeoutSeconds: TimeInterval {
        get {
            return cuckoo_manager.getter(
                "workerStopTimeoutSeconds",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.workerStopTimeoutSeconds
            )
        }
    }

    var documentIssuanceConfig: DocumentIssuanceConfig {
        get {
            return cuckoo_manager.getter(
                "documentIssuanceConfig",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.documentIssuanceConfig
            )
        }
    }

    var trustMarkSource: TrustMarkSource {
        get {
            return cuckoo_manager.getter(
                "trustMarkSource",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.trustMarkSource
            )
        }
    }


    struct __StubbingProxy_WalletKitConfig: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var issuersConfig: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,[String: VciConfig]> {
            return .init(manager: cuckoo_manager, name: "issuersConfig")
        }
        
        var validateIssuerRegistrationCertificate: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,Bool> {
            return .init(manager: cuckoo_manager, name: "validateIssuerRegistrationCertificate")
        }
        
        var vpConfig: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,OpenId4VpConfiguration> {
            return .init(manager: cuckoo_manager, name: "vpConfig")
        }
        
        var supportedTransactionDataTypes: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,[SupportedTransactionDataType]> {
            return .init(manager: cuckoo_manager, name: "supportedTransactionDataTypes")
        }
        
        var trustConfiguration: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,TrustConfiguration> {
            return .init(manager: cuckoo_manager, name: "trustConfiguration")
        }
        
        var userAuthenticationRequired: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,Bool> {
            return .init(manager: cuckoo_manager, name: "userAuthenticationRequired")
        }
        
        var keyOptions: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,KeyOptions?> {
            return .init(manager: cuckoo_manager, name: "keyOptions")
        }
        
        var logFileName: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,String?> {
            return .init(manager: cuckoo_manager, name: "logFileName")
        }
        
        var documentsCategories: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,DocumentCategories> {
            return .init(manager: cuckoo_manager, name: "documentsCategories")
        }
        
        var transactionLogger: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,TransactionLogger> {
            return .init(manager: cuckoo_manager, name: "transactionLogger")
        }
        
        var revocationIntervalSeconds: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,TimeInterval> {
            return .init(manager: cuckoo_manager, name: "revocationIntervalSeconds")
        }
        
        var workerStopTimeoutSeconds: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,TimeInterval> {
            return .init(manager: cuckoo_manager, name: "workerStopTimeoutSeconds")
        }
        
        var documentIssuanceConfig: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,DocumentIssuanceConfig> {
            return .init(manager: cuckoo_manager, name: "documentIssuanceConfig")
        }
        
        var trustMarkSource: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitConfig,TrustMarkSource> {
            return .init(manager: cuckoo_manager, name: "trustMarkSource")
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
        
        var issuersConfig: Cuckoo.VerifyReadOnlyProperty<[String: VciConfig]> {
            return .init(manager: cuckoo_manager, name: "issuersConfig", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var validateIssuerRegistrationCertificate: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "validateIssuerRegistrationCertificate", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var vpConfig: Cuckoo.VerifyReadOnlyProperty<OpenId4VpConfiguration> {
            return .init(manager: cuckoo_manager, name: "vpConfig", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var supportedTransactionDataTypes: Cuckoo.VerifyReadOnlyProperty<[SupportedTransactionDataType]> {
            return .init(manager: cuckoo_manager, name: "supportedTransactionDataTypes", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var trustConfiguration: Cuckoo.VerifyReadOnlyProperty<TrustConfiguration> {
            return .init(manager: cuckoo_manager, name: "trustConfiguration", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var userAuthenticationRequired: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "userAuthenticationRequired", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var keyOptions: Cuckoo.VerifyReadOnlyProperty<KeyOptions?> {
            return .init(manager: cuckoo_manager, name: "keyOptions", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var logFileName: Cuckoo.VerifyReadOnlyProperty<String?> {
            return .init(manager: cuckoo_manager, name: "logFileName", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var documentsCategories: Cuckoo.VerifyReadOnlyProperty<DocumentCategories> {
            return .init(manager: cuckoo_manager, name: "documentsCategories", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var transactionLogger: Cuckoo.VerifyReadOnlyProperty<TransactionLogger> {
            return .init(manager: cuckoo_manager, name: "transactionLogger", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var revocationIntervalSeconds: Cuckoo.VerifyReadOnlyProperty<TimeInterval> {
            return .init(manager: cuckoo_manager, name: "revocationIntervalSeconds", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var workerStopTimeoutSeconds: Cuckoo.VerifyReadOnlyProperty<TimeInterval> {
            return .init(manager: cuckoo_manager, name: "workerStopTimeoutSeconds", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var documentIssuanceConfig: Cuckoo.VerifyReadOnlyProperty<DocumentIssuanceConfig> {
            return .init(manager: cuckoo_manager, name: "documentIssuanceConfig", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var trustMarkSource: Cuckoo.VerifyReadOnlyProperty<TrustMarkSource> {
            return .init(manager: cuckoo_manager, name: "trustMarkSource", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    }
}

class WalletKitConfigStub:WalletKitConfig, @unchecked Sendable {
    
    var issuersConfig: [String: VciConfig] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String: VciConfig]).self)
        }
    }
    
    var validateIssuerRegistrationCertificate: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
    }
    
    var vpConfig: OpenId4VpConfiguration {
        get {
            return DefaultValueRegistry.defaultValue(for: (OpenId4VpConfiguration).self)
        }
    }
    
    var supportedTransactionDataTypes: [SupportedTransactionDataType] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([SupportedTransactionDataType]).self)
        }
    }
    
    var trustConfiguration: TrustConfiguration {
        get {
            return DefaultValueRegistry.defaultValue(for: (TrustConfiguration).self)
        }
    }
    
    var userAuthenticationRequired: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
    }
    
    var keyOptions: KeyOptions? {
        get {
            return DefaultValueRegistry.defaultValue(for: (KeyOptions?).self)
        }
    }
    
    var logFileName: String? {
        get {
            return DefaultValueRegistry.defaultValue(for: (String?).self)
        }
    }
    
    var documentsCategories: DocumentCategories {
        get {
            return DefaultValueRegistry.defaultValue(for: (DocumentCategories).self)
        }
    }
    
    var transactionLogger: TransactionLogger {
        get {
            return DefaultValueRegistry.defaultValue(for: (TransactionLogger).self)
        }
    }
    
    var revocationIntervalSeconds: TimeInterval {
        get {
            return DefaultValueRegistry.defaultValue(for: (TimeInterval).self)
        }
    }
    
    var workerStopTimeoutSeconds: TimeInterval {
        get {
            return DefaultValueRegistry.defaultValue(for: (TimeInterval).self)
        }
    }
    
    var documentIssuanceConfig: DocumentIssuanceConfig {
        get {
            return DefaultValueRegistry.defaultValue(for: (DocumentIssuanceConfig).self)
        }
    }
    
    var trustMarkSource: TrustMarkSource {
        get {
            return DefaultValueRegistry.defaultValue(for: (TrustMarkSource).self)
        }
    }


}




// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Config/WalletProviderAttestationConfig.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

class MockWalletProviderAttestationConfig: WalletProviderAttestationConfig, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = any WalletProviderAttestationConfig
    typealias Stubbing = __StubbingProxy_WalletProviderAttestationConfig
    typealias Verification = __VerificationProxy_WalletProviderAttestationConfig

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any WalletProviderAttestationConfig)?

    func enableDefaultImplementation(_ stub: any WalletProviderAttestationConfig) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    var walletProviderAttestationUrl: String {
        get {
            return cuckoo_manager.getter(
                "walletProviderAttestationUrl",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.walletProviderAttestationUrl
            )
        }
    }


    struct __StubbingProxy_WalletProviderAttestationConfig: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var walletProviderAttestationUrl: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletProviderAttestationConfig,String> {
            return .init(manager: cuckoo_manager, name: "walletProviderAttestationUrl")
        }
    }

    struct __VerificationProxy_WalletProviderAttestationConfig: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var walletProviderAttestationUrl: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "walletProviderAttestationUrl", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    }
}

class WalletProviderAttestationConfigStub:WalletProviderAttestationConfig, @unchecked Sendable {
    
    var walletProviderAttestationUrl: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }


}




// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Controller/WalletKitController.swift'

import Cuckoo
import SwiftUI
import logic_storage
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockWalletKitController: WalletKitController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any WalletKitController
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


    public func startProximityPresentation() async -> ProximitySessionCoordinator {
        return await cuckoo_manager.call(
            "startProximityPresentation() async -> ProximitySessionCoordinator",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.startProximityPresentation()
        )
    }

    public func startSameDevicePresentation(deepLink p0: URLComponents) async -> RemoteSessionCoordinator {
        return await cuckoo_manager.call(
            "startSameDevicePresentation(deepLink p0: URLComponents) async -> RemoteSessionCoordinator",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.startSameDevicePresentation(deepLink: p0)
        )
    }

    public func startCrossDevicePresentation(urlString p0: String) async -> RemoteSessionCoordinator {
        return await cuckoo_manager.call(
            "startCrossDevicePresentation(urlString p0: String) async -> RemoteSessionCoordinator",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.startCrossDevicePresentation(urlString: p0)
        )
    }

    public func stopPresentation() async {
        return await cuckoo_manager.call(
            "stopPresentation() async",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.stopPresentation()
        )
    }

    public func stopRemotePresentation(_ p0: RemoteSessionCoordinator) async {
        return await cuckoo_manager.call(
            "stopRemotePresentation(_ p0: RemoteSessionCoordinator) async",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.stopRemotePresentation(p0)
        )
    }

    public func stopProximityPresentation(_ p0: ProximitySessionCoordinator) async {
        return await cuckoo_manager.call(
            "stopProximityPresentation(_ p0: ProximitySessionCoordinator) async",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.stopProximityPresentation(p0)
        )
    }

    public func fetchAllDocuments() async -> [any DocClaimsDecodable] {
        return await cuckoo_manager.call(
            "fetchAllDocuments() async -> [any DocClaimsDecodable]",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.fetchAllDocuments()
        )
    }

    public func fetchDeferredDocuments() async -> [WalletStorage.Document] {
        return await cuckoo_manager.call(
            "fetchDeferredDocuments() async -> [WalletStorage.Document]",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.fetchDeferredDocuments()
        )
    }

    public func fetchIssuedDocuments() async -> [any DocClaimsDecodable] {
        return await cuckoo_manager.call(
            "fetchIssuedDocuments() async -> [any DocClaimsDecodable]",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.fetchIssuedDocuments()
        )
    }

    public func fetchIssuedDocuments(with p0: [DocumentTypeIdentifier]) async -> [any DocClaimsDecodable] {
        return await cuckoo_manager.call(
            "fetchIssuedDocuments(with p0: [DocumentTypeIdentifier]) async -> [any DocClaimsDecodable]",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.fetchIssuedDocuments(with: p0)
        )
    }

    public func fetchMainPidDocument() async -> (any DocClaimsDecodable)? {
        return await cuckoo_manager.call(
            "fetchMainPidDocument() async -> (any DocClaimsDecodable)?",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.fetchMainPidDocument()
        )
    }

    public func fetchDocument(with p0: String) async -> (any DocClaimsDecodable)? {
        return await cuckoo_manager.call(
            "fetchDocument(with p0: String) async -> (any DocClaimsDecodable)?",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.fetchDocument(with: p0)
        )
    }

    public func fetchDocuments(with p0: [String]) async -> [any DocClaimsDecodable] {
        return await cuckoo_manager.call(
            "fetchDocuments(with p0: [String]) async -> [any DocClaimsDecodable]",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.fetchDocuments(with: p0)
        )
    }

    public func clearAllDocuments() async throws {
        return try await cuckoo_manager.callThrows(
            "clearAllDocuments() async throws",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.clearAllDocuments()
        )
    }

    public func deleteDocument(with p0: String, status p1: DocumentStatus) async throws {
        return try await cuckoo_manager.callThrows(
            "deleteDocument(with p0: String, status p1: DocumentStatus) async throws",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.deleteDocument(with: p0, status: p1)
        )
    }

    public func loadDocuments() async throws {
        return try await cuckoo_manager.callThrows(
            "loadDocuments() async throws",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.loadDocuments()
        )
    }

    public func hasStoredDocuments() async throws -> Bool {
        return try await cuckoo_manager.callThrows(
            "hasStoredDocuments() async throws -> Bool",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.hasStoredDocuments()
        )
    }

    public func issueDocuments(issuerId p0: String, identifiers p1: [String], docTypeIdentifier p2: DocumentTypeIdentifier) async throws -> IssuanceResult {
        return try await cuckoo_manager.callThrows(
            "issueDocuments(issuerId p0: String, identifiers p1: [String], docTypeIdentifier p2: DocumentTypeIdentifier) async throws -> IssuanceResult",
            parameters: (p0, p1, p2),
            escapingParameters: (p0, p1, p2),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.issueDocuments(issuerId: p0, identifiers: p1, docTypeIdentifier: p2)
        )
    }

    public func reIssueDocument(identifier p0: String, isBackgroundOperation p1: Bool) async throws -> WalletStorage.Document {
        return try await cuckoo_manager.callThrows(
            "reIssueDocument(identifier p0: String, isBackgroundOperation p1: Bool) async throws -> WalletStorage.Document",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.reIssueDocument(identifier: p0, isBackgroundOperation: p1)
        )
    }

    public func getDocumentCredentialOptions(with p0: String) async -> CredentialOptions? {
        return await cuckoo_manager.call(
            "getDocumentCredentialOptions(with p0: String) async -> CredentialOptions?",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getDocumentCredentialOptions(with: p0)
        )
    }

    public func requestDeferredIssuance(with p0: WalletStorage.Document) async throws -> any DocClaimsDecodable {
        return try await cuckoo_manager.callThrows(
            "requestDeferredIssuance(with p0: WalletStorage.Document) async throws -> any DocClaimsDecodable",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.requestDeferredIssuance(with: p0)
        )
    }

    public func resolveOfferUrlDocTypes(offerUri p0: String) async throws -> OfferedIssuanceModel {
        return try await cuckoo_manager.callThrows(
            "resolveOfferUrlDocTypes(offerUri p0: String) async throws -> OfferedIssuanceModel",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.resolveOfferUrlDocTypes(offerUri: p0)
        )
    }

    public func issueDocumentsByOfferUrl(offerUri p0: String, docTypes p1: [OfferedDocModel], txCodeValue p2: String?) async throws -> IssuanceResult {
        return try await cuckoo_manager.callThrows(
            "issueDocumentsByOfferUrl(offerUri p0: String, docTypes p1: [OfferedDocModel], txCodeValue p2: String?) async throws -> IssuanceResult",
            parameters: (p0, p1, p2),
            escapingParameters: (p0, p1, p2),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.issueDocumentsByOfferUrl(offerUri: p0, docTypes: p1, txCodeValue: p2)
        )
    }

    public func parseDocClaim(docId p0: String, groupId p1: String, docClaim p2: DocClaim, type p3: DocumentElementType, parser p4: (String) -> String) async -> [DocumentElementClaim] {
        
						return await withoutActuallyEscaping(p4, do: { (p4: @escaping (String) -> String) -> [DocumentElementClaim] in
return await cuckoo_manager.call(
            "parseDocClaim(docId p0: String, groupId p1: String, docClaim p2: DocClaim, type p3: DocumentElementType, parser p4: (String) -> String) async -> [DocumentElementClaim]",
            parameters: (p0, p1, p2, p3, p4),
            escapingParameters: (p0, p1, p2, p3, { _ in fatalError("This is a stub! It's not supposed to be called!") }),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.parseDocClaim(docId: p0, groupId: p1, docClaim: p2, type: p3, parser: p4)
        )
						})

    }

    public func retrieveLogFileUrl() async -> URL? {
        return await cuckoo_manager.call(
            "retrieveLogFileUrl() async -> URL?",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.retrieveLogFileUrl()
        )
    }

    public func resumePendingIssuance(pendingDoc p0: WalletStorage.Document, webUrl p1: URL?) async throws -> WalletStorage.Document {
        return try await cuckoo_manager.callThrows(
            "resumePendingIssuance(pendingDoc p0: WalletStorage.Document, webUrl p1: URL?) async throws -> WalletStorage.Document",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.resumePendingIssuance(pendingDoc: p0, webUrl: p1)
        )
    }

    public func storeDynamicIssuancePendingUrl(with p0: URL) async {
        return await cuckoo_manager.call(
            "storeDynamicIssuancePendingUrl(with p0: URL) async",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.storeDynamicIssuancePendingUrl(with: p0)
        )
    }

    public func getDynamicIssuancePendingData() async -> DynamicIssuancePendingData? {
        return await cuckoo_manager.call(
            "getDynamicIssuancePendingData() async -> DynamicIssuancePendingData?",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getDynamicIssuancePendingData()
        )
    }

    public func getScopedDocuments() async -> ScopedDocumentsResult {
        return await cuckoo_manager.call(
            "getScopedDocuments() async -> ScopedDocumentsResult",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getScopedDocuments()
        )
    }

    public func getDocumentCategories() async -> DocumentCategories {
        return await cuckoo_manager.call(
            "getDocumentCategories() async -> DocumentCategories",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getDocumentCategories()
        )
    }

    public func isDocumentBookmarked(with p0: String) async -> Bool {
        return await cuckoo_manager.call(
            "isDocumentBookmarked(with p0: String) async -> Bool",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.isDocumentBookmarked(with: p0)
        )
    }

    public func storeBookmarkedDocument(with p0: String) async throws {
        return try await cuckoo_manager.callThrows(
            "storeBookmarkedDocument(with p0: String) async throws",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.storeBookmarkedDocument(with: p0)
        )
    }

    public func removeBookmarkedDocument(with p0: String) async throws {
        return try await cuckoo_manager.callThrows(
            "removeBookmarkedDocument(with p0: String) async throws",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.removeBookmarkedDocument(with: p0)
        )
    }

    public func fetchTransactionLog(with p0: String) async throws -> TransactionLogDomain {
        return try await cuckoo_manager.callThrows(
            "fetchTransactionLog(with p0: String) async throws -> TransactionLogDomain",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.fetchTransactionLog(with: p0)
        )
    }

    public func fetchTransactionLogs() async throws -> [TransactionLogDomain] {
        return try await cuckoo_manager.callThrows(
            "fetchTransactionLogs() async throws -> [TransactionLogDomain]",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.fetchTransactionLogs()
        )
    }

    public func deleteAllRecords() async throws {
        return try await cuckoo_manager.callThrows(
            "deleteAllRecords() async throws",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.deleteAllRecords()
        )
    }

    public func fetchTransactionLogRevision() async -> String {
        return await cuckoo_manager.call(
            "fetchTransactionLogRevision() async -> String",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.fetchTransactionLogRevision()
        )
    }

    public func deleteTransactionLog(with p0: String) async throws {
        return try await cuckoo_manager.callThrows(
            "deleteTransactionLog(with p0: String) async throws",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.deleteTransactionLog(with: p0)
        )
    }

    public func fetchPresentationActions(parentPresentationId p0: String) async throws -> [TransactionLogDomain] {
        return try await cuckoo_manager.callThrows(
            "fetchPresentationActions(parentPresentationId p0: String) async throws -> [TransactionLogDomain]",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.fetchPresentationActions(parentPresentationId: p0)
        )
    }

    public func recordDataDeletionRequest(for p0: TransactionLogDomain.Presentation, contactUrl p1: URL) async throws {
        return try await cuckoo_manager.callThrows(
            "recordDataDeletionRequest(for p0: TransactionLogDomain.Presentation, contactUrl p1: URL) async throws",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.recordDataDeletionRequest(for: p0, contactUrl: p1)
        )
    }

    public func recordDpaReport(for p0: TransactionLogDomain.Presentation, contactUrl p1: URL) async throws {
        return try await cuckoo_manager.callThrows(
            "recordDpaReport(for p0: TransactionLogDomain.Presentation, contactUrl p1: URL) async throws",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.recordDpaReport(for: p0, contactUrl: p1)
        )
    }

    public func fetchRevokedDocumentStatuses() async throws -> [String: DocumentRevocationStatus] {
        return try await cuckoo_manager.callThrows(
            "fetchRevokedDocumentStatuses() async throws -> [String: DocumentRevocationStatus]",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.fetchRevokedDocumentStatuses()
        )
    }

    public func storeRevokedDocuments(with p0: [String: DocumentRevocationStatus]) async throws {
        return try await cuckoo_manager.callThrows(
            "storeRevokedDocuments(with p0: [String: DocumentRevocationStatus]) async throws",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.storeRevokedDocuments(with: p0)
        )
    }

    public func removeRevokedDocument(with p0: String) async throws {
        return try await cuckoo_manager.callThrows(
            "removeRevokedDocument(with p0: String) async throws",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.removeRevokedDocument(with: p0)
        )
    }

    public func getDocumentRevocationStatus(with p0: String) async -> DocumentRevocationStatus? {
        return await cuckoo_manager.call(
            "getDocumentRevocationStatus(with p0: String) async -> DocumentRevocationStatus?",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getDocumentRevocationStatus(with: p0)
        )
    }

    public func fetchStatusRefreshFailures() async throws -> Set<String> {
        return try await cuckoo_manager.callThrows(
            "fetchStatusRefreshFailures() async throws -> Set<String>",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.fetchStatusRefreshFailures()
        )
    }

    public func storeStatusRefreshFailures(ids p0: [String]) async throws {
        return try await cuckoo_manager.callThrows(
            "storeStatusRefreshFailures(ids p0: [String]) async throws",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.storeStatusRefreshFailures(ids: p0)
        )
    }

    public func removeStatusRefreshFailures(ids p0: [String]) async throws {
        return try await cuckoo_manager.callThrows(
            "removeStatusRefreshFailures(ids p0: [String]) async throws",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.removeStatusRefreshFailures(ids: p0)
        )
    }

    public func hasStatusRefreshFailure(with p0: String) async -> Bool {
        return await cuckoo_manager.call(
            "hasStatusRefreshFailure(with p0: String) async -> Bool",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.hasStatusRefreshFailure(with: p0)
        )
    }

    public func getDocumentStatus(for p0: MdocDataModel18013.StatusList) async throws -> CredentialStatus {
        return try await cuckoo_manager.callThrows(
            "getDocumentStatus(for p0: MdocDataModel18013.StatusList) async throws -> CredentialStatus",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getDocumentStatus(for: p0)
        )
    }

    public func isDocumentLowOnCredentials(document p0: (any DocClaimsDecodable)?) async -> Bool {
        return await cuckoo_manager.call(
            "isDocumentLowOnCredentials(document p0: (any DocClaimsDecodable)?) async -> Bool",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.isDocumentLowOnCredentials(document: p0)
        )
    }

    public func storeFailedReIssuedDocuments(ids p0: [String]) async throws {
        return try await cuckoo_manager.callThrows(
            "storeFailedReIssuedDocuments(ids p0: [String]) async throws",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.storeFailedReIssuedDocuments(ids: p0)
        )
    }

    public func removeAllFailedReIssuedDocuments() async throws {
        return try await cuckoo_manager.callThrows(
            "removeAllFailedReIssuedDocuments() async throws",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.removeAllFailedReIssuedDocuments()
        )
    }

    public func hasReIssuanceFailure(with p0: String) async -> Bool {
        return await cuckoo_manager.call(
            "hasReIssuanceFailure(with p0: String) async -> Bool",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.hasReIssuanceFailure(with: p0)
        )
    }

    public func refreshUsageCounters() async throws {
        return try await cuckoo_manager.callThrows(
            "refreshUsageCounters() async throws",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.refreshUsageCounters()
        )
    }

    public func getIssuerRegistration(for p0: OfferedIssuanceModel) async -> IssuerRegistration? {
        return await cuckoo_manager.call(
            "getIssuerRegistration(for p0: OfferedIssuanceModel) async -> IssuerRegistration?",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getIssuerRegistration(for: p0)
        )
    }

    public func reconcileRegistrations() async {
        return await cuckoo_manager.call(
            "reconcileRegistrations() async",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.reconcileRegistrations()
        )
    }

    public func issuerLogoOrigins() async -> IssuerLogoOrigins {
        return await cuckoo_manager.call(
            "issuerLogoOrigins() async -> IssuerLogoOrigins",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.issuerLogoOrigins()
        )
    }

    public func getIssuerRegistration(issuerId p0: String, configIds p1: [String]) async throws -> IssuerRegistration? {
        return try await cuckoo_manager.callThrows(
            "getIssuerRegistration(issuerId p0: String, configIds p1: [String]) async throws -> IssuerRegistration?",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getIssuerRegistration(issuerId: p0, configIds: p1)
        )
    }

    public func getVerifierRegistration(policy p0: WrpRegistrationPolicy?, trustViolations p1: [String], overaskedClaims p2: [logic_core.OveraskedClaim], verifierName p3: String?, verifierIsTrusted p4: Bool, isNotBoundToRequester p5: Bool, transactionIdentifier p6: String) async -> RelyingPartyRegistration {
        return await cuckoo_manager.call(
            "getVerifierRegistration(policy p0: WrpRegistrationPolicy?, trustViolations p1: [String], overaskedClaims p2: [logic_core.OveraskedClaim], verifierName p3: String?, verifierIsTrusted p4: Bool, isNotBoundToRequester p5: Bool, transactionIdentifier p6: String) async -> RelyingPartyRegistration",
            parameters: (p0, p1, p2, p3, p4, p5, p6),
            escapingParameters: (p0, p1, p2, p3, p4, p5, p6),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getVerifierRegistration(policy: p0, trustViolations: p1, overaskedClaims: p2, verifierName: p3, verifierIsTrusted: p4, isNotBoundToRequester: p5, transactionIdentifier: p6)
        )
    }

    public func getVerifierRegistrationForFailedRequest() async -> RelyingPartyRegistration? {
        return await cuckoo_manager.call(
            "getVerifierRegistrationForFailedRequest() async -> RelyingPartyRegistration?",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getVerifierRegistrationForFailedRequest()
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
        
        func startProximityPresentation() -> Cuckoo.ProtocolStubFunction<(), ProximitySessionCoordinator> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "startProximityPresentation() async -> ProximitySessionCoordinator",
                parameterMatchers: matchers
            ))
        }
        
        func startSameDevicePresentation<M1: Cuckoo.Matchable>(deepLink p0: M1) -> Cuckoo.ProtocolStubFunction<(URLComponents), RemoteSessionCoordinator> where M1.MatchedType == URLComponents {
            let matchers: [Cuckoo.ParameterMatcher<(URLComponents)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "startSameDevicePresentation(deepLink p0: URLComponents) async -> RemoteSessionCoordinator",
                parameterMatchers: matchers
            ))
        }
        
        func startCrossDevicePresentation<M1: Cuckoo.Matchable>(urlString p0: M1) -> Cuckoo.ProtocolStubFunction<(String), RemoteSessionCoordinator> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "startCrossDevicePresentation(urlString p0: String) async -> RemoteSessionCoordinator",
                parameterMatchers: matchers
            ))
        }
        
        func stopPresentation() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "stopPresentation() async",
                parameterMatchers: matchers
            ))
        }
        
        func stopRemotePresentation<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(RemoteSessionCoordinator)> where M1.MatchedType == RemoteSessionCoordinator {
            let matchers: [Cuckoo.ParameterMatcher<(RemoteSessionCoordinator)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "stopRemotePresentation(_ p0: RemoteSessionCoordinator) async",
                parameterMatchers: matchers
            ))
        }
        
        func stopProximityPresentation<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(ProximitySessionCoordinator)> where M1.MatchedType == ProximitySessionCoordinator {
            let matchers: [Cuckoo.ParameterMatcher<(ProximitySessionCoordinator)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "stopProximityPresentation(_ p0: ProximitySessionCoordinator) async",
                parameterMatchers: matchers
            ))
        }
        
        func fetchAllDocuments() -> Cuckoo.ProtocolStubFunction<(), [any DocClaimsDecodable]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "fetchAllDocuments() async -> [any DocClaimsDecodable]",
                parameterMatchers: matchers
            ))
        }
        
        func fetchDeferredDocuments() -> Cuckoo.ProtocolStubFunction<(), [WalletStorage.Document]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "fetchDeferredDocuments() async -> [WalletStorage.Document]",
                parameterMatchers: matchers
            ))
        }
        
        func fetchIssuedDocuments() -> Cuckoo.ProtocolStubFunction<(), [any DocClaimsDecodable]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "fetchIssuedDocuments() async -> [any DocClaimsDecodable]",
                parameterMatchers: matchers
            ))
        }
        
        func fetchIssuedDocuments<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubFunction<([DocumentTypeIdentifier]), [any DocClaimsDecodable]> where M1.MatchedType == [DocumentTypeIdentifier] {
            let matchers: [Cuckoo.ParameterMatcher<([DocumentTypeIdentifier])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "fetchIssuedDocuments(with p0: [DocumentTypeIdentifier]) async -> [any DocClaimsDecodable]",
                parameterMatchers: matchers
            ))
        }
        
        func fetchMainPidDocument() -> Cuckoo.ProtocolStubFunction<(), (any DocClaimsDecodable)?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "fetchMainPidDocument() async -> (any DocClaimsDecodable)?",
                parameterMatchers: matchers
            ))
        }
        
        func fetchDocument<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubFunction<(String), (any DocClaimsDecodable)?> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "fetchDocument(with p0: String) async -> (any DocClaimsDecodable)?",
                parameterMatchers: matchers
            ))
        }
        
        func fetchDocuments<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubFunction<([String]), [any DocClaimsDecodable]> where M1.MatchedType == [String] {
            let matchers: [Cuckoo.ParameterMatcher<([String])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "fetchDocuments(with p0: [String]) async -> [any DocClaimsDecodable]",
                parameterMatchers: matchers
            ))
        }
        
        func clearAllDocuments() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(),Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "clearAllDocuments() async throws",
                parameterMatchers: matchers
            ))
        }
        
        func deleteDocument<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(with p0: M1, status p1: M2) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(String, DocumentStatus),Swift.Error> where M1.MatchedType == String, M2.MatchedType == DocumentStatus {
            let matchers: [Cuckoo.ParameterMatcher<(String, DocumentStatus)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "deleteDocument(with p0: String, status p1: DocumentStatus) async throws",
                parameterMatchers: matchers
            ))
        }
        
        func loadDocuments() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(),Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "loadDocuments() async throws",
                parameterMatchers: matchers
            ))
        }
        
        func hasStoredDocuments() -> Cuckoo.ProtocolStubThrowingFunction<(), Bool,Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "hasStoredDocuments() async throws -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func issueDocuments<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(issuerId p0: M1, identifiers p1: M2, docTypeIdentifier p2: M3) -> Cuckoo.ProtocolStubThrowingFunction<(String, [String], DocumentTypeIdentifier), IssuanceResult,Swift.Error> where M1.MatchedType == String, M2.MatchedType == [String], M3.MatchedType == DocumentTypeIdentifier {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String], DocumentTypeIdentifier)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "issueDocuments(issuerId p0: String, identifiers p1: [String], docTypeIdentifier p2: DocumentTypeIdentifier) async throws -> IssuanceResult",
                parameterMatchers: matchers
            ))
        }
        
        func reIssueDocument<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(identifier p0: M1, isBackgroundOperation p1: M2) -> Cuckoo.ProtocolStubThrowingFunction<(String, Bool), WalletStorage.Document,Swift.Error> where M1.MatchedType == String, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(String, Bool)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "reIssueDocument(identifier p0: String, isBackgroundOperation p1: Bool) async throws -> WalletStorage.Document",
                parameterMatchers: matchers
            ))
        }
        
        func getDocumentCredentialOptions<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubFunction<(String), CredentialOptions?> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "getDocumentCredentialOptions(with p0: String) async -> CredentialOptions?",
                parameterMatchers: matchers
            ))
        }
        
        func requestDeferredIssuance<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubThrowingFunction<(WalletStorage.Document), any DocClaimsDecodable,Swift.Error> where M1.MatchedType == WalletStorage.Document {
            let matchers: [Cuckoo.ParameterMatcher<(WalletStorage.Document)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "requestDeferredIssuance(with p0: WalletStorage.Document) async throws -> any DocClaimsDecodable",
                parameterMatchers: matchers
            ))
        }
        
        func resolveOfferUrlDocTypes<M1: Cuckoo.Matchable>(offerUri p0: M1) -> Cuckoo.ProtocolStubThrowingFunction<(String), OfferedIssuanceModel,Swift.Error> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "resolveOfferUrlDocTypes(offerUri p0: String) async throws -> OfferedIssuanceModel",
                parameterMatchers: matchers
            ))
        }
        
        func issueDocumentsByOfferUrl<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable>(offerUri p0: M1, docTypes p1: M2, txCodeValue p2: M3) -> Cuckoo.ProtocolStubThrowingFunction<(String, [OfferedDocModel], String?), IssuanceResult,Swift.Error> where M1.MatchedType == String, M2.MatchedType == [OfferedDocModel], M3.OptionalMatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, [OfferedDocModel], String?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "issueDocumentsByOfferUrl(offerUri p0: String, docTypes p1: [OfferedDocModel], txCodeValue p2: String?) async throws -> IssuanceResult",
                parameterMatchers: matchers
            ))
        }
        
        func parseDocClaim<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(docId p0: M1, groupId p1: M2, docClaim p2: M3, type p3: M4, parser p4: M5) -> Cuckoo.ProtocolStubFunction<(String, String, DocClaim, DocumentElementType, (String) -> String), [DocumentElementClaim]> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == DocClaim, M4.MatchedType == DocumentElementType, M5.MatchedType == (String) -> String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String, DocClaim, DocumentElementType, (String) -> String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }, wrap(matchable: p4) { $0.4 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "parseDocClaim(docId p0: String, groupId p1: String, docClaim p2: DocClaim, type p3: DocumentElementType, parser p4: (String) -> String) async -> [DocumentElementClaim]",
                parameterMatchers: matchers
            ))
        }
        
        func retrieveLogFileUrl() -> Cuckoo.ProtocolStubFunction<(), URL?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "retrieveLogFileUrl() async -> URL?",
                parameterMatchers: matchers
            ))
        }
        
        func resumePendingIssuance<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(pendingDoc p0: M1, webUrl p1: M2) -> Cuckoo.ProtocolStubThrowingFunction<(WalletStorage.Document, URL?), WalletStorage.Document,Swift.Error> where M1.MatchedType == WalletStorage.Document, M2.OptionalMatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(WalletStorage.Document, URL?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "resumePendingIssuance(pendingDoc p0: WalletStorage.Document, webUrl p1: URL?) async throws -> WalletStorage.Document",
                parameterMatchers: matchers
            ))
        }
        
        func storeDynamicIssuancePendingUrl<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(URL)> where M1.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(URL)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "storeDynamicIssuancePendingUrl(with p0: URL) async",
                parameterMatchers: matchers
            ))
        }
        
        func getDynamicIssuancePendingData() -> Cuckoo.ProtocolStubFunction<(), DynamicIssuancePendingData?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "getDynamicIssuancePendingData() async -> DynamicIssuancePendingData?",
                parameterMatchers: matchers
            ))
        }
        
        func getScopedDocuments() -> Cuckoo.ProtocolStubFunction<(), ScopedDocumentsResult> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "getScopedDocuments() async -> ScopedDocumentsResult",
                parameterMatchers: matchers
            ))
        }
        
        func getDocumentCategories() -> Cuckoo.ProtocolStubFunction<(), DocumentCategories> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "getDocumentCategories() async -> DocumentCategories",
                parameterMatchers: matchers
            ))
        }
        
        func isDocumentBookmarked<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubFunction<(String), Bool> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "isDocumentBookmarked(with p0: String) async -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func storeBookmarkedDocument<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(String),Swift.Error> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "storeBookmarkedDocument(with p0: String) async throws",
                parameterMatchers: matchers
            ))
        }
        
        func removeBookmarkedDocument<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(String),Swift.Error> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "removeBookmarkedDocument(with p0: String) async throws",
                parameterMatchers: matchers
            ))
        }
        
        func fetchTransactionLog<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubThrowingFunction<(String), TransactionLogDomain,Swift.Error> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "fetchTransactionLog(with p0: String) async throws -> TransactionLogDomain",
                parameterMatchers: matchers
            ))
        }
        
        func fetchTransactionLogs() -> Cuckoo.ProtocolStubThrowingFunction<(), [TransactionLogDomain],Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "fetchTransactionLogs() async throws -> [TransactionLogDomain]",
                parameterMatchers: matchers
            ))
        }
        
        func deleteAllRecords() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(),Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "deleteAllRecords() async throws",
                parameterMatchers: matchers
            ))
        }
        
        func fetchTransactionLogRevision() -> Cuckoo.ProtocolStubFunction<(), String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "fetchTransactionLogRevision() async -> String",
                parameterMatchers: matchers
            ))
        }
        
        func deleteTransactionLog<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(String),Swift.Error> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "deleteTransactionLog(with p0: String) async throws",
                parameterMatchers: matchers
            ))
        }
        
        func fetchPresentationActions<M1: Cuckoo.Matchable>(parentPresentationId p0: M1) -> Cuckoo.ProtocolStubThrowingFunction<(String), [TransactionLogDomain],Swift.Error> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "fetchPresentationActions(parentPresentationId p0: String) async throws -> [TransactionLogDomain]",
                parameterMatchers: matchers
            ))
        }
        
        func recordDataDeletionRequest<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(for p0: M1, contactUrl p1: M2) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(TransactionLogDomain.Presentation, URL),Swift.Error> where M1.MatchedType == TransactionLogDomain.Presentation, M2.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(TransactionLogDomain.Presentation, URL)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "recordDataDeletionRequest(for p0: TransactionLogDomain.Presentation, contactUrl p1: URL) async throws",
                parameterMatchers: matchers
            ))
        }
        
        func recordDpaReport<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(for p0: M1, contactUrl p1: M2) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(TransactionLogDomain.Presentation, URL),Swift.Error> where M1.MatchedType == TransactionLogDomain.Presentation, M2.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(TransactionLogDomain.Presentation, URL)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "recordDpaReport(for p0: TransactionLogDomain.Presentation, contactUrl p1: URL) async throws",
                parameterMatchers: matchers
            ))
        }
        
        func fetchRevokedDocumentStatuses() -> Cuckoo.ProtocolStubThrowingFunction<(), [String: DocumentRevocationStatus],Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "fetchRevokedDocumentStatuses() async throws -> [String: DocumentRevocationStatus]",
                parameterMatchers: matchers
            ))
        }
        
        func storeRevokedDocuments<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<([String: DocumentRevocationStatus]),Swift.Error> where M1.MatchedType == [String: DocumentRevocationStatus] {
            let matchers: [Cuckoo.ParameterMatcher<([String: DocumentRevocationStatus])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "storeRevokedDocuments(with p0: [String: DocumentRevocationStatus]) async throws",
                parameterMatchers: matchers
            ))
        }
        
        func removeRevokedDocument<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(String),Swift.Error> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "removeRevokedDocument(with p0: String) async throws",
                parameterMatchers: matchers
            ))
        }
        
        func getDocumentRevocationStatus<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubFunction<(String), DocumentRevocationStatus?> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "getDocumentRevocationStatus(with p0: String) async -> DocumentRevocationStatus?",
                parameterMatchers: matchers
            ))
        }
        
        func fetchStatusRefreshFailures() -> Cuckoo.ProtocolStubThrowingFunction<(), Set<String>,Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "fetchStatusRefreshFailures() async throws -> Set<String>",
                parameterMatchers: matchers
            ))
        }
        
        func storeStatusRefreshFailures<M1: Cuckoo.Matchable>(ids p0: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<([String]),Swift.Error> where M1.MatchedType == [String] {
            let matchers: [Cuckoo.ParameterMatcher<([String])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "storeStatusRefreshFailures(ids p0: [String]) async throws",
                parameterMatchers: matchers
            ))
        }
        
        func removeStatusRefreshFailures<M1: Cuckoo.Matchable>(ids p0: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<([String]),Swift.Error> where M1.MatchedType == [String] {
            let matchers: [Cuckoo.ParameterMatcher<([String])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "removeStatusRefreshFailures(ids p0: [String]) async throws",
                parameterMatchers: matchers
            ))
        }
        
        func hasStatusRefreshFailure<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubFunction<(String), Bool> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "hasStatusRefreshFailure(with p0: String) async -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func getDocumentStatus<M1: Cuckoo.Matchable>(for p0: M1) -> Cuckoo.ProtocolStubThrowingFunction<(MdocDataModel18013.StatusList), CredentialStatus,Swift.Error> where M1.MatchedType == MdocDataModel18013.StatusList {
            let matchers: [Cuckoo.ParameterMatcher<(MdocDataModel18013.StatusList)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "getDocumentStatus(for p0: MdocDataModel18013.StatusList) async throws -> CredentialStatus",
                parameterMatchers: matchers
            ))
        }
        
        func isDocumentLowOnCredentials<M1: Cuckoo.OptionalMatchable>(document p0: M1) -> Cuckoo.ProtocolStubFunction<((any DocClaimsDecodable)?), Bool> where M1.OptionalMatchedType == (any DocClaimsDecodable) {
            let matchers: [Cuckoo.ParameterMatcher<((any DocClaimsDecodable)?)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "isDocumentLowOnCredentials(document p0: (any DocClaimsDecodable)?) async -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func storeFailedReIssuedDocuments<M1: Cuckoo.Matchable>(ids p0: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<([String]),Swift.Error> where M1.MatchedType == [String] {
            let matchers: [Cuckoo.ParameterMatcher<([String])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "storeFailedReIssuedDocuments(ids p0: [String]) async throws",
                parameterMatchers: matchers
            ))
        }
        
        func removeAllFailedReIssuedDocuments() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(),Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "removeAllFailedReIssuedDocuments() async throws",
                parameterMatchers: matchers
            ))
        }
        
        func hasReIssuanceFailure<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.ProtocolStubFunction<(String), Bool> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "hasReIssuanceFailure(with p0: String) async -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func refreshUsageCounters() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(),Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "refreshUsageCounters() async throws",
                parameterMatchers: matchers
            ))
        }
        
        func getIssuerRegistration<M1: Cuckoo.Matchable>(for p0: M1) -> Cuckoo.ProtocolStubFunction<(OfferedIssuanceModel), IssuerRegistration?> where M1.MatchedType == OfferedIssuanceModel {
            let matchers: [Cuckoo.ParameterMatcher<(OfferedIssuanceModel)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "getIssuerRegistration(for p0: OfferedIssuanceModel) async -> IssuerRegistration?",
                parameterMatchers: matchers
            ))
        }
        
        func reconcileRegistrations() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "reconcileRegistrations() async",
                parameterMatchers: matchers
            ))
        }
        
        func issuerLogoOrigins() -> Cuckoo.ProtocolStubFunction<(), IssuerLogoOrigins> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "issuerLogoOrigins() async -> IssuerLogoOrigins",
                parameterMatchers: matchers
            ))
        }
        
        func getIssuerRegistration<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(issuerId p0: M1, configIds p1: M2) -> Cuckoo.ProtocolStubThrowingFunction<(String, [String]), IssuerRegistration?,Swift.Error> where M1.MatchedType == String, M2.MatchedType == [String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String])>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "getIssuerRegistration(issuerId p0: String, configIds p1: [String]) async throws -> IssuerRegistration?",
                parameterMatchers: matchers
            ))
        }
        
        func getVerifierRegistration<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.OptionalMatchable, M5: Cuckoo.Matchable, M6: Cuckoo.Matchable, M7: Cuckoo.Matchable>(policy p0: M1, trustViolations p1: M2, overaskedClaims p2: M3, verifierName p3: M4, verifierIsTrusted p4: M5, isNotBoundToRequester p5: M6, transactionIdentifier p6: M7) -> Cuckoo.ProtocolStubFunction<(WrpRegistrationPolicy?, [String], [logic_core.OveraskedClaim], String?, Bool, Bool, String), RelyingPartyRegistration> where M1.OptionalMatchedType == WrpRegistrationPolicy, M2.MatchedType == [String], M3.MatchedType == [logic_core.OveraskedClaim], M4.OptionalMatchedType == String, M5.MatchedType == Bool, M6.MatchedType == Bool, M7.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(WrpRegistrationPolicy?, [String], [logic_core.OveraskedClaim], String?, Bool, Bool, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }, wrap(matchable: p4) { $0.4 }, wrap(matchable: p5) { $0.5 }, wrap(matchable: p6) { $0.6 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "getVerifierRegistration(policy p0: WrpRegistrationPolicy?, trustViolations p1: [String], overaskedClaims p2: [logic_core.OveraskedClaim], verifierName p3: String?, verifierIsTrusted p4: Bool, isNotBoundToRequester p5: Bool, transactionIdentifier p6: String) async -> RelyingPartyRegistration",
                parameterMatchers: matchers
            ))
        }
        
        func getVerifierRegistrationForFailedRequest() -> Cuckoo.ProtocolStubFunction<(), RelyingPartyRegistration?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitController.self,
                method: "getVerifierRegistrationForFailedRequest() async -> RelyingPartyRegistration?",
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
        
        
        @discardableResult
        func startProximityPresentation() -> Cuckoo.__DoNotUse<(), ProximitySessionCoordinator> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "startProximityPresentation() async -> ProximitySessionCoordinator",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func startSameDevicePresentation<M1: Cuckoo.Matchable>(deepLink p0: M1) -> Cuckoo.__DoNotUse<(URLComponents), RemoteSessionCoordinator> where M1.MatchedType == URLComponents {
            let matchers: [Cuckoo.ParameterMatcher<(URLComponents)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "startSameDevicePresentation(deepLink p0: URLComponents) async -> RemoteSessionCoordinator",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func startCrossDevicePresentation<M1: Cuckoo.Matchable>(urlString p0: M1) -> Cuckoo.__DoNotUse<(String), RemoteSessionCoordinator> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "startCrossDevicePresentation(urlString p0: String) async -> RemoteSessionCoordinator",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stopPresentation() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stopPresentation() async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stopRemotePresentation<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.__DoNotUse<(RemoteSessionCoordinator), Void> where M1.MatchedType == RemoteSessionCoordinator {
            let matchers: [Cuckoo.ParameterMatcher<(RemoteSessionCoordinator)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "stopRemotePresentation(_ p0: RemoteSessionCoordinator) async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stopProximityPresentation<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.__DoNotUse<(ProximitySessionCoordinator), Void> where M1.MatchedType == ProximitySessionCoordinator {
            let matchers: [Cuckoo.ParameterMatcher<(ProximitySessionCoordinator)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "stopProximityPresentation(_ p0: ProximitySessionCoordinator) async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func fetchAllDocuments() -> Cuckoo.__DoNotUse<(), [any DocClaimsDecodable]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "fetchAllDocuments() async -> [any DocClaimsDecodable]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func fetchDeferredDocuments() -> Cuckoo.__DoNotUse<(), [WalletStorage.Document]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "fetchDeferredDocuments() async -> [WalletStorage.Document]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func fetchIssuedDocuments() -> Cuckoo.__DoNotUse<(), [any DocClaimsDecodable]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "fetchIssuedDocuments() async -> [any DocClaimsDecodable]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func fetchIssuedDocuments<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<([DocumentTypeIdentifier]), [any DocClaimsDecodable]> where M1.MatchedType == [DocumentTypeIdentifier] {
            let matchers: [Cuckoo.ParameterMatcher<([DocumentTypeIdentifier])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "fetchIssuedDocuments(with p0: [DocumentTypeIdentifier]) async -> [any DocClaimsDecodable]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func fetchMainPidDocument() -> Cuckoo.__DoNotUse<(), (any DocClaimsDecodable)?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "fetchMainPidDocument() async -> (any DocClaimsDecodable)?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func fetchDocument<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(String), (any DocClaimsDecodable)?> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "fetchDocument(with p0: String) async -> (any DocClaimsDecodable)?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func fetchDocuments<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<([String]), [any DocClaimsDecodable]> where M1.MatchedType == [String] {
            let matchers: [Cuckoo.ParameterMatcher<([String])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "fetchDocuments(with p0: [String]) async -> [any DocClaimsDecodable]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func clearAllDocuments() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "clearAllDocuments() async throws",
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
        func hasStoredDocuments() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "hasStoredDocuments() async throws -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func issueDocuments<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(issuerId p0: M1, identifiers p1: M2, docTypeIdentifier p2: M3) -> Cuckoo.__DoNotUse<(String, [String], DocumentTypeIdentifier), IssuanceResult> where M1.MatchedType == String, M2.MatchedType == [String], M3.MatchedType == DocumentTypeIdentifier {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String], DocumentTypeIdentifier)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return cuckoo_manager.verify(
                "issueDocuments(issuerId p0: String, identifiers p1: [String], docTypeIdentifier p2: DocumentTypeIdentifier) async throws -> IssuanceResult",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func reIssueDocument<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(identifier p0: M1, isBackgroundOperation p1: M2) -> Cuckoo.__DoNotUse<(String, Bool), WalletStorage.Document> where M1.MatchedType == String, M2.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(String, Bool)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "reIssueDocument(identifier p0: String, isBackgroundOperation p1: Bool) async throws -> WalletStorage.Document",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getDocumentCredentialOptions<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(String), CredentialOptions?> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "getDocumentCredentialOptions(with p0: String) async -> CredentialOptions?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func requestDeferredIssuance<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(WalletStorage.Document), any DocClaimsDecodable> where M1.MatchedType == WalletStorage.Document {
            let matchers: [Cuckoo.ParameterMatcher<(WalletStorage.Document)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "requestDeferredIssuance(with p0: WalletStorage.Document) async throws -> any DocClaimsDecodable",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func resolveOfferUrlDocTypes<M1: Cuckoo.Matchable>(offerUri p0: M1) -> Cuckoo.__DoNotUse<(String), OfferedIssuanceModel> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "resolveOfferUrlDocTypes(offerUri p0: String) async throws -> OfferedIssuanceModel",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func issueDocumentsByOfferUrl<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable>(offerUri p0: M1, docTypes p1: M2, txCodeValue p2: M3) -> Cuckoo.__DoNotUse<(String, [OfferedDocModel], String?), IssuanceResult> where M1.MatchedType == String, M2.MatchedType == [OfferedDocModel], M3.OptionalMatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, [OfferedDocModel], String?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return cuckoo_manager.verify(
                "issueDocumentsByOfferUrl(offerUri p0: String, docTypes p1: [OfferedDocModel], txCodeValue p2: String?) async throws -> IssuanceResult",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func parseDocClaim<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable, M5: Cuckoo.Matchable>(docId p0: M1, groupId p1: M2, docClaim p2: M3, type p3: M4, parser p4: M5) -> Cuckoo.__DoNotUse<(String, String, DocClaim, DocumentElementType, (String) -> String), [DocumentElementClaim]> where M1.MatchedType == String, M2.MatchedType == String, M3.MatchedType == DocClaim, M4.MatchedType == DocumentElementType, M5.MatchedType == (String) -> String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String, DocClaim, DocumentElementType, (String) -> String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }, wrap(matchable: p4) { $0.4 }]
            return cuckoo_manager.verify(
                "parseDocClaim(docId p0: String, groupId p1: String, docClaim p2: DocClaim, type p3: DocumentElementType, parser p4: (String) -> String) async -> [DocumentElementClaim]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func retrieveLogFileUrl() -> Cuckoo.__DoNotUse<(), URL?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "retrieveLogFileUrl() async -> URL?",
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
                "storeDynamicIssuancePendingUrl(with p0: URL) async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getDynamicIssuancePendingData() -> Cuckoo.__DoNotUse<(), DynamicIssuancePendingData?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getDynamicIssuancePendingData() async -> DynamicIssuancePendingData?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getScopedDocuments() -> Cuckoo.__DoNotUse<(), ScopedDocumentsResult> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getScopedDocuments() async -> ScopedDocumentsResult",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getDocumentCategories() -> Cuckoo.__DoNotUse<(), DocumentCategories> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getDocumentCategories() async -> DocumentCategories",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func isDocumentBookmarked<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(String), Bool> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "isDocumentBookmarked(with p0: String) async -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func storeBookmarkedDocument<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "storeBookmarkedDocument(with p0: String) async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func removeBookmarkedDocument<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "removeBookmarkedDocument(with p0: String) async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func fetchTransactionLog<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(String), TransactionLogDomain> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "fetchTransactionLog(with p0: String) async throws -> TransactionLogDomain",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func fetchTransactionLogs() -> Cuckoo.__DoNotUse<(), [TransactionLogDomain]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "fetchTransactionLogs() async throws -> [TransactionLogDomain]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func deleteAllRecords() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "deleteAllRecords() async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func fetchTransactionLogRevision() -> Cuckoo.__DoNotUse<(), String> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "fetchTransactionLogRevision() async -> String",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func deleteTransactionLog<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "deleteTransactionLog(with p0: String) async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func fetchPresentationActions<M1: Cuckoo.Matchable>(parentPresentationId p0: M1) -> Cuckoo.__DoNotUse<(String), [TransactionLogDomain]> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "fetchPresentationActions(parentPresentationId p0: String) async throws -> [TransactionLogDomain]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func recordDataDeletionRequest<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(for p0: M1, contactUrl p1: M2) -> Cuckoo.__DoNotUse<(TransactionLogDomain.Presentation, URL), Void> where M1.MatchedType == TransactionLogDomain.Presentation, M2.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(TransactionLogDomain.Presentation, URL)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "recordDataDeletionRequest(for p0: TransactionLogDomain.Presentation, contactUrl p1: URL) async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func recordDpaReport<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(for p0: M1, contactUrl p1: M2) -> Cuckoo.__DoNotUse<(TransactionLogDomain.Presentation, URL), Void> where M1.MatchedType == TransactionLogDomain.Presentation, M2.MatchedType == URL {
            let matchers: [Cuckoo.ParameterMatcher<(TransactionLogDomain.Presentation, URL)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "recordDpaReport(for p0: TransactionLogDomain.Presentation, contactUrl p1: URL) async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func fetchRevokedDocumentStatuses() -> Cuckoo.__DoNotUse<(), [String: DocumentRevocationStatus]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "fetchRevokedDocumentStatuses() async throws -> [String: DocumentRevocationStatus]",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func storeRevokedDocuments<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<([String: DocumentRevocationStatus]), Void> where M1.MatchedType == [String: DocumentRevocationStatus] {
            let matchers: [Cuckoo.ParameterMatcher<([String: DocumentRevocationStatus])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "storeRevokedDocuments(with p0: [String: DocumentRevocationStatus]) async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func removeRevokedDocument<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "removeRevokedDocument(with p0: String) async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getDocumentRevocationStatus<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(String), DocumentRevocationStatus?> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "getDocumentRevocationStatus(with p0: String) async -> DocumentRevocationStatus?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func fetchStatusRefreshFailures() -> Cuckoo.__DoNotUse<(), Set<String>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "fetchStatusRefreshFailures() async throws -> Set<String>",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func storeStatusRefreshFailures<M1: Cuckoo.Matchable>(ids p0: M1) -> Cuckoo.__DoNotUse<([String]), Void> where M1.MatchedType == [String] {
            let matchers: [Cuckoo.ParameterMatcher<([String])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "storeStatusRefreshFailures(ids p0: [String]) async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func removeStatusRefreshFailures<M1: Cuckoo.Matchable>(ids p0: M1) -> Cuckoo.__DoNotUse<([String]), Void> where M1.MatchedType == [String] {
            let matchers: [Cuckoo.ParameterMatcher<([String])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "removeStatusRefreshFailures(ids p0: [String]) async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func hasStatusRefreshFailure<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(String), Bool> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "hasStatusRefreshFailure(with p0: String) async -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getDocumentStatus<M1: Cuckoo.Matchable>(for p0: M1) -> Cuckoo.__DoNotUse<(MdocDataModel18013.StatusList), CredentialStatus> where M1.MatchedType == MdocDataModel18013.StatusList {
            let matchers: [Cuckoo.ParameterMatcher<(MdocDataModel18013.StatusList)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "getDocumentStatus(for p0: MdocDataModel18013.StatusList) async throws -> CredentialStatus",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func isDocumentLowOnCredentials<M1: Cuckoo.OptionalMatchable>(document p0: M1) -> Cuckoo.__DoNotUse<((any DocClaimsDecodable)?), Bool> where M1.OptionalMatchedType == (any DocClaimsDecodable) {
            let matchers: [Cuckoo.ParameterMatcher<((any DocClaimsDecodable)?)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "isDocumentLowOnCredentials(document p0: (any DocClaimsDecodable)?) async -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func storeFailedReIssuedDocuments<M1: Cuckoo.Matchable>(ids p0: M1) -> Cuckoo.__DoNotUse<([String]), Void> where M1.MatchedType == [String] {
            let matchers: [Cuckoo.ParameterMatcher<([String])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "storeFailedReIssuedDocuments(ids p0: [String]) async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func removeAllFailedReIssuedDocuments() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "removeAllFailedReIssuedDocuments() async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func hasReIssuanceFailure<M1: Cuckoo.Matchable>(with p0: M1) -> Cuckoo.__DoNotUse<(String), Bool> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "hasReIssuanceFailure(with p0: String) async -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func refreshUsageCounters() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "refreshUsageCounters() async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getIssuerRegistration<M1: Cuckoo.Matchable>(for p0: M1) -> Cuckoo.__DoNotUse<(OfferedIssuanceModel), IssuerRegistration?> where M1.MatchedType == OfferedIssuanceModel {
            let matchers: [Cuckoo.ParameterMatcher<(OfferedIssuanceModel)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "getIssuerRegistration(for p0: OfferedIssuanceModel) async -> IssuerRegistration?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func reconcileRegistrations() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "reconcileRegistrations() async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func issuerLogoOrigins() -> Cuckoo.__DoNotUse<(), IssuerLogoOrigins> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "issuerLogoOrigins() async -> IssuerLogoOrigins",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getIssuerRegistration<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(issuerId p0: M1, configIds p1: M2) -> Cuckoo.__DoNotUse<(String, [String]), IssuerRegistration?> where M1.MatchedType == String, M2.MatchedType == [String] {
            let matchers: [Cuckoo.ParameterMatcher<(String, [String])>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "getIssuerRegistration(issuerId p0: String, configIds p1: [String]) async throws -> IssuerRegistration?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getVerifierRegistration<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.OptionalMatchable, M5: Cuckoo.Matchable, M6: Cuckoo.Matchable, M7: Cuckoo.Matchable>(policy p0: M1, trustViolations p1: M2, overaskedClaims p2: M3, verifierName p3: M4, verifierIsTrusted p4: M5, isNotBoundToRequester p5: M6, transactionIdentifier p6: M7) -> Cuckoo.__DoNotUse<(WrpRegistrationPolicy?, [String], [logic_core.OveraskedClaim], String?, Bool, Bool, String), RelyingPartyRegistration> where M1.OptionalMatchedType == WrpRegistrationPolicy, M2.MatchedType == [String], M3.MatchedType == [logic_core.OveraskedClaim], M4.OptionalMatchedType == String, M5.MatchedType == Bool, M6.MatchedType == Bool, M7.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(WrpRegistrationPolicy?, [String], [logic_core.OveraskedClaim], String?, Bool, Bool, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }, wrap(matchable: p3) { $0.3 }, wrap(matchable: p4) { $0.4 }, wrap(matchable: p5) { $0.5 }, wrap(matchable: p6) { $0.6 }]
            return cuckoo_manager.verify(
                "getVerifierRegistration(policy p0: WrpRegistrationPolicy?, trustViolations p1: [String], overaskedClaims p2: [logic_core.OveraskedClaim], verifierName p3: String?, verifierIsTrusted p4: Bool, isNotBoundToRequester p5: Bool, transactionIdentifier p6: String) async -> RelyingPartyRegistration",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getVerifierRegistrationForFailedRequest() -> Cuckoo.__DoNotUse<(), RelyingPartyRegistration?> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getVerifierRegistrationForFailedRequest() async -> RelyingPartyRegistration?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class WalletKitControllerStub:WalletKitController, @unchecked Sendable {
    
    public var wallet: EudiWallet {
        get {
            return DefaultValueRegistry.defaultValue(for: (EudiWallet).self)
        }
    }


    
    public func startProximityPresentation() async -> ProximitySessionCoordinator {
        return DefaultValueRegistry.defaultValue(for: (ProximitySessionCoordinator).self)
    }
    
    public func startSameDevicePresentation(deepLink p0: URLComponents) async -> RemoteSessionCoordinator {
        return DefaultValueRegistry.defaultValue(for: (RemoteSessionCoordinator).self)
    }
    
    public func startCrossDevicePresentation(urlString p0: String) async -> RemoteSessionCoordinator {
        return DefaultValueRegistry.defaultValue(for: (RemoteSessionCoordinator).self)
    }
    
    public func stopPresentation() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func stopRemotePresentation(_ p0: RemoteSessionCoordinator) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func stopProximityPresentation(_ p0: ProximitySessionCoordinator) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func fetchAllDocuments() async -> [any DocClaimsDecodable] {
        return DefaultValueRegistry.defaultValue(for: ([any DocClaimsDecodable]).self)
    }
    
    public func fetchDeferredDocuments() async -> [WalletStorage.Document] {
        return DefaultValueRegistry.defaultValue(for: ([WalletStorage.Document]).self)
    }
    
    public func fetchIssuedDocuments() async -> [any DocClaimsDecodable] {
        return DefaultValueRegistry.defaultValue(for: ([any DocClaimsDecodable]).self)
    }
    
    public func fetchIssuedDocuments(with p0: [DocumentTypeIdentifier]) async -> [any DocClaimsDecodable] {
        return DefaultValueRegistry.defaultValue(for: ([any DocClaimsDecodable]).self)
    }
    
    public func fetchMainPidDocument() async -> (any DocClaimsDecodable)? {
        return DefaultValueRegistry.defaultValue(for: ((any DocClaimsDecodable)?).self)
    }
    
    public func fetchDocument(with p0: String) async -> (any DocClaimsDecodable)? {
        return DefaultValueRegistry.defaultValue(for: ((any DocClaimsDecodable)?).self)
    }
    
    public func fetchDocuments(with p0: [String]) async -> [any DocClaimsDecodable] {
        return DefaultValueRegistry.defaultValue(for: ([any DocClaimsDecodable]).self)
    }
    
    public func clearAllDocuments() async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func deleteDocument(with p0: String, status p1: DocumentStatus) async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func loadDocuments() async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func hasStoredDocuments() async throws -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func issueDocuments(issuerId p0: String, identifiers p1: [String], docTypeIdentifier p2: DocumentTypeIdentifier) async throws -> IssuanceResult {
        return DefaultValueRegistry.defaultValue(for: (IssuanceResult).self)
    }
    
    public func reIssueDocument(identifier p0: String, isBackgroundOperation p1: Bool) async throws -> WalletStorage.Document {
        return DefaultValueRegistry.defaultValue(for: (WalletStorage.Document).self)
    }
    
    public func getDocumentCredentialOptions(with p0: String) async -> CredentialOptions? {
        return DefaultValueRegistry.defaultValue(for: (CredentialOptions?).self)
    }
    
    public func requestDeferredIssuance(with p0: WalletStorage.Document) async throws -> any DocClaimsDecodable {
        return DefaultValueRegistry.defaultValue(for: (any DocClaimsDecodable).self)
    }
    
    public func resolveOfferUrlDocTypes(offerUri p0: String) async throws -> OfferedIssuanceModel {
        return DefaultValueRegistry.defaultValue(for: (OfferedIssuanceModel).self)
    }
    
    public func issueDocumentsByOfferUrl(offerUri p0: String, docTypes p1: [OfferedDocModel], txCodeValue p2: String?) async throws -> IssuanceResult {
        return DefaultValueRegistry.defaultValue(for: (IssuanceResult).self)
    }
    
    public func parseDocClaim(docId p0: String, groupId p1: String, docClaim p2: DocClaim, type p3: DocumentElementType, parser p4: (String) -> String) async -> [DocumentElementClaim] {
        return DefaultValueRegistry.defaultValue(for: ([DocumentElementClaim]).self)
    }
    
    public func retrieveLogFileUrl() async -> URL? {
        return DefaultValueRegistry.defaultValue(for: (URL?).self)
    }
    
    public func resumePendingIssuance(pendingDoc p0: WalletStorage.Document, webUrl p1: URL?) async throws -> WalletStorage.Document {
        return DefaultValueRegistry.defaultValue(for: (WalletStorage.Document).self)
    }
    
    public func storeDynamicIssuancePendingUrl(with p0: URL) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getDynamicIssuancePendingData() async -> DynamicIssuancePendingData? {
        return DefaultValueRegistry.defaultValue(for: (DynamicIssuancePendingData?).self)
    }
    
    public func getScopedDocuments() async -> ScopedDocumentsResult {
        return DefaultValueRegistry.defaultValue(for: (ScopedDocumentsResult).self)
    }
    
    public func getDocumentCategories() async -> DocumentCategories {
        return DefaultValueRegistry.defaultValue(for: (DocumentCategories).self)
    }
    
    public func isDocumentBookmarked(with p0: String) async -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func storeBookmarkedDocument(with p0: String) async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func removeBookmarkedDocument(with p0: String) async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func fetchTransactionLog(with p0: String) async throws -> TransactionLogDomain {
        return DefaultValueRegistry.defaultValue(for: (TransactionLogDomain).self)
    }
    
    public func fetchTransactionLogs() async throws -> [TransactionLogDomain] {
        return DefaultValueRegistry.defaultValue(for: ([TransactionLogDomain]).self)
    }
    
    public func deleteAllRecords() async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func fetchTransactionLogRevision() async -> String {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
    
    public func deleteTransactionLog(with p0: String) async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func fetchPresentationActions(parentPresentationId p0: String) async throws -> [TransactionLogDomain] {
        return DefaultValueRegistry.defaultValue(for: ([TransactionLogDomain]).self)
    }
    
    public func recordDataDeletionRequest(for p0: TransactionLogDomain.Presentation, contactUrl p1: URL) async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func recordDpaReport(for p0: TransactionLogDomain.Presentation, contactUrl p1: URL) async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func fetchRevokedDocumentStatuses() async throws -> [String: DocumentRevocationStatus] {
        return DefaultValueRegistry.defaultValue(for: ([String: DocumentRevocationStatus]).self)
    }
    
    public func storeRevokedDocuments(with p0: [String: DocumentRevocationStatus]) async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func removeRevokedDocument(with p0: String) async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getDocumentRevocationStatus(with p0: String) async -> DocumentRevocationStatus? {
        return DefaultValueRegistry.defaultValue(for: (DocumentRevocationStatus?).self)
    }
    
    public func fetchStatusRefreshFailures() async throws -> Set<String> {
        return DefaultValueRegistry.defaultValue(for: (Set<String>).self)
    }
    
    public func storeStatusRefreshFailures(ids p0: [String]) async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func removeStatusRefreshFailures(ids p0: [String]) async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func hasStatusRefreshFailure(with p0: String) async -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func getDocumentStatus(for p0: MdocDataModel18013.StatusList) async throws -> CredentialStatus {
        return DefaultValueRegistry.defaultValue(for: (CredentialStatus).self)
    }
    
    public func isDocumentLowOnCredentials(document p0: (any DocClaimsDecodable)?) async -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func storeFailedReIssuedDocuments(ids p0: [String]) async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func removeAllFailedReIssuedDocuments() async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func hasReIssuanceFailure(with p0: String) async -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func refreshUsageCounters() async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getIssuerRegistration(for p0: OfferedIssuanceModel) async -> IssuerRegistration? {
        return DefaultValueRegistry.defaultValue(for: (IssuerRegistration?).self)
    }
    
    public func reconcileRegistrations() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func issuerLogoOrigins() async -> IssuerLogoOrigins {
        return DefaultValueRegistry.defaultValue(for: (IssuerLogoOrigins).self)
    }
    
    public func getIssuerRegistration(issuerId p0: String, configIds p1: [String]) async throws -> IssuerRegistration? {
        return DefaultValueRegistry.defaultValue(for: (IssuerRegistration?).self)
    }
    
    public func getVerifierRegistration(policy p0: WrpRegistrationPolicy?, trustViolations p1: [String], overaskedClaims p2: [logic_core.OveraskedClaim], verifierName p3: String?, verifierIsTrusted p4: Bool, isNotBoundToRequester p5: Bool, transactionIdentifier p6: String) async -> RelyingPartyRegistration {
        return DefaultValueRegistry.defaultValue(for: (RelyingPartyRegistration).self)
    }
    
    public func getVerifierRegistrationForFailedRequest() async -> RelyingPartyRegistration? {
        return DefaultValueRegistry.defaultValue(for: (RelyingPartyRegistration?).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Controller/WalletKitTrustMarkController.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockWalletKitTrustMarkController: WalletKitTrustMarkController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any WalletKitTrustMarkController
    public typealias Stubbing = __StubbingProxy_WalletKitTrustMarkController
    public typealias Verification = __VerificationProxy_WalletKitTrustMarkController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any WalletKitTrustMarkController)?

    public func enableDefaultImplementation(_ stub: any WalletKitTrustMarkController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func getTrustMark() async throws -> TrustMarkDomain {
        return try await cuckoo_manager.callThrows(
            "getTrustMark() async throws -> TrustMarkDomain",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getTrustMark()
        )
    }

    public struct __StubbingProxy_WalletKitTrustMarkController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func getTrustMark() -> Cuckoo.ProtocolStubThrowingFunction<(), TrustMarkDomain,Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitTrustMarkController.self,
                method: "getTrustMark() async throws -> TrustMarkDomain",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_WalletKitTrustMarkController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func getTrustMark() -> Cuckoo.__DoNotUse<(), TrustMarkDomain> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getTrustMark() async throws -> TrustMarkDomain",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class WalletKitTrustMarkControllerStub:WalletKitTrustMarkController, @unchecked Sendable {


    
    public func getTrustMark() async throws -> TrustMarkDomain {
        return DefaultValueRegistry.defaultValue(for: (TrustMarkDomain).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Coordinator/Model/PresentationRequest.swift'

import Cuckoo
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Coordinator/Model/PresentationSessionError.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Coordinator/Model/PresentationState.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Coordinator/ProximitySessionCoordinator.swift'

import Cuckoo
import logic_resources
import UIKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

class MockProximityTransferService: ProximityTransferService, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = any ProximityTransferService
    typealias Stubbing = __StubbingProxy_ProximityTransferService
    typealias Verification = __VerificationProxy_ProximityTransferService

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any ProximityTransferService)?

    func enableDefaultImplementation(_ stub: any ProximityTransferService) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    var isReaderDisconnected: Bool {
        get {
            return cuckoo_manager.getter(
                "isReaderDisconnected",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.isReaderDisconnected
            )
        }
    }


    func stop() {
        return cuckoo_manager.call(
            "stop()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.stop()
        )
    }

    struct __StubbingProxy_ProximityTransferService: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var isReaderDisconnected: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockProximityTransferService,Bool> {
            return .init(manager: cuckoo_manager, name: "isReaderDisconnected")
        }
        
        func stop() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockProximityTransferService.self,
                method: "stop()",
                parameterMatchers: matchers
            ))
        }
    }

    struct __VerificationProxy_ProximityTransferService: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var isReaderDisconnected: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "isReaderDisconnected", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        @discardableResult
        func stop() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stop()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

class ProximityTransferServiceStub:ProximityTransferService, @unchecked Sendable {
    
    var isReaderDisconnected: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
    }


    
    func stop() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}


public class MockProximitySessionCoordinator: ProximitySessionCoordinator, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any ProximitySessionCoordinator
    public typealias Stubbing = __StubbingProxy_ProximitySessionCoordinator
    public typealias Verification = __VerificationProxy_ProximitySessionCoordinator

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any ProximitySessionCoordinator)?

    public func enableDefaultImplementation(_ stub: any ProximitySessionCoordinator) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public var sendableCurrentValueSubject: SendableCurrentValueSubject<PresentationState> {
        get {
            return cuckoo_manager.getter(
                "sendableCurrentValueSubject",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.sendableCurrentValueSubject
            )
        }
    }

    public var relyingPartyRegistration: WrpRegistrationPolicy? {
        get {
            return cuckoo_manager.getter(
                "relyingPartyRegistration",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.relyingPartyRegistration
            )
        }
    }

    public var relyingPartyWarningViolations: [String] {
        get {
            return cuckoo_manager.getter(
                "relyingPartyWarningViolations",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.relyingPartyWarningViolations
            )
        }
    }

    public var isRelyingPartyNotBoundToRequester: Bool {
        get {
            return cuckoo_manager.getter(
                "isRelyingPartyNotBoundToRequester",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.isRelyingPartyNotBoundToRequester
            )
        }
    }

    public var transactionIdentifier: String {
        get {
            return cuckoo_manager.getter(
                "transactionIdentifier",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.transactionIdentifier
            )
        }
    }

    public required init(session p0: PresentationSession) {}

    public func initialize() async throws {
        return try await cuckoo_manager.callThrows(
            "initialize() async throws",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.initialize()
        )
    }

    public func startQrEngagement() async throws -> UIImage {
        return try await cuckoo_manager.callThrows(
            "startQrEngagement() async throws -> UIImage",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.startQrEngagement()
        )
    }

    public func requestReceived() async throws -> PresentationRequest {
        return try await cuckoo_manager.callThrows(
            "requestReceived() async throws -> PresentationRequest",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.requestReceived()
        )
    }

    public func sendResponse(response p0: RequestItemConvertible) async throws {
        return try await cuckoo_manager.callThrows(
            "sendResponse(response p0: RequestItemConvertible) async throws",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.sendResponse(response: p0)
        )
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

    public func getStream() -> AsyncStream<PresentationState> {
        return cuckoo_manager.call(
            "getStream() -> AsyncStream<PresentationState>",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getStream()
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

    public func waitForReaderDisconnect() async -> Bool {
        return await cuckoo_manager.call(
            "waitForReaderDisconnect() async -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.waitForReaderDisconnect()
        )
    }

    public struct __StubbingProxy_ProximitySessionCoordinator: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var sendableCurrentValueSubject: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockProximitySessionCoordinator,SendableCurrentValueSubject<PresentationState>> {
            return .init(manager: cuckoo_manager, name: "sendableCurrentValueSubject")
        }
        
        var relyingPartyRegistration: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockProximitySessionCoordinator,WrpRegistrationPolicy?> {
            return .init(manager: cuckoo_manager, name: "relyingPartyRegistration")
        }
        
        var relyingPartyWarningViolations: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockProximitySessionCoordinator,[String]> {
            return .init(manager: cuckoo_manager, name: "relyingPartyWarningViolations")
        }
        
        var isRelyingPartyNotBoundToRequester: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockProximitySessionCoordinator,Bool> {
            return .init(manager: cuckoo_manager, name: "isRelyingPartyNotBoundToRequester")
        }
        
        var transactionIdentifier: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockProximitySessionCoordinator,String> {
            return .init(manager: cuckoo_manager, name: "transactionIdentifier")
        }
        
        func initialize() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(),Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockProximitySessionCoordinator.self,
                method: "initialize() async throws",
                parameterMatchers: matchers
            ))
        }
        
        func startQrEngagement() -> Cuckoo.ProtocolStubThrowingFunction<(), UIImage,Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockProximitySessionCoordinator.self,
                method: "startQrEngagement() async throws -> UIImage",
                parameterMatchers: matchers
            ))
        }
        
        func requestReceived() -> Cuckoo.ProtocolStubThrowingFunction<(), PresentationRequest,Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockProximitySessionCoordinator.self,
                method: "requestReceived() async throws -> PresentationRequest",
                parameterMatchers: matchers
            ))
        }
        
        func sendResponse<M1: Cuckoo.Matchable>(response p0: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(RequestItemConvertible),Swift.Error> where M1.MatchedType == RequestItemConvertible {
            let matchers: [Cuckoo.ParameterMatcher<(RequestItemConvertible)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockProximitySessionCoordinator.self,
                method: "sendResponse(response p0: RequestItemConvertible) async throws",
                parameterMatchers: matchers
            ))
        }
        
        func getState() -> Cuckoo.ProtocolStubFunction<(), PresentationState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockProximitySessionCoordinator.self,
                method: "getState() async -> PresentationState",
                parameterMatchers: matchers
            ))
        }
        
        func setState<M1: Cuckoo.Matchable>(presentationState p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(PresentationState)> where M1.MatchedType == PresentationState {
            let matchers: [Cuckoo.ParameterMatcher<(PresentationState)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockProximitySessionCoordinator.self,
                method: "setState(presentationState p0: PresentationState)",
                parameterMatchers: matchers
            ))
        }
        
        func getStream() -> Cuckoo.ProtocolStubFunction<(), AsyncStream<PresentationState>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockProximitySessionCoordinator.self,
                method: "getStream() -> AsyncStream<PresentationState>",
                parameterMatchers: matchers
            ))
        }
        
        func stopPresentation() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockProximitySessionCoordinator.self,
                method: "stopPresentation()",
                parameterMatchers: matchers
            ))
        }
        
        func waitForReaderDisconnect() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockProximitySessionCoordinator.self,
                method: "waitForReaderDisconnect() async -> Bool",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_ProximitySessionCoordinator: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var sendableCurrentValueSubject: Cuckoo.VerifyReadOnlyProperty<SendableCurrentValueSubject<PresentationState>> {
            return .init(manager: cuckoo_manager, name: "sendableCurrentValueSubject", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var relyingPartyRegistration: Cuckoo.VerifyReadOnlyProperty<WrpRegistrationPolicy?> {
            return .init(manager: cuckoo_manager, name: "relyingPartyRegistration", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var relyingPartyWarningViolations: Cuckoo.VerifyReadOnlyProperty<[String]> {
            return .init(manager: cuckoo_manager, name: "relyingPartyWarningViolations", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var isRelyingPartyNotBoundToRequester: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "isRelyingPartyNotBoundToRequester", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var transactionIdentifier: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "transactionIdentifier", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        @discardableResult
        func initialize() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "initialize() async throws",
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
        func sendResponse<M1: Cuckoo.Matchable>(response p0: M1) -> Cuckoo.__DoNotUse<(RequestItemConvertible), Void> where M1.MatchedType == RequestItemConvertible {
            let matchers: [Cuckoo.ParameterMatcher<(RequestItemConvertible)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "sendResponse(response p0: RequestItemConvertible) async throws",
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
        
        
        @discardableResult
        func getStream() -> Cuckoo.__DoNotUse<(), AsyncStream<PresentationState>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getStream() -> AsyncStream<PresentationState>",
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
        func waitForReaderDisconnect() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "waitForReaderDisconnect() async -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class ProximitySessionCoordinatorStub:ProximitySessionCoordinator, @unchecked Sendable {
    
    public var sendableCurrentValueSubject: SendableCurrentValueSubject<PresentationState> {
        get {
            return DefaultValueRegistry.defaultValue(for: (SendableCurrentValueSubject<PresentationState>).self)
        }
    }
    
    public var relyingPartyRegistration: WrpRegistrationPolicy? {
        get {
            return DefaultValueRegistry.defaultValue(for: (WrpRegistrationPolicy?).self)
        }
    }
    
    public var relyingPartyWarningViolations: [String] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String]).self)
        }
    }
    
    public var isRelyingPartyNotBoundToRequester: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
    }
    
    public var transactionIdentifier: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }

    
    public required init(session p0: PresentationSession) {}

    
    public func initialize() async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func startQrEngagement() async throws -> UIImage {
        return DefaultValueRegistry.defaultValue(for: (UIImage).self)
    }
    
    public func requestReceived() async throws -> PresentationRequest {
        return DefaultValueRegistry.defaultValue(for: (PresentationRequest).self)
    }
    
    public func sendResponse(response p0: RequestItemConvertible) async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getState() async -> PresentationState {
        return DefaultValueRegistry.defaultValue(for: (PresentationState).self)
    }
    
    public func setState(presentationState p0: PresentationState) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getStream() -> AsyncStream<PresentationState> {
        return DefaultValueRegistry.defaultValue(for: (AsyncStream<PresentationState>).self)
    }
    
    public func stopPresentation() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func waitForReaderDisconnect() async -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Coordinator/RemoteSessionCoordinator.swift'

import Cuckoo
import logic_resources
import UIKit
import os
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockRemoteSessionCoordinator: RemoteSessionCoordinator, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any RemoteSessionCoordinator
    public typealias Stubbing = __StubbingProxy_RemoteSessionCoordinator
    public typealias Verification = __VerificationProxy_RemoteSessionCoordinator

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any RemoteSessionCoordinator)?

    public func enableDefaultImplementation(_ stub: any RemoteSessionCoordinator) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public var sendableCurrentValueSubject: SendableCurrentValueSubject<PresentationState> {
        get {
            return cuckoo_manager.getter(
                "sendableCurrentValueSubject",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.sendableCurrentValueSubject
            )
        }
    }

    public var relyingPartyRegistration: WrpRegistrationPolicy? {
        get {
            return cuckoo_manager.getter(
                "relyingPartyRegistration",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.relyingPartyRegistration
            )
        }
    }

    public var relyingPartyWarningViolations: [String] {
        get {
            return cuckoo_manager.getter(
                "relyingPartyWarningViolations",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.relyingPartyWarningViolations
            )
        }
    }

    public var isRelyingPartyNotBoundToRequester: Bool {
        get {
            return cuckoo_manager.getter(
                "isRelyingPartyNotBoundToRequester",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.isRelyingPartyNotBoundToRequester
            )
        }
    }

    public var transactionIdentifier: String {
        get {
            return cuckoo_manager.getter(
                "transactionIdentifier",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.transactionIdentifier
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

    public func requestReceived() async throws -> PresentationRequest {
        return try await cuckoo_manager.callThrows(
            "requestReceived() async throws -> PresentationRequest",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.requestReceived()
        )
    }

    public func sendResponse(response p0: RequestItemConvertible) async throws {
        return try await cuckoo_manager.callThrows(
            "sendResponse(response p0: RequestItemConvertible) async throws",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.sendResponse(response: p0)
        )
    }

    public func declineResponse() async throws {
        return try await cuckoo_manager.callThrows(
            "declineResponse() async throws",
            parameters: (),
            escapingParameters: (),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.declineResponse()
        )
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

    public func getStream() -> AsyncStream<PresentationState> {
        return cuckoo_manager.call(
            "getStream() -> AsyncStream<PresentationState>",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.getStream()
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

    public func stopPresentation() {
        return cuckoo_manager.call(
            "stopPresentation()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.stopPresentation()
        )
    }

    public struct __StubbingProxy_RemoteSessionCoordinator: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var sendableCurrentValueSubject: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockRemoteSessionCoordinator,SendableCurrentValueSubject<PresentationState>> {
            return .init(manager: cuckoo_manager, name: "sendableCurrentValueSubject")
        }
        
        var relyingPartyRegistration: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockRemoteSessionCoordinator,WrpRegistrationPolicy?> {
            return .init(manager: cuckoo_manager, name: "relyingPartyRegistration")
        }
        
        var relyingPartyWarningViolations: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockRemoteSessionCoordinator,[String]> {
            return .init(manager: cuckoo_manager, name: "relyingPartyWarningViolations")
        }
        
        var isRelyingPartyNotBoundToRequester: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockRemoteSessionCoordinator,Bool> {
            return .init(manager: cuckoo_manager, name: "isRelyingPartyNotBoundToRequester")
        }
        
        var transactionIdentifier: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockRemoteSessionCoordinator,String> {
            return .init(manager: cuckoo_manager, name: "transactionIdentifier")
        }
        
        func initialize() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteSessionCoordinator.self,
                method: "initialize() async",
                parameterMatchers: matchers
            ))
        }
        
        func requestReceived() -> Cuckoo.ProtocolStubThrowingFunction<(), PresentationRequest,Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteSessionCoordinator.self,
                method: "requestReceived() async throws -> PresentationRequest",
                parameterMatchers: matchers
            ))
        }
        
        func sendResponse<M1: Cuckoo.Matchable>(response p0: M1) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(RequestItemConvertible),Swift.Error> where M1.MatchedType == RequestItemConvertible {
            let matchers: [Cuckoo.ParameterMatcher<(RequestItemConvertible)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteSessionCoordinator.self,
                method: "sendResponse(response p0: RequestItemConvertible) async throws",
                parameterMatchers: matchers
            ))
        }
        
        func declineResponse() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(),Swift.Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteSessionCoordinator.self,
                method: "declineResponse() async throws",
                parameterMatchers: matchers
            ))
        }
        
        func getState() -> Cuckoo.ProtocolStubFunction<(), PresentationState> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteSessionCoordinator.self,
                method: "getState() async -> PresentationState",
                parameterMatchers: matchers
            ))
        }
        
        func getStream() -> Cuckoo.ProtocolStubFunction<(), AsyncStream<PresentationState>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteSessionCoordinator.self,
                method: "getStream() -> AsyncStream<PresentationState>",
                parameterMatchers: matchers
            ))
        }
        
        func setState<M1: Cuckoo.Matchable>(presentationState p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(PresentationState)> where M1.MatchedType == PresentationState {
            let matchers: [Cuckoo.ParameterMatcher<(PresentationState)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteSessionCoordinator.self,
                method: "setState(presentationState p0: PresentationState)",
                parameterMatchers: matchers
            ))
        }
        
        func stopPresentation() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteSessionCoordinator.self,
                method: "stopPresentation()",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_RemoteSessionCoordinator: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var sendableCurrentValueSubject: Cuckoo.VerifyReadOnlyProperty<SendableCurrentValueSubject<PresentationState>> {
            return .init(manager: cuckoo_manager, name: "sendableCurrentValueSubject", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var relyingPartyRegistration: Cuckoo.VerifyReadOnlyProperty<WrpRegistrationPolicy?> {
            return .init(manager: cuckoo_manager, name: "relyingPartyRegistration", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var relyingPartyWarningViolations: Cuckoo.VerifyReadOnlyProperty<[String]> {
            return .init(manager: cuckoo_manager, name: "relyingPartyWarningViolations", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var isRelyingPartyNotBoundToRequester: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "isRelyingPartyNotBoundToRequester", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var transactionIdentifier: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "transactionIdentifier", callMatcher: callMatcher, sourceLocation: sourceLocation)
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
        func sendResponse<M1: Cuckoo.Matchable>(response p0: M1) -> Cuckoo.__DoNotUse<(RequestItemConvertible), Void> where M1.MatchedType == RequestItemConvertible {
            let matchers: [Cuckoo.ParameterMatcher<(RequestItemConvertible)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "sendResponse(response p0: RequestItemConvertible) async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func declineResponse() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "declineResponse() async throws",
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
        func getStream() -> Cuckoo.__DoNotUse<(), AsyncStream<PresentationState>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "getStream() -> AsyncStream<PresentationState>",
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
    }
}

public class RemoteSessionCoordinatorStub:RemoteSessionCoordinator, @unchecked Sendable {
    
    public var sendableCurrentValueSubject: SendableCurrentValueSubject<PresentationState> {
        get {
            return DefaultValueRegistry.defaultValue(for: (SendableCurrentValueSubject<PresentationState>).self)
        }
    }
    
    public var relyingPartyRegistration: WrpRegistrationPolicy? {
        get {
            return DefaultValueRegistry.defaultValue(for: (WrpRegistrationPolicy?).self)
        }
    }
    
    public var relyingPartyWarningViolations: [String] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String]).self)
        }
    }
    
    public var isRelyingPartyNotBoundToRequester: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
    }
    
    public var transactionIdentifier: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }

    
    public required init(session p0: PresentationSession) {}

    
    public func initialize() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func requestReceived() async throws -> PresentationRequest {
        return DefaultValueRegistry.defaultValue(for: (PresentationRequest).self)
    }
    
    public func sendResponse(response p0: RequestItemConvertible) async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func declineResponse() async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func getState() async -> PresentationState {
        return DefaultValueRegistry.defaultValue(for: (PresentationState).self)
    }
    
    public func getStream() -> AsyncStream<PresentationState> {
        return DefaultValueRegistry.defaultValue(for: (AsyncStream<PresentationState>).self)
    }
    
    public func setState(presentationState p0: PresentationState) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func stopPresentation() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Coordinator/Wrapper/SessionCoordinatorHolder.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockSessionCoordinatorHolder: SessionCoordinatorHolder, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any SessionCoordinatorHolder
    public typealias Stubbing = __StubbingProxy_SessionCoordinatorHolder
    public typealias Verification = __VerificationProxy_SessionCoordinatorHolder

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any SessionCoordinatorHolder)?

    public func enableDefaultImplementation(_ stub: any SessionCoordinatorHolder) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func clear() async {
        return await cuckoo_manager.call(
            "clear() async",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.clear()
        )
    }

    public func clearRemoteCoordinator(_ p0: RemoteSessionCoordinator) async {
        return await cuckoo_manager.call(
            "clearRemoteCoordinator(_ p0: RemoteSessionCoordinator) async",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.clearRemoteCoordinator(p0)
        )
    }

    public func clearProximityCoordinator(_ p0: ProximitySessionCoordinator) async {
        return await cuckoo_manager.call(
            "clearProximityCoordinator(_ p0: ProximitySessionCoordinator) async",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.clearProximityCoordinator(p0)
        )
    }

    public func setActiveRemoteCoordinator(_ p0: RemoteSessionCoordinator) async {
        return await cuckoo_manager.call(
            "setActiveRemoteCoordinator(_ p0: RemoteSessionCoordinator) async",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.setActiveRemoteCoordinator(p0)
        )
    }

    public func setActiveProximityCoordinator(_ p0: ProximitySessionCoordinator) async {
        return await cuckoo_manager.call(
            "setActiveProximityCoordinator(_ p0: ProximitySessionCoordinator) async",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.setActiveProximityCoordinator(p0)
        )
    }

    public struct __StubbingProxy_SessionCoordinatorHolder: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func clear() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockSessionCoordinatorHolder.self,
                method: "clear() async",
                parameterMatchers: matchers
            ))
        }
        
        func clearRemoteCoordinator<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(RemoteSessionCoordinator)> where M1.MatchedType == RemoteSessionCoordinator {
            let matchers: [Cuckoo.ParameterMatcher<(RemoteSessionCoordinator)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockSessionCoordinatorHolder.self,
                method: "clearRemoteCoordinator(_ p0: RemoteSessionCoordinator) async",
                parameterMatchers: matchers
            ))
        }
        
        func clearProximityCoordinator<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(ProximitySessionCoordinator)> where M1.MatchedType == ProximitySessionCoordinator {
            let matchers: [Cuckoo.ParameterMatcher<(ProximitySessionCoordinator)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockSessionCoordinatorHolder.self,
                method: "clearProximityCoordinator(_ p0: ProximitySessionCoordinator) async",
                parameterMatchers: matchers
            ))
        }
        
        func setActiveRemoteCoordinator<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(RemoteSessionCoordinator)> where M1.MatchedType == RemoteSessionCoordinator {
            let matchers: [Cuckoo.ParameterMatcher<(RemoteSessionCoordinator)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockSessionCoordinatorHolder.self,
                method: "setActiveRemoteCoordinator(_ p0: RemoteSessionCoordinator) async",
                parameterMatchers: matchers
            ))
        }
        
        func setActiveProximityCoordinator<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(ProximitySessionCoordinator)> where M1.MatchedType == ProximitySessionCoordinator {
            let matchers: [Cuckoo.ParameterMatcher<(ProximitySessionCoordinator)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockSessionCoordinatorHolder.self,
                method: "setActiveProximityCoordinator(_ p0: ProximitySessionCoordinator) async",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_SessionCoordinatorHolder: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func clear() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "clear() async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func clearRemoteCoordinator<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.__DoNotUse<(RemoteSessionCoordinator), Void> where M1.MatchedType == RemoteSessionCoordinator {
            let matchers: [Cuckoo.ParameterMatcher<(RemoteSessionCoordinator)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "clearRemoteCoordinator(_ p0: RemoteSessionCoordinator) async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func clearProximityCoordinator<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.__DoNotUse<(ProximitySessionCoordinator), Void> where M1.MatchedType == ProximitySessionCoordinator {
            let matchers: [Cuckoo.ParameterMatcher<(ProximitySessionCoordinator)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "clearProximityCoordinator(_ p0: ProximitySessionCoordinator) async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setActiveRemoteCoordinator<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.__DoNotUse<(RemoteSessionCoordinator), Void> where M1.MatchedType == RemoteSessionCoordinator {
            let matchers: [Cuckoo.ParameterMatcher<(RemoteSessionCoordinator)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setActiveRemoteCoordinator(_ p0: RemoteSessionCoordinator) async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func setActiveProximityCoordinator<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.__DoNotUse<(ProximitySessionCoordinator), Void> where M1.MatchedType == ProximitySessionCoordinator {
            let matchers: [Cuckoo.ParameterMatcher<(ProximitySessionCoordinator)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setActiveProximityCoordinator(_ p0: ProximitySessionCoordinator) async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class SessionCoordinatorHolderStub:SessionCoordinatorHolder, @unchecked Sendable {


    
    public func clear() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func clearRemoteCoordinator(_ p0: RemoteSessionCoordinator) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func clearProximityCoordinator(_ p0: ProximitySessionCoordinator) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func setActiveRemoteCoordinator(_ p0: RemoteSessionCoordinator) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func setActiveProximityCoordinator(_ p0: ProximitySessionCoordinator) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/DocumentRegistrationManager/DocumentRegistrationManager.swift'

import Cuckoo
import Foundation
import IdentityDocumentServices
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockDocumentRegistrationManager: DocumentRegistrationManager, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any DocumentRegistrationManager
    public typealias Stubbing = __StubbingProxy_DocumentRegistrationManager
    public typealias Verification = __VerificationProxy_DocumentRegistrationManager

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any DocumentRegistrationManager)?

    public func enableDefaultImplementation(_ stub: any DocumentRegistrationManager) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func reconcile(desired p0: [RegistrationDescriptor]) async {
        return await cuckoo_manager.call(
            "reconcile(desired p0: [RegistrationDescriptor]) async",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.reconcile(desired: p0)
        )
    }

    public struct __StubbingProxy_DocumentRegistrationManager: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func reconcile<M1: Cuckoo.Matchable>(desired p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<([RegistrationDescriptor])> where M1.MatchedType == [RegistrationDescriptor] {
            let matchers: [Cuckoo.ParameterMatcher<([RegistrationDescriptor])>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDocumentRegistrationManager.self,
                method: "reconcile(desired p0: [RegistrationDescriptor]) async",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_DocumentRegistrationManager: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func reconcile<M1: Cuckoo.Matchable>(desired p0: M1) -> Cuckoo.__DoNotUse<([RegistrationDescriptor]), Void> where M1.MatchedType == [RegistrationDescriptor] {
            let matchers: [Cuckoo.ParameterMatcher<([RegistrationDescriptor])>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "reconcile(desired p0: [RegistrationDescriptor]) async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class DocumentRegistrationManagerStub:DocumentRegistrationManager, @unchecked Sendable {


    
    public func reconcile(desired p0: [RegistrationDescriptor]) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Error/RegistrationRefusedError.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Error/WalletCoreError.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/BlePresentationService+Extensions.swift'

import Cuckoo
import EudiWalletKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/BookmarkStorageController+Extensions.swift'

import Cuckoo
import logic_storage
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/DocClaim+Extensions.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/DocClaimsDecodable+Extensions.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/DocDataValue+BoundedImage.swift'

import Cuckoo
import UIKit
import MdocDataModel18013
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/DocElements+Extensions.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/DocumentElementClaim+Extensions.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/Error+IssuerTrust.swift'

import Cuckoo
import Foundation
import EudiWalletKit
import MdocSecurity18013
import enum OpenID4VP.ValidationError
import enum OpenID4VCI.WRPRCError
import enum OpenID4VCI.CredentialIssuerMetadataError
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/OfferedDocModel+Extensions.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/OfferedIssuanceModel+Extensions.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/OpenID4VCI.Display+Extensions.swift'

import Cuckoo
import Foundation
import OpenID4VCI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/OpenID4VCI.TxCode+Extensions.swift'

import Cuckoo
import OpenID4VCI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/PolicyPurpose+Localized.swift'

import Cuckoo
import Foundation
import EudiWalletKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/PresentationPolicyViolation+Overasking.swift'

import Cuckoo
import Foundation
import EudiWalletKit
import MdocDataModel18013
import struct OpenID4VP.ClaimPath
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/PresentationTransactionData+Domain.swift'

import Cuckoo
import Foundation
import EudiWalletKit
import MdocDataModel18013
import struct OpenID4VP.SupportedTransactionDataType
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/RevokedDocument+Extensions.swift'

import Cuckoo
import logic_storage
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/RevokedDocumentStorageController+Extensions.swift'

import Cuckoo
import logic_storage
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/StatusRefreshFailureStorageController+Extensions.swift'

import Cuckoo
import logic_storage
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/String+Extensions.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/TransactionEntry+Extensions.swift'

import Cuckoo
import Foundation
import MdocDataModel18013
import logic_storage
import struct OpenID4VP.SupportedTransactionDataType
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/TransactionLogDomain+Entry.swift'

import Cuckoo
import Foundation
import MdocDataModel18013
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/TrustMarkResource+Extensions.swift'

import Cuckoo
import Foundation
import MdocDataModel18013
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/URL+IssuerLogo.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/URLComponents+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/WalletKitConfig+Extensions.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/WalletKitController+Extensions.swift'

import Cuckoo
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Extension/WalletStorage.Document+Extensions.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Model/DeferrredDocument.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Model/DocumentCategory.swift'

import Cuckoo
import logic_resources
import OrderedCollections
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Model/DocumentElement.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Model/DocumentIdentifier.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Model/DocumentJsonKeys.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Model/DocumentProviderPolicy.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Model/DocumentProviderSelection.swift'

import Cuckoo
import MdocDataModel18013
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Model/DocumentRevocationStatus.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Model/DynamicIssuancePendingData.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Model/ImageDecodeLimits.swift'

import Cuckoo
import ImageIO
import UIKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Model/IssuerLogoOrigins.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Model/OfferIssuer.swift'

import Cuckoo
import Foundation
import OpenID4VCI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Model/PresentationTransactionDataDomain.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Model/RecordedRegistrationCheck.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Model/RelyingPartyRegistration.swift'

import Cuckoo
import Foundation
import WalletStorage
import struct OpenID4VP.ClaimPath
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Model/RequestItemConvertible.swift'

import Cuckoo
import EudiWalletKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockRequestItemConvertible: RequestItemConvertible, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any RequestItemConvertible
    public typealias Stubbing = __StubbingProxy_RequestItemConvertible
    public typealias Verification = __VerificationProxy_RequestItemConvertible

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any RequestItemConvertible)?

    public func enableDefaultImplementation(_ stub: any RequestItemConvertible) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public var items: RequestConvertibleItems {
        get {
            return cuckoo_manager.getter(
                "items",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.items
            )
        }
    }

    public var requestName: String? {
        get {
            return cuckoo_manager.getter(
                "requestName",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.requestName
            )
        }
    }


    public struct __StubbingProxy_RequestItemConvertible: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var items: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockRequestItemConvertible,RequestConvertibleItems> {
            return .init(manager: cuckoo_manager, name: "items")
        }
        
        var requestName: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockRequestItemConvertible,String?> {
            return .init(manager: cuckoo_manager, name: "requestName")
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
        
        var items: Cuckoo.VerifyReadOnlyProperty<RequestConvertibleItems> {
            return .init(manager: cuckoo_manager, name: "items", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var requestName: Cuckoo.VerifyReadOnlyProperty<String?> {
            return .init(manager: cuckoo_manager, name: "requestName", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    }
}

public class RequestItemConvertibleStub:RequestItemConvertible, @unchecked Sendable {
    
    public var items: RequestConvertibleItems {
        get {
            return DefaultValueRegistry.defaultValue(for: (RequestConvertibleItems).self)
        }
    }
    
    public var requestName: String? {
        get {
            return DefaultValueRegistry.defaultValue(for: (String?).self)
        }
    }


}




// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Model/RevocationDashboardPayload.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Model/RevocationRecordUpdate.swift'

import Cuckoo
import StatiumSwift
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Model/ScopedDocument.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Model/TransactionActionChannel.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Model/TransactionDataProtectionAction.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Model/TransactionLogDomain.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Model/TrustMarkDomain.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Provider/RegistrationCheckProvider.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockRegistrationCheckProvider: RegistrationCheckProvider, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any RegistrationCheckProvider
    public typealias Stubbing = __StubbingProxy_RegistrationCheckProvider
    public typealias Verification = __VerificationProxy_RegistrationCheckProvider

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any RegistrationCheckProvider)?

    public func enableDefaultImplementation(_ stub: any RegistrationCheckProvider) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func record(_ p0: RecordedRegistrationCheck, for p1: String) async {
        return await cuckoo_manager.call(
            "record(_ p0: RecordedRegistrationCheck, for p1: String) async",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.record(p0, for: p1)
        )
    }

    public func removeCheck(for p0: String) async -> RecordedRegistrationCheck? {
        return await cuckoo_manager.call(
            "removeCheck(for p0: String) async -> RecordedRegistrationCheck?",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.removeCheck(for: p0)
        )
    }

    public struct __StubbingProxy_RegistrationCheckProvider: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func record<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ p0: M1, for p1: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(RecordedRegistrationCheck, String)> where M1.MatchedType == RecordedRegistrationCheck, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(RecordedRegistrationCheck, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRegistrationCheckProvider.self,
                method: "record(_ p0: RecordedRegistrationCheck, for p1: String) async",
                parameterMatchers: matchers
            ))
        }
        
        func removeCheck<M1: Cuckoo.Matchable>(for p0: M1) -> Cuckoo.ProtocolStubFunction<(String), RecordedRegistrationCheck?> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRegistrationCheckProvider.self,
                method: "removeCheck(for p0: String) async -> RecordedRegistrationCheck?",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_RegistrationCheckProvider: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func record<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ p0: M1, for p1: M2) -> Cuckoo.__DoNotUse<(RecordedRegistrationCheck, String), Void> where M1.MatchedType == RecordedRegistrationCheck, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(RecordedRegistrationCheck, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "record(_ p0: RecordedRegistrationCheck, for p1: String) async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func removeCheck<M1: Cuckoo.Matchable>(for p0: M1) -> Cuckoo.__DoNotUse<(String), RecordedRegistrationCheck?> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "removeCheck(for p0: String) async -> RecordedRegistrationCheck?",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class RegistrationCheckProviderStub:RegistrationCheckProvider, @unchecked Sendable {


    
    public func record(_ p0: RecordedRegistrationCheck, for p1: String) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func removeCheck(for p0: String) async -> RecordedRegistrationCheck? {
        return DefaultValueRegistry.defaultValue(for: (RecordedRegistrationCheck?).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Provider/WalletKitAttestationProvider.swift'

import Cuckoo
import JOSESwift
import Foundation
import OpenID4VCI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

class MockWalletKitAttestationProvider: WalletKitAttestationProvider, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = any WalletKitAttestationProvider
    typealias Stubbing = __StubbingProxy_WalletKitAttestationProvider
    typealias Verification = __VerificationProxy_WalletKitAttestationProvider

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any WalletKitAttestationProvider)?

    func enableDefaultImplementation(_ stub: any WalletKitAttestationProvider) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    var baseUrl: String {
        get {
            return cuckoo_manager.getter(
                "baseUrl",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.baseUrl
            )
        }
    }


    func getWalletAttestation(signingKey p0: SigningKeyProxy) async throws -> String {
        return try await cuckoo_manager.callThrows(
            "getWalletAttestation(signingKey p0: SigningKeyProxy) async throws -> String",
            parameters: (p0),
            escapingParameters: (p0),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getWalletAttestation(signingKey: p0)
        )
    }

    func getKeysAttestation(keys p0: [any JWK], nonce p1: String?) async throws -> String {
        return try await cuckoo_manager.callThrows(
            "getKeysAttestation(keys p0: [any JWK], nonce p1: String?) async throws -> String",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
            errorType: Swift.Error.self,
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.getKeysAttestation(keys: p0, nonce: p1)
        )
    }

    struct __StubbingProxy_WalletKitAttestationProvider: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var baseUrl: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletKitAttestationProvider,String> {
            return .init(manager: cuckoo_manager, name: "baseUrl")
        }
        
        func getWalletAttestation<M1: Cuckoo.Matchable>(signingKey p0: M1) -> Cuckoo.ProtocolStubThrowingFunction<(SigningKeyProxy), String,Swift.Error> where M1.MatchedType == SigningKeyProxy {
            let matchers: [Cuckoo.ParameterMatcher<(SigningKeyProxy)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitAttestationProvider.self,
                method: "getWalletAttestation(signingKey p0: SigningKeyProxy) async throws -> String",
                parameterMatchers: matchers
            ))
        }
        
        func getKeysAttestation<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(keys p0: M1, nonce p1: M2) -> Cuckoo.ProtocolStubThrowingFunction<([any JWK], String?), String,Swift.Error> where M1.MatchedType == [any JWK], M2.OptionalMatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<([any JWK], String?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletKitAttestationProvider.self,
                method: "getKeysAttestation(keys p0: [any JWK], nonce p1: String?) async throws -> String",
                parameterMatchers: matchers
            ))
        }
    }

    struct __VerificationProxy_WalletKitAttestationProvider: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var baseUrl: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "baseUrl", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        @discardableResult
        func getWalletAttestation<M1: Cuckoo.Matchable>(signingKey p0: M1) -> Cuckoo.__DoNotUse<(SigningKeyProxy), String> where M1.MatchedType == SigningKeyProxy {
            let matchers: [Cuckoo.ParameterMatcher<(SigningKeyProxy)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "getWalletAttestation(signingKey p0: SigningKeyProxy) async throws -> String",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func getKeysAttestation<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(keys p0: M1, nonce p1: M2) -> Cuckoo.__DoNotUse<([any JWK], String?), String> where M1.MatchedType == [any JWK], M2.OptionalMatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<([any JWK], String?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "getKeysAttestation(keys p0: [any JWK], nonce p1: String?) async throws -> String",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

class WalletKitAttestationProviderStub:WalletKitAttestationProvider, @unchecked Sendable {
    
    var baseUrl: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }


    
    func getWalletAttestation(signingKey p0: SigningKeyProxy) async throws -> String {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
    
    func getKeysAttestation(keys p0: [any JWK], nonce p1: String?) async throws -> String {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Provider/WalletResetStatusProvider.swift'

import Cuckoo
import Foundation
import os
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockWalletResetStatusProvider: WalletResetStatusProvider, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any WalletResetStatusProvider
    public typealias Stubbing = __StubbingProxy_WalletResetStatusProvider
    public typealias Verification = __VerificationProxy_WalletResetStatusProvider

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any WalletResetStatusProvider)?

    public func enableDefaultImplementation(_ stub: any WalletResetStatusProvider) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public var isResetting: Bool {
        get {
            return cuckoo_manager.getter(
                "isResetting",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.isResetting
            )
        }
    }


    public func setResetting(_ p0: Bool) {
        return cuckoo_manager.call(
            "setResetting(_ p0: Bool)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setResetting(p0)
        )
    }

    public struct __StubbingProxy_WalletResetStatusProvider: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var isResetting: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockWalletResetStatusProvider,Bool> {
            return .init(manager: cuckoo_manager, name: "isResetting")
        }
        
        func setResetting<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool)> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletResetStatusProvider.self,
                method: "setResetting(_ p0: Bool)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_WalletResetStatusProvider: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var isResetting: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "isResetting", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        @discardableResult
        func setResetting<M1: Cuckoo.Matchable>(_ p0: M1) -> Cuckoo.__DoNotUse<(Bool), Void> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "setResetting(_ p0: Bool)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class WalletResetStatusProviderStub:WalletResetStatusProvider, @unchecked Sendable {
    
    public var isResetting: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
    }


    
    public func setResetting(_ p0: Bool) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Storage/StoredDocumentPresence.swift'

import Cuckoo
import Foundation
import Security
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Worker/ReIssuanceWorkManager.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

class MockReIssuanceWorkManager: ReIssuanceWorkManager, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = any ReIssuanceWorkManager
    typealias Stubbing = __StubbingProxy_ReIssuanceWorkManager
    typealias Verification = __VerificationProxy_ReIssuanceWorkManager

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any ReIssuanceWorkManager)?

    func enableDefaultImplementation(_ stub: any ReIssuanceWorkManager) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    func start() async {
        return await cuckoo_manager.call(
            "start() async",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.start()
        )
    }

    func stop() async {
        return await cuckoo_manager.call(
            "stop() async",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.stop()
        )
    }

    struct __StubbingProxy_ReIssuanceWorkManager: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func start() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockReIssuanceWorkManager.self,
                method: "start() async",
                parameterMatchers: matchers
            ))
        }
        
        func stop() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockReIssuanceWorkManager.self,
                method: "stop() async",
                parameterMatchers: matchers
            ))
        }
    }

    struct __VerificationProxy_ReIssuanceWorkManager: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func start() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "start() async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stop() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stop() async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

class ReIssuanceWorkManagerStub:ReIssuanceWorkManager, @unchecked Sendable {


    
    func start() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    func stop() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Worker/RevocationWorkManager.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

class MockRevocationWorkManager: RevocationWorkManager, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = any RevocationWorkManager
    typealias Stubbing = __StubbingProxy_RevocationWorkManager
    typealias Verification = __VerificationProxy_RevocationWorkManager

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any RevocationWorkManager)?

    func enableDefaultImplementation(_ stub: any RevocationWorkManager) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    func start() async {
        return await cuckoo_manager.call(
            "start() async",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.start()
        )
    }

    func stop() async {
        return await cuckoo_manager.call(
            "stop() async",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.stop()
        )
    }

    func checkAfterReIssue(of p0: String) async {
        return await cuckoo_manager.call(
            "checkAfterReIssue(of p0: String) async",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.checkAfterReIssue(of: p0)
        )
    }

    struct __StubbingProxy_RevocationWorkManager: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func start() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRevocationWorkManager.self,
                method: "start() async",
                parameterMatchers: matchers
            ))
        }
        
        func stop() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRevocationWorkManager.self,
                method: "stop() async",
                parameterMatchers: matchers
            ))
        }
        
        func checkAfterReIssue<M1: Cuckoo.Matchable>(of p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRevocationWorkManager.self,
                method: "checkAfterReIssue(of p0: String) async",
                parameterMatchers: matchers
            ))
        }
    }

    struct __VerificationProxy_RevocationWorkManager: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func start() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "start() async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stop() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stop() async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func checkAfterReIssue<M1: Cuckoo.Matchable>(of p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "checkAfterReIssue(of p0: String) async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

class RevocationWorkManagerStub:RevocationWorkManager, @unchecked Sendable {


    
    func start() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    func stop() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    func checkAfterReIssue(of p0: String) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-core/Sources/Worker/WalletWorkScheduler.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockWalletWorkScheduler: WalletWorkScheduler, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any WalletWorkScheduler
    public typealias Stubbing = __StubbingProxy_WalletWorkScheduler
    public typealias Verification = __VerificationProxy_WalletWorkScheduler

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any WalletWorkScheduler)?

    public func enableDefaultImplementation(_ stub: any WalletWorkScheduler) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func schedule() async {
        return await cuckoo_manager.call(
            "schedule() async",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.schedule()
        )
    }

    public func scheduleRevocationCheck(afterReIssueOf p0: String) async {
        return await cuckoo_manager.call(
            "scheduleRevocationCheck(afterReIssueOf p0: String) async",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.scheduleRevocationCheck(afterReIssueOf: p0)
        )
    }

    public func stop() async -> Bool {
        return await cuckoo_manager.call(
            "stop() async -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.stop()
        )
    }

    public struct __StubbingProxy_WalletWorkScheduler: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func schedule() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletWorkScheduler.self,
                method: "schedule() async",
                parameterMatchers: matchers
            ))
        }
        
        func scheduleRevocationCheck<M1: Cuckoo.Matchable>(afterReIssueOf p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockWalletWorkScheduler.self,
                method: "scheduleRevocationCheck(afterReIssueOf p0: String) async",
                parameterMatchers: matchers
            ))
        }
        
        func stop() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockWalletWorkScheduler.self,
                method: "stop() async -> Bool",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_WalletWorkScheduler: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func schedule() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "schedule() async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func scheduleRevocationCheck<M1: Cuckoo.Matchable>(afterReIssueOf p0: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "scheduleRevocationCheck(afterReIssueOf p0: String) async",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func stop() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "stop() async -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class WalletWorkSchedulerStub:WalletWorkScheduler, @unchecked Sendable {


    
    public func schedule() async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func scheduleRevocationCheck(afterReIssueOf p0: String) async {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func stop() async -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/Architecture/ViewModel.swift'

import Cuckoo
import SwiftUI
import Combine
import Copyable
import Observation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockViewState: ViewState, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any ViewState
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

public class ViewStateStub:ViewState, @unchecked Sendable {


}




// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/Config/ConfigUiLogic.swift'

import Cuckoo
import logic_resources
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockConfigUiLogic: ConfigUiLogic, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any ConfigUiLogic
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

    public var protectedFlowRouteKeys: [AppRouteKey] {
        get {
            return cuckoo_manager.getter(
                "protectedFlowRouteKeys",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.protectedFlowRouteKeys
            )
        }
    }

    public var hideContentWhileCaptured: Bool {
        get {
            return cuckoo_manager.getter(
                "hideContentWhileCaptured",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.hideContentWhileCaptured
            )
        }
    }

    public var loginRouteKeys: [AppRouteKey] {
        get {
            return cuckoo_manager.getter(
                "loginRouteKeys",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.loginRouteKeys
            )
        }
    }

    public var userImageClaimKeys: Set<String> {
        get {
            return cuckoo_manager.getter(
                "userImageClaimKeys",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.userImageClaimKeys
            )
        }
    }

    public var coveringScreenModules: [String] {
        get {
            return cuckoo_manager.getter(
                "coveringScreenModules",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.coveringScreenModules
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
        
        var protectedFlowRouteKeys: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigUiLogic,[AppRouteKey]> {
            return .init(manager: cuckoo_manager, name: "protectedFlowRouteKeys")
        }
        
        var hideContentWhileCaptured: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigUiLogic,Bool> {
            return .init(manager: cuckoo_manager, name: "hideContentWhileCaptured")
        }
        
        var loginRouteKeys: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigUiLogic,[AppRouteKey]> {
            return .init(manager: cuckoo_manager, name: "loginRouteKeys")
        }
        
        var userImageClaimKeys: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigUiLogic,Set<String>> {
            return .init(manager: cuckoo_manager, name: "userImageClaimKeys")
        }
        
        var coveringScreenModules: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockConfigUiLogic,[String]> {
            return .init(manager: cuckoo_manager, name: "coveringScreenModules")
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
        
        var protectedFlowRouteKeys: Cuckoo.VerifyReadOnlyProperty<[AppRouteKey]> {
            return .init(manager: cuckoo_manager, name: "protectedFlowRouteKeys", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var hideContentWhileCaptured: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "hideContentWhileCaptured", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var loginRouteKeys: Cuckoo.VerifyReadOnlyProperty<[AppRouteKey]> {
            return .init(manager: cuckoo_manager, name: "loginRouteKeys", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var userImageClaimKeys: Cuckoo.VerifyReadOnlyProperty<Set<String>> {
            return .init(manager: cuckoo_manager, name: "userImageClaimKeys", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var coveringScreenModules: Cuckoo.VerifyReadOnlyProperty<[String]> {
            return .init(manager: cuckoo_manager, name: "coveringScreenModules", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    }
}

public class ConfigUiLogicStub:ConfigUiLogic, @unchecked Sendable {
    
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
    
    public var protectedFlowRouteKeys: [AppRouteKey] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([AppRouteKey]).self)
        }
    }
    
    public var hideContentWhileCaptured: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
    }
    
    public var loginRouteKeys: [AppRouteKey] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([AppRouteKey]).self)
        }
    }
    
    public var userImageClaimKeys: Set<String> {
        get {
            return DefaultValueRegistry.defaultValue(for: (Set<String>).self)
        }
    }
    
    public var coveringScreenModules: [String] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String]).self)
        }
    }

    
    public required init(themeConfiguration p0: ThemeConfiguration) {}

}




// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/Config/UIConfig.swift'

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
@testable import feature_presentation

public class MockUIConfigType: UIConfigType, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any UIConfigType
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

public class UIConfigTypeStub:UIConfigType, @unchecked Sendable {
    
    public var log: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }


}




// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/Controller/DeepLinkController.swift'

import Cuckoo
import Foundation
import os
import EudiRQESUi
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockDeepLinkController: DeepLinkController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any DeepLinkController
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

    public func setDocumentsLoaded() {
        return cuckoo_manager.call(
            "setDocumentsLoaded()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.setDocumentsLoaded()
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
        
        func setDocumentsLoaded() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockDeepLinkController.self,
                method: "setDocumentsLoaded()",
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
        
        
        @discardableResult
        func setDocumentsLoaded() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "setDocumentsLoaded()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class DeepLinkControllerStub:DeepLinkController, @unchecked Sendable {


    
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
    
    public func setDocumentsLoaded() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/Controller/ScreenCaptureController.swift'

import Cuckoo
import Combine
import UIKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockScreenCaptureController: ScreenCaptureController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any ScreenCaptureController
    public typealias Stubbing = __StubbingProxy_ScreenCaptureController
    public typealias Verification = __VerificationProxy_ScreenCaptureController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any ScreenCaptureController)?

    public func enableDefaultImplementation(_ stub: any ScreenCaptureController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func start() {
        return cuckoo_manager.call(
            "start()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.start()
        )
    }

    public struct __StubbingProxy_ScreenCaptureController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func start() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockScreenCaptureController.self,
                method: "start()",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_ScreenCaptureController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func start() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "start()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class ScreenCaptureControllerStub:ScreenCaptureController, @unchecked Sendable {


    
    public func start() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}


class MockScreenCaptureScene: ScreenCaptureScene, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = any ScreenCaptureScene
    typealias Stubbing = __StubbingProxy_ScreenCaptureScene
    typealias Verification = __VerificationProxy_ScreenCaptureScene

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any ScreenCaptureScene)?

    func enableDefaultImplementation(_ stub: any ScreenCaptureScene) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    var isCaptured: Bool {
        get {
            return cuckoo_manager.getter(
                "isCaptured",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.isCaptured
            )
        }
    }

    var isForegroundActive: Bool {
        get {
            return cuckoo_manager.getter(
                "isForegroundActive",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.isForegroundActive
            )
        }
    }


    func observeCaptureState(onChange p0: @escaping @MainActor (Bool) -> Void) {
        return cuckoo_manager.call(
            "observeCaptureState(onChange p0: @escaping @MainActor (Bool) -> Void)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.observeCaptureState(onChange: p0)
        )
    }

    func endEditing() {
        return cuckoo_manager.call(
            "endEditing()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.endEditing()
        )
    }

    func makeCoverWindow() -> ScreenCaptureCoverWindow {
        return cuckoo_manager.call(
            "makeCoverWindow() -> ScreenCaptureCoverWindow",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.makeCoverWindow()
        )
    }

    struct __StubbingProxy_ScreenCaptureScene: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var isCaptured: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockScreenCaptureScene,Bool> {
            return .init(manager: cuckoo_manager, name: "isCaptured")
        }
        
        var isForegroundActive: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockScreenCaptureScene,Bool> {
            return .init(manager: cuckoo_manager, name: "isForegroundActive")
        }
        
        func observeCaptureState<M1: Cuckoo.Matchable>(onChange p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(@MainActor (Bool) -> Void)> where M1.MatchedType == @MainActor (Bool) -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(@MainActor (Bool) -> Void)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockScreenCaptureScene.self,
                method: "observeCaptureState(onChange p0: @escaping @MainActor (Bool) -> Void)",
                parameterMatchers: matchers
            ))
        }
        
        func endEditing() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockScreenCaptureScene.self,
                method: "endEditing()",
                parameterMatchers: matchers
            ))
        }
        
        func makeCoverWindow() -> Cuckoo.ProtocolStubFunction<(), ScreenCaptureCoverWindow> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockScreenCaptureScene.self,
                method: "makeCoverWindow() -> ScreenCaptureCoverWindow",
                parameterMatchers: matchers
            ))
        }
    }

    struct __VerificationProxy_ScreenCaptureScene: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var isCaptured: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "isCaptured", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var isForegroundActive: Cuckoo.VerifyReadOnlyProperty<Bool> {
            return .init(manager: cuckoo_manager, name: "isForegroundActive", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        @discardableResult
        func observeCaptureState<M1: Cuckoo.Matchable>(onChange p0: M1) -> Cuckoo.__DoNotUse<(@MainActor (Bool) -> Void), Void> where M1.MatchedType == @MainActor (Bool) -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(@MainActor (Bool) -> Void)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "observeCaptureState(onChange p0: @escaping @MainActor (Bool) -> Void)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func endEditing() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "endEditing()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func makeCoverWindow() -> Cuckoo.__DoNotUse<(), ScreenCaptureCoverWindow> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "makeCoverWindow() -> ScreenCaptureCoverWindow",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

class ScreenCaptureSceneStub:ScreenCaptureScene, @unchecked Sendable {
    
    var isCaptured: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
    }
    
    var isForegroundActive: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
    }


    
    func observeCaptureState(onChange p0: @escaping @MainActor (Bool) -> Void) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    func endEditing() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    func makeCoverWindow() -> ScreenCaptureCoverWindow {
        return DefaultValueRegistry.defaultValue(for: (ScreenCaptureCoverWindow).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/Controller/UrlSchemaController.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

class MockUrlSchemaController: UrlSchemaController, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = any UrlSchemaController
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

class UrlSchemaControllerStub:UrlSchemaController, @unchecked Sendable {


    
    func retrieveSchemas(with p0: String) -> [String] {
        return DefaultValueRegistry.defaultValue(for: ([String]).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/Controller/UserInteractionController.swift'

import Cuckoo
import Combine
import UIKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockUserInteractionController: UserInteractionController, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any UserInteractionController
    public typealias Stubbing = __StubbingProxy_UserInteractionController
    public typealias Verification = __VerificationProxy_UserInteractionController

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any UserInteractionController)?

    public func enableDefaultImplementation(_ stub: any UserInteractionController) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }


    public func start(onInteraction p0: @escaping @MainActor () -> Void) {
        return cuckoo_manager.call(
            "start(onInteraction p0: @escaping @MainActor () -> Void)",
            parameters: (p0),
            escapingParameters: (p0),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.start(onInteraction: p0)
        )
    }

    public struct __StubbingProxy_UserInteractionController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func start<M1: Cuckoo.Matchable>(onInteraction p0: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(@MainActor () -> Void)> where M1.MatchedType == @MainActor () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(@MainActor () -> Void)>] = [wrap(matchable: p0) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockUserInteractionController.self,
                method: "start(onInteraction p0: @escaping @MainActor () -> Void)",
                parameterMatchers: matchers
            ))
        }
    }

    public struct __VerificationProxy_UserInteractionController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func start<M1: Cuckoo.Matchable>(onInteraction p0: M1) -> Cuckoo.__DoNotUse<(@MainActor () -> Void), Void> where M1.MatchedType == @MainActor () -> Void {
            let matchers: [Cuckoo.ParameterMatcher<(@MainActor () -> Void)>] = [wrap(matchable: p0) { $0 }]
            return cuckoo_manager.verify(
                "start(onInteraction p0: @escaping @MainActor () -> Void)",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class UserInteractionControllerStub:UserInteractionController, @unchecked Sendable {


    
    public func start(onInteraction p0: @escaping @MainActor () -> Void) {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Button/ButtonViewStyle.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Accessibility/AccessibilityLocatorViewModifier.swift'

import Cuckoo
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockLocatorType: LocatorType, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any LocatorType
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

    public var trait: AccessibilityTraits? {
        get {
            return cuckoo_manager.getter(
                "trait",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.trait
            )
        }
    }


    public struct __StubbingProxy_LocatorType: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var id: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockLocatorType,String> {
            return .init(manager: cuckoo_manager, name: "id")
        }
        
        var trait: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockLocatorType,AccessibilityTraits?> {
            return .init(manager: cuckoo_manager, name: "trait")
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
        
        var trait: Cuckoo.VerifyReadOnlyProperty<AccessibilityTraits?> {
            return .init(manager: cuckoo_manager, name: "trait", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    }
}

public class LocatorTypeStub:LocatorType, @unchecked Sendable {
    
    public var id: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }
    
    public var trait: AccessibilityTraits? {
        get {
            return DefaultValueRegistry.defaultValue(for: (AccessibilityTraits?).self)
        }
    }


}




// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Accessibility/CombineAccessibilityModifier.swift'

import Cuckoo
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Accessibility/ContentErrorLocators.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Accessibility/FastenedDynamicModifier.swift'

import Cuckoo
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Accessibility/IgnoreAccessibilityModifier.swift'

import Cuckoo
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Accessibility/ToolbarLocators.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Alert/AlertView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Blur/BlurView.swift'

import Cuckoo
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Content/ContentCaptionView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Content/ContentEmptyView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Content/ContentErrorView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Content/ContentHeader/AppIconAndTextView.swift'

import Cuckoo
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Content/ContentHeader/ContentHeaderView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Content/ContentHeader/RelyingPartyRegistrationView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Content/ContentHeader/RelyingPartyView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Content/ContentHeaderErrorView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Content/ContentLoaderView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Content/ContentScreenView.swift'

import Cuckoo
import SwiftUI
import logic_resources
import Combine
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Content/ContentSheetView.swift'

import Cuckoo
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Content/ContentTitleView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Cover/ScreenCaptureCoverView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Dialog/DialogCompat.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Image/LeftImageModifier.swift'

import Cuckoo
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Image/RemoteImageView.swift'

import Cuckoo
import SwiftUI
import logic_resources
import SDWebImageSwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Image/RightImageModifier.swift'

import Cuckoo
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Input/PinTextFieldView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/List/ActionCardView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/List/CardViewWithLogoView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/List/ExpandableCardView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/List/HomeCardView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/List/ListDividerView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/List/ListItemData.swift'

import Cuckoo
import logic_resources
import Copyable
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/List/TappableCellView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/List/WrapCardView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/List/WrapExpandableListView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/List/WrapListItemView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/List/WrapListItemsView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/List/WrapSelectableCardView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/SearchableList/SearchableListView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Sheet/SheetContainerView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Unavailable/ContentUnavailableView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Warning/WarningAcknowledgementView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Warning/WarningNoticeView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Wrap/WrapButtonView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Wrap/WrapCheckBoxView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Wrap/WrapIconView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Component/Wrap/WrapTextView.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/EasySpacer.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Shape/RoundedCornerShape.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/DesignSystem/Toolbar/ToolBarContent.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/Extension/ExpandableListItem+Extensions.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/Extension/ListItemSection+Extensions.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/Extension/LocalizedStringKey+Extensions.swift'

import Cuckoo
import SwiftUI
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/Extension/TextField+Extensions.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/Extension/UIApplication+Extensions.swift'

import Cuckoo
import UIKit
import os
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/Extension/UIDevice+Extensions.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/Extension/UIScreen+Extensions.swift'

import Cuckoo
import UIKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/Extension/UIWindowScene+Extensions.swift'

import Cuckoo
import UIKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/Extension/URL+Extensions.swift'

import Cuckoo
import UIKit
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/Extension/View+Extensions.swift'

import Cuckoo
import SwiftUI
import AlertToast
import Shimmer
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/Model/DeepLink.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/Model/RemoteImagePolicy.swift'

import Cuckoo
import Foundation
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/Navigation/AppRoute.swift'

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
@testable import feature_presentation



// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/Navigation/AppRouteModule.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockAppRouteModule: AppRouteModule, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any AppRouteModule
    public typealias Stubbing = __StubbingProxy_AppRouteModule
    public typealias Verification = __VerificationProxy_AppRouteModule

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any AppRouteModule)?

    public func enableDefaultImplementation(_ stub: any AppRouteModule) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    public var info: (key: String, arguments: [String: String]) {
        get {
            return cuckoo_manager.getter(
                "info",
                superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
                defaultCall: __defaultImplStub!.info
            )
        }
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


    public struct __StubbingProxy_AppRouteModule: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var info: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAppRouteModule,(key: String, arguments: [String: String])> {
            return .init(manager: cuckoo_manager, name: "info")
        }
        
        var id: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockAppRouteModule,String> {
            return .init(manager: cuckoo_manager, name: "id")
        }
    }

    public struct __VerificationProxy_AppRouteModule: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        public init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        var info: Cuckoo.VerifyReadOnlyProperty<(key: String, arguments: [String: String])> {
            return .init(manager: cuckoo_manager, name: "info", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var id: Cuckoo.VerifyReadOnlyProperty<String> {
            return .init(manager: cuckoo_manager, name: "id", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
    }
}

public class AppRouteModuleStub:AppRouteModule, @unchecked Sendable {
    
    public var info: (key: String, arguments: [String: String]) {
        get {
            return DefaultValueRegistry.defaultValue(for: ((key: String, arguments: [String: String])).self)
        }
    }
    
    public var id: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }


}




// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/Navigation/Routable.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockRoutable: Routable, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any Routable
    public typealias Stubbing = __StubbingProxy_Routable
    public typealias Verification = __VerificationProxy_Routable

    // Original typealiases

    public let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any Routable)?

    public func enableDefaultImplementation(_ stub: any Routable) {
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


    public struct __StubbingProxy_Routable: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        public init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var log: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockRoutable,String> {
            return .init(manager: cuckoo_manager, name: "log")
        }
    }

    public struct __VerificationProxy_Routable: Cuckoo.VerificationProxy {
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

public class RoutableStub:Routable, @unchecked Sendable {
    
    public var log: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
    }


}




// MARK: - Mocks generated from file: '../Modules/logic-ui/Sources/Navigation/RouterHost.swift'

import Cuckoo
@testable import logic_core
@testable import logic_business
@testable import logic_analytics
@testable import logic_ui
@testable import logic_api
@testable import logic_authentication
@testable import feature_common
@testable import feature_presentation

public class MockRouterHost: RouterHost, Cuckoo.ProtocolMock, @unchecked Sendable {
    public typealias MocksType = any RouterHost
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

    public func isInProtectedFlow() -> Bool {
        return cuckoo_manager.call(
            "isInProtectedFlow() -> Bool",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.isInProtectedFlow()
        )
    }

    public func requireLoginIfLocked() {
        return cuckoo_manager.call(
            "requireLoginIfLocked()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.requireLoginIfLocked()
        )
    }

    public func restartAtStartup() {
        return cuckoo_manager.call(
            "restartAtStartup()",
            parameters: (),
            escapingParameters: (),
            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.restartAtStartup()
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
        
        func isInProtectedFlow() -> Cuckoo.ProtocolStubFunction<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self,
                method: "isInProtectedFlow() -> Bool",
                parameterMatchers: matchers
            ))
        }
        
        func requireLoginIfLocked() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self,
                method: "requireLoginIfLocked()",
                parameterMatchers: matchers
            ))
        }
        
        func restartAtStartup() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockRouterHost.self,
                method: "restartAtStartup()",
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
        
        
        @discardableResult
        func isInProtectedFlow() -> Cuckoo.__DoNotUse<(), Bool> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "isInProtectedFlow() -> Bool",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func requireLoginIfLocked() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "requireLoginIfLocked()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func restartAtStartup() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "restartAtStartup()",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

public class RouterHostStub:RouterHost, @unchecked Sendable {


    
    public func push(with p0: AppRoute) {
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
    
    public func isInProtectedFlow() -> Bool {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    public func requireLoginIfLocked() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    public func restartAtStartup() {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}


