/*
 * Copyright (c) 2026 European Commission
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
import logic_core
import logic_business
import logic_resources

public enum LoadTrustMarkPartialState: Sendable, Equatable {
  case success(TrustMarkUIModel)
  case failure(String)
}

public protocol TrustMarkInteractor: Sendable {
  func getTrustMark() async -> LoadTrustMarkPartialState
  func completeIntroduction() async
}

final actor TrustMarkInteractorImpl: TrustMarkInteractor {

  private let walletKitTrustMarkController: WalletKitTrustMarkController
  private let prefsController: PrefsController

  init(
    walletKitTrustMarkController: WalletKitTrustMarkController,
    prefsController: PrefsController
  ) {
    self.walletKitTrustMarkController = walletKitTrustMarkController
    self.prefsController = prefsController
  }

  public func getTrustMark() async -> LoadTrustMarkPartialState {
    do {
      let trustMark = try await walletKitTrustMarkController.getTrustMark()
      return .success(
        TrustMarkUIModel(
          imageUrl: resolveImageUrl(trustMark.imageUrl, resourceUrl: trustMark.resourceUrl),
          text: trustMark.localisedText,
          certifiedWalletsUrl: usableWebUrl(trustMark.certifiedWalletsUrl),
          walletSolutionUrl: usableWebUrl(trustMark.walletSolutionUrl),
          certificationDescription: linkedParagraph(
            text: { .trustMarkCertificationDescription($0) },
            link: .trustMarkCertifiedWalletsLink
          ),
          certificationInformationDescription: linkedParagraph(
            text: { .trustMarkCertificationInformationDescription($0) },
            link: .trustMarkCertificationInformationLink
          )
        )
      )
    } catch {
      return .failure(LocalizableStringKey.trustMarkLoadError.toString)
    }
  }

  public func completeIntroduction() async {
    prefsController.setValue(true, forKey: .trustMarkIntroductionCompleted)
  }

  private func linkedParagraph(
    text: ([String]) -> LocalizableStringKey,
    link: LocalizableStringKey
  ) -> TrustMarkParagraphUIModel {
    let label = link.toString
    let paragraph = text([label]).toString
    guard !label.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
          let range = paragraph.range(of: label)
    else {
      return TrustMarkParagraphUIModel(text: paragraph, linkRange: nil)
    }
    let start = paragraph.distance(from: paragraph.startIndex, to: range.lowerBound)
    let end = paragraph.distance(from: paragraph.startIndex, to: range.upperBound)
    return TrustMarkParagraphUIModel(text: paragraph, linkRange: start..<end)
  }

  private func resolveImageUrl(_ imageUrl: String, resourceUrl: String) -> URL? {
    guard !imageUrl.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
          let resolved = URL(string: imageUrl, relativeTo: URL(string: resourceUrl))?.absoluteURL
    else {
      return nil
    }
    return usableWebUrl(resolved.absoluteString)
  }

  private func usableWebUrl(_ value: String) -> URL? {
    guard let components = URLComponents(string: value),
          let scheme = components.scheme?.lowercased(),
          ["https", "http"].contains(scheme),
          let host = components.host,
          !host.isEmpty,
          components.user == nil,
          components.password == nil,
          let url = components.url
    else {
      return nil
    }
    return url
  }
}
