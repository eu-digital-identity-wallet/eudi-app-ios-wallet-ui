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
import EudiWalletKit
import logic_business

public extension Array where Element == PolicyPurpose {

  var localizedValue: String? {
    let language = Locale.current.systemLanguageCode?.lowercased()
    return first { $0.lang.languageSubtag == language }?.value ?? first?.value
  }
}

private extension String {

  var languageSubtag: String {
    components(separatedBy: "-").first?.lowercased() ?? lowercased()
  }
}
