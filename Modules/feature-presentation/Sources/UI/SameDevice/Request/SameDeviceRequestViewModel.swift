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

import feature_common

@MainActor
final class SameDeviceRequestViewModel<Router: RouterHostType, Interactor: SameDeviceInteractorType>: BaseRequestViewModel<Router> {

  private let interactor: Interactor

  init(
    router: Router,
    interactor: Interactor
  ) {
    self.interactor = interactor
    super.init(router: router)
  }

  override func doWork() async {
    self.onStartLoading()
    switch await interactor.doWork() {
    case .success:
      self.onReceivedItems(
        with: RequestDataUiModel.mock(),
        title: .requestDataTitle(["EUDI Wallet"]),
        relyingParty: "EUDI Wallet",
        isTrusted: true
      )
    case .failure(let error):
      self.onError(with: error)
    }
  }

  override func getSuccessRoute() -> AppRoute? {
    .biometry(
      config: UIConfig.Biometry(
        title: getTitle(),
        caption: .requestDataShareBiometryCaption,
        quickPinOnlyCaption: .requestDataShareBiometryCaption,
        navigationSuccessConfig: .init(
          screen: .sameDeviceLoader(getRelyingParty()),
          navigationType: .push
        ),
        navigationBackConfig: .init(
          screen: .sameDeviceRequest,
          navigationType: .pop
        ),
        isPreAuthorization: false,
        shouldInitializeBiometricOnCreate: true
      )
    )
  }

  override func getTitle() -> LocalizableString.Key {
    .requestDataTitle(["EUDI Conference"])
  }

  override func getCaption() -> LocalizableString.Key {
    .requestDataCaption
  }

  override func getDataRequestInfo() -> LocalizableString.Key {
    .requestDataInfoNotice
  }

  override func getRelyingParty() -> String {
    "EUDI Conference"
  }
}
