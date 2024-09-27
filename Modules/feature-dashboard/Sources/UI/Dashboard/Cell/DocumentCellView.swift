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
import SwiftUI
import logic_resources
import logic_ui

extension DocumentListView {
  struct DocumentCellView: View {

    let item: DocumentUIModel
    let action: (DocumentUIModel) -> Void
    let isLoading: Bool

    init(
      item: DocumentUIModel,
      isLoading: Bool,
      action: @escaping (DocumentUIModel) -> Void
    ) {
      self.item = item
      self.isLoading = isLoading
      self.action = action
    }

    var body: some View {
      Button(
        action: {
          action(item)
        },
        label: {
          VStack(spacing: .zero) {

            ZStack(alignment: .topTrailing) {

              Theme.shared.image.id
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Theme.shared.color.primary)

              if item.value.hasExpired {
                ZStack {
                  Theme.shared.image.warning
                    .renderingMode(.template)
                    .foregroundColor(Theme.shared.color.warning)
                    .padding(2)
                    .background(Theme.shared.color.backgroundDefault)
                }
                .background(Theme.shared.color.backgroundPaper)
                .clipShape(Circle())
              }
            }
            .frame(maxWidth: 48)

            VSpacer.small()

            Text(.custom(item.value.title))
              .typography(Theme.shared.font.titleMedium)
              .foregroundColor(Theme.shared.color.textPrimaryDark)
              .minimumScaleFactor(0.5)
              .lineLimit(1)

            if let expiresAt = item.value.expiresAt {

              Spacer()

              if item.value.hasExpired {
                ZStack {
                  Text(.expired)
                    .typography(Theme.shared.font.bodySmall)
                    .foregroundColor(Theme.shared.color.warning)
                  + Text(.space)
                  + Text(.onExpired([expiresAt]))
                    .typography(Theme.shared.font.bodySmall)
                    .foregroundColor(Theme.shared.color.textSecondaryDark)
                }
                .lineLimit(2)
                .minimumScaleFactor(0.5)

              } else {
                Text(.validUntil([expiresAt]))
                  .typography(Theme.shared.font.bodySmall)
                  .foregroundColor(Theme.shared.color.textSecondaryDark)
                  .minimumScaleFactor(0.5)
                  .lineLimit(2)
              }
            }
          }
        }
      )
      .frame(maxWidth: .infinity, alignment: .center)
      .padding()
      .background(Theme.shared.color.backgroundDefault)
      .clipShape(.rect(cornerRadius: 16))
      .shimmer(isLoading: isLoading)
    }
  }
}

extension DocumentListView {
  struct DocumentDeferredCellView: View {

    let item: DocumentUIModel
    let action: (DocumentUIModel) -> Void
    let isLoading: Bool
    let color: Color
    let icon: Image
    let status: LocalizableString.Key

    init(
      item: DocumentUIModel,
      isLoading: Bool,
      color: Color,
      icon: Image,
      status: LocalizableString.Key,
      action: @escaping (DocumentUIModel) -> Void
    ) {
      self.item = item
      self.isLoading = isLoading
      self.color = color
      self.icon = icon
      self.status = status
      self.action = action
    }

    var body: some View {
      Button(
        action: {
          action(item)
        },
        label: {
          VStack(spacing: .zero) {

            ZStack(alignment: .topTrailing) {

              Theme.shared.image.id
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Theme.shared.color.textDisabledDark)

              ZStack {
                icon
                  .renderingMode(.template)
                  .foregroundColor(color)
                  .padding(2)
                  .background(Theme.shared.color.backgroundDefault)
              }
              .background(Theme.shared.color.backgroundPaper)
              .clipShape(Circle())
            }
            .frame(maxWidth: 48)

            VSpacer.small()

            Text(.custom(item.value.title))
              .typography(Theme.shared.font.titleMedium)
              .foregroundColor(Theme.shared.color.textDisabledDark)
              .minimumScaleFactor(0.5)
              .lineLimit(1)

            Spacer()

            Text(status)
              .typography(Theme.shared.font.bodySmall)
              .foregroundColor(color)
              .minimumScaleFactor(0.5)
              .lineLimit(2)
          }
        }
      )
      .frame(maxWidth: .infinity, alignment: .center)
      .padding()
      .background(Theme.shared.color.backgroundDefault)
      .clipShape(.rect(cornerRadius: 16))
      .overlay {
        RoundedRectangle(cornerRadius: 16)
          .stroke(style: StrokeStyle(lineWidth: 1, dash: [6]))
          .foregroundStyle(Theme.shared.color.textDisabledDark)
      }
      .shimmer(isLoading: isLoading)
    }
  }
}
