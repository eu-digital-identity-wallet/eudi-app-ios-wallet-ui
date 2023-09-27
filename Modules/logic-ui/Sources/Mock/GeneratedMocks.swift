import Cuckoo

import SwiftUI

import Cuckoo

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
    
    

    

    
}





import Cuckoo

import Cuckoo

import Foundation
import SwiftUI

import Cuckoo

import SwiftUI

import Cuckoo

import ActivityIndicatorView
import SwiftUI

import Cuckoo

import SwiftUI

import Cuckoo

import SwiftUI

import Cuckoo

import SwiftUI

import Cuckoo

import SwiftUI

import Cuckoo

import Foundation
import SwiftUI

import Cuckoo

import AlertToast
import SwiftUI

import Cuckoo

import ActivityIndicatorView
import AlertToast
import Cuckoo
import Foundation
import SwiftUI
import class Foundation.Bundle
import logic_business
import logic_ui

import Cuckoo

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

import SwiftUI
