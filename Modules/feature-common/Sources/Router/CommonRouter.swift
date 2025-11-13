/*
 * Copyright (c) 2025 European Commission
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

  @ViewBuilder
  public static func resolve(module: FeatureCommonRouteModule, host: some RouterHost) -> some View {
    switch module {
    case .quickPin(let config):
      QuickPinView(
        with: .init(
          router: host,
          interactor: DIGraph.shared.resolver.force(
            QuickPinInteractor.self
          ),
          config: config
        )
      )
    case .qrScanner(config: let config):
      ScannerView(
        with: .init(
          config: config,
          router: host,
          interactor: DIGraph.shared.resolver.force(
            ScannerInteractor.self
          )
        )
      )
    case .biometry(config: let config):
      BiometryView(
        with: .init(
          router: host,
          interactor: DIGraph.shared.resolver.force(
            BiometryInteractor.self
          ), config: config
        )
      )
    case .genericSuccess(let config):
      GenericSuccessView(
        with: .init(
          config: config,
          router: host,
          deepLinkController: DIGraph.shared.resolver.force(
            DeepLinkController.self
          )
        )
      )
    }
  }
}
