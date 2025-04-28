/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the EUPL, Version 1.2 or - as soon they will be approved by the European
 * Commission - subsequent versions of the EUPL (the "Licence"); You may not use this work
 * except in compliance with the Licence.
 *
 * You may obtain a copy of the Licence at:
 * https://joinup.ec.europa.eu/software/page/eupl
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the Licence is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the Licence for the specific language
 * governing permissions and limitations under the Licence.
 */
import logic_ui
import feature_common
import logic_core

@MainActor
public final class ProximityRouter {

  public static func resolve(module: FeatureProximityRouteModule, host: some RouterHost) -> AnyView {
    switch module {
    case .proximityConnection(
      presentationCoordinator: let presentationCoordinator,
      originator: let originator
    ):
      ProximityConnectionView(
        with: .init(
          router: host,
          interactor: DIGraph.resolver.force(
            ProximityInteractor.self,
            argument: presentationCoordinator as ProximitySessionCoordinator
          ),
          originator: originator
        )
      ).eraseToAnyView()
    case .proximityRequest(
      presentationCoordinator: let presentationCoordinator,
      originator: let originator
    ):
      ProximityRequestView(
        with: .init(
          router: host,
          interactor: DIGraph.resolver.force(
            ProximityInteractor.self,
            argument: presentationCoordinator as ProximitySessionCoordinator
          ),
          originator: originator
        )
      ).eraseToAnyView()
    case .proximityLoader(
      let relyingParty,
      let relyingPartyIsTrusted,
      presentationCoordinator: let presentationCoordinator,
      originator: let originator,
      let uiModels
    ):
      ProximityLoadingView(
        with: .init(
          router: host,
          interactor: DIGraph.resolver.force(
            ProximityInteractor.self,
            argument: presentationCoordinator as ProximitySessionCoordinator
          ),
          relyingParty: relyingParty,
          relyingPartyIsTrusted: relyingPartyIsTrusted,
          originator: originator,
          requestItems: uiModels.compactMap { $0 as? PresentationListItemSection }
        )
      ).eraseToAnyView()
    case .proximitySuccess(
      let config,
      let uiModels
    ):
      ProximitySuccessView(
        with: .init(
          router: host,
          config: config,
          deepLinkController: DIGraph.resolver.force(
            DeepLinkController.self
          ),
          requestItems: uiModels.compactMap { $0 as? PresentationListItemSection }
        )
      ).eraseToAnyView()
    }
  }
}
