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
import logic_business

@MainActor
public final class CommonRouter {

  public static func resolve(module: FeatureCommonRouteModule, host: some RouterHost) -> AnyView {
    return switch module {
    case .quickPin(let config):
      QuickPinView(
        with: .init(
          router: host,
          interactor: DIGraph.resolver.force(
            QuickPinInteractor.self
          ),
          config: config
        )
      ).eraseToAnyView()
    case .qrScanner(config: let config):
      ScannerView(
        with: .init(
          config: config,
          router: host,
          interactor: DIGraph.resolver.force(
            ScannerInteractor.self
          )
        )
      ).eraseToAnyView()
    case .biometry(config: let config):
      BiometryView(
        with: .init(
          router: host,
          interactor: DIGraph.resolver.force(
            BiometryInteractor.self
          ), config: config
        )
      ).eraseToAnyView()
    case .success(let config):
      SuccessView(
        with: .init(
          config: config,
          router: host,
          deepLinkController: DIGraph.resolver.force(
            DeepLinkController.self
          )
        )
      ).eraseToAnyView()
    case .issuanceAddDocumentOptions(config: let config):
      AddDocumentOptionsView(
        with: .init(
          router: host,
          config: config
        )
      ).eraseToAnyView()
    }
  }
}
