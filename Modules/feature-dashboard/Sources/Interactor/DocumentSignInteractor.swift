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
import Foundation
import logic_business
import EudiRQESUi

public protocol DocumentSignInteractor: Sendable {
  func initiateSigning(url: URL) async
}

final class DocumentSignInteractorImpl: DocumentSignInteractor {

  private let configLogic: ConfigLogic

  init(configLogic: ConfigLogic) {
    self.configLogic = configLogic
  }

  func initiateSigning(url: URL) async {

    let eudiRQESUi: EudiRQESUi

    do {
      eudiRQESUi = try EudiRQESUi.instance()
    } catch {
      eudiRQESUi = EudiRQESUi.init(config: configLogic.rqesConfig)
    }

    guard let controller = await UIApplication.shared.topViewController() else {
      return
    }

    try? await eudiRQESUi.initiate(
      on: controller,
      fileUrl: url
    )
  }
}
