import Cuckoo
@testable import feature_startup

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
@testable import feature_startup

import SwiftUI
import logic_ui

import Cuckoo
@testable import feature_startup

import Foundation
import logic_business
import logic_ui
