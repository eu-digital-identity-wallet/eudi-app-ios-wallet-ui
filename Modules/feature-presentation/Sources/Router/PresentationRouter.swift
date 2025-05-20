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
public final class PresentationRouter {

  public static func resolve(module: FeaturePresentationRouteModule, host: some RouterHost) -> AnyView {
    switch module {
    case .presentationLoader(
      let relyingParty,
      let relyingPartyIsTrusted,
      presentationCoordinator: let presentationCoordinator,
      originator: let originator,
      let uiModels
    ):
      PresentationLoadingView(
        with: .init(
          router: host,
          interactor: DIGraph.resolver.force(
            PresentationInteractor.self,
            argument: presentationCoordinator as RemoteSessionCoordinator
          ),
          relyingParty: relyingParty,
          relyingPartyIsTrusted: relyingPartyIsTrusted,
          originator: originator,
          requestItems: uiModels.compactMap { $0 as? PresentationListItemSection }
        )
      ).eraseToAnyView()
    case .presentationRequest(
      presentationCoordinator: let presentationCoordinator,
      originator: let originator
    ):
      PresentationRequestView(
        with: .init(
          router: host,
          interactor: DIGraph.resolver.force(
            PresentationInteractor.self,
            argument: presentationCoordinator as RemoteSessionCoordinator
          ),
          originator: originator
        )
      ).eraseToAnyView()
    case .presentationSuccess(
      let config,
      let uiModels
    ):
      PresentationSuccessView(
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
