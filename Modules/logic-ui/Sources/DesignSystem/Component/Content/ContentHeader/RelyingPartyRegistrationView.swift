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
import SwiftUI
import logic_resources

public struct RegisteredParty: Sendable {
  public let name: LocalizableStringKey
  public let identifier: LocalizableStringKey?
  public let isVerified: Bool
  public let logoUrl: URL?

  public init(
    name: LocalizableStringKey,
    identifier: LocalizableStringKey? = nil,
    isVerified: Bool,
    logoUrl: URL? = nil
  ) {
    self.name = name
    self.identifier = identifier
    self.isVerified = isVerified
    self.logoUrl = logoUrl
  }
}

public struct RelyingPartyRegistrationData: Sendable {
  public let primary: RegisteredParty
  public let privacyPolicyUrl: URL?
  public let intendedUse: LocalizableStringKey?

  public init(
    primary: RegisteredParty,
    privacyPolicyUrl: URL? = nil,
    intendedUse: LocalizableStringKey? = nil
  ) {
    self.primary = primary
    self.privacyPolicyUrl = privacyPolicyUrl
    self.intendedUse = intendedUse
  }
}

public struct RelyingPartyRegistrationView: View {
  private let data: RelyingPartyRegistrationData

  public init(data: RelyingPartyRegistrationData) {
    self.data = data
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: SPACING_MEDIUM) {
      partyView(data.primary)

      if let privacyPolicyUrl = data.privacyPolicyUrl {
        privacyPolicyView(url: privacyPolicyUrl)
      }

      if let intendedUse = data.intendedUse {
        section(title: .intendedUse) {
          Text(intendedUse)
            .typography(Theme.shared.font.bodyMedium)
            .foregroundColor(Theme.shared.color.primaryLabel)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  @ViewBuilder
  private func partyView(_ party: RegisteredParty) -> some View {
    HStack(alignment: .top, spacing: SPACING_SMALL) {
      VStack(alignment: .leading, spacing: SPACING_EXTRA_SMALL) {
        HStack(spacing: SPACING_SMALL) {
          if party.isVerified {
            Theme.shared.image.relyingPartyVerified
              .resizable()
              .scaledToFit()
              .frame(width: 20, height: 20)
          }
          Text(party.name)
            .typography(Theme.shared.font.bodyLarge)
            .fontWeight(.semibold)
            .foregroundColor(Theme.shared.color.primaryLabel)
            .multilineTextAlignment(.leading)
        }

        if let identifier = party.identifier {
          Text(identifier)
            .typography(Theme.shared.font.bodyMedium)
            .foregroundColor(Theme.shared.color.secondaryLabel)
            .multilineTextAlignment(.leading)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      if let logoUrl = party.logoUrl {
        RemoteImageView(
          url: logoUrl,
          icon: nil,
          width: logoSize,
          height: logoSize
        )
        .clipShape(Circle())
      }
    }
  }

  private var logoSize: Double { 40 }

  @ViewBuilder
  private func privacyPolicyView(url: URL) -> some View {
    section(title: .privacyPolicy) {
      Link(destination: url) {
        HStack(spacing: SPACING_EXTRA_SMALL) {
          Text(.custom(url.absoluteString))
            .typography(Theme.shared.font.bodyMedium)
            .multilineTextAlignment(.leading)
          Theme.shared.image.arrowUpRightSquare
        }
        .foregroundColor(Theme.shared.color.accent)
      }
    }
  }

  @ViewBuilder
  private func section<Content: View>(
    title: LocalizableStringKey,
    @ViewBuilder content: () -> Content
  ) -> some View {
    VStack(alignment: .leading, spacing: SPACING_SMALL) {
      Text(title)
        .typography(Theme.shared.font.bodyMedium)
        .fontWeight(.semibold)
        .foregroundColor(Theme.shared.color.primaryLabel)
      content()
    }
  }
}

#Preview("Direct RP") {
  RelyingPartyRegistrationView(
    data: RelyingPartyRegistrationData(
      primary: RegisteredParty(
        name: .custom("NordicBank A/S"),
        identifier: .relyingPartyId(["rp:nordicbank:prod"]),
        isVerified: true
      ),
      privacyPolicyUrl: URL(string: "https://nordicbank.example/privacy"),
      intendedUse: .custom(
        "We will use your identity and age to verify you for a new current account. Your data will be used once to complete onboarding and to meet anti-money laundering requirements."
      )
    )
  )
  .padding()
}
