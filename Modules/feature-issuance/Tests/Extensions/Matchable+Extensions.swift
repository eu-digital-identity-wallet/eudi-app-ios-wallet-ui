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
import Cuckoo
import logic_core

extension OfferedDocModel: @retroactive Matchable {
  public var matcher: ParameterMatcher<OfferedDocModel> {
    return ParameterMatcher { other in
      return self.credentialConfigurationIdentifier == other.credentialConfigurationIdentifier
      && self.docType == other.docType
      && self.scope == other.scope
      && self.displayName == other.displayName
      && self.algValuesSupported == other.algValuesSupported
    }
  }
}

extension OfferedIssuanceModel: @retroactive Matchable {
  public var matcher: ParameterMatcher<OfferedIssuanceModel> {
    return ParameterMatcher { other in
      return self.issuerName == other.issuerName
      && self.issuerLogoUrl == other.issuerLogoUrl
      && self.docModels == other.docModels
      && self.txCodeSpec == other.txCodeSpec
    }
  }
}
