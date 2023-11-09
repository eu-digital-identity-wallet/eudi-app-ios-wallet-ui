/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import feature_common

@MainActor
final class CrossDeviceRequestViewModel<Router: RouterHostType, Interactor: CrossDeviceInteractorType>: BaseRequestViewModel<Router> {

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
      self.onReceivedItems(with: RequestDataUiModel.mock())
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
          screen: .crossDeviceLoader(getRelyingParty()),
          navigationType: .push
        ),
        navigationBackConfig: .init(
          screen: .crossDeviceRequest,
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
