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
import logic_business
import logic_core

public protocol ScannerInteractor: FormValidatorInteractor, ThreadSafeInteractor {
  func startCrossDevicePresentation(scanResult: String) -> RemoteSessionCoordinator
}

final class ScannerInteractorImpl: ScannerInteractor {

  private let formValidator: FormValidator
  private let walletKitController: WalletKitController

  init(formValidator: FormValidator, walletKitController: WalletKitController) {
    self.formValidator = formValidator
    self.walletKitController = walletKitController
  }

  func validateForm(form: ValidatableForm) async -> FormValidationResult {
    return await formValidator.validateForm(form: form)
  }

  func validateForms(forms: [ValidatableForm]) async -> FormsValidationResult {
    return await formValidator.validateForms(forms: forms)
  }

  func startCrossDevicePresentation(scanResult: String) -> RemoteSessionCoordinator {
    return walletKitController.startCrossDevicePresentation(
      urlString: scanResult
    )
  }
}
