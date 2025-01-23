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
@_exported import logic_ui
@_exported import logic_resources
@_exported import logic_business
@_exported import feature_common

open class ProximitySuccessViewModel<Router: RouterHost>: BaseSuccessViewModel<Router> {

  public override init(
    router: Router,
    config: any UIConfigType,
    deepLinkController: DeepLinkController,
    requestItems: [any Routable]
  ) {

    super.init(
      router: router,
      config: config,
      deepLinkController: deepLinkController,
      requestItems: requestItems
    )
  }
}
