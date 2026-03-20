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
import SwiftUI
import IdentityDocumentServices
import IdentityDocumentServicesUI
import DcApi18013AnnexC
import MdocDataModel18013
import WalletStorage

struct RequestAuthorizationView: View {
  let context: ISO18013MobileDocumentRequestContext
  let dcApiHandler: DcApiHandler
  @State var websiteName: String?
  @State var requestSet: ISO18013MobileDocumentRequest.DocumentRequestSet?
  @State var errorMessage: String?

  var body: some View {
    VStack(alignment: .center) {
      if let requestSet, let websiteName {
        Text(websiteName).font(.headline).padding(.bottom, 6)
        List {
          VStack(alignment: .leading) {
            ForEach(requestSet.requests, id: \.documentType) { rs in
              Text(rs.documentType).font(.title)
              let namespaces = Array(rs.namespaces.keys)
              ForEach(namespaces, id: \.self) { ns in
                Text(ns).font(.title2)
                let elements = Array(rs.namespaces[ns]!.keys)
                ForEach(elements, id: \.self) { el in
                  Text(el).fontWeight(
                    rs.namespaces[ns]![el]!.isRetaining ? .bold : .thin)
                }
              }
            }
          }
        }
        if let errorMessage { Text(verbatim: errorMessage).foregroundStyle(.red) }
        HStack(alignment: .bottom, spacing: 40) {
          Button {
            context.cancel()
          } label: {
            Label("Cancel", systemImage: "x.circle")
          }.buttonStyle(.bordered)
          if errorMessage == nil {
            Button {
              Task { try await self.acceptVerification() }
            } label: {
              Label("Accept", systemImage: "checkmark.seal")
            }.buttonStyle(.borderedProminent).glassEffect(.regular)
          }
        }
      } else {
        ContentUnavailableView("Cannot validate request",
                               image: "externaldrive.fill.trianglebadge.exclamationmark")
      }
    }.padding() // vstack
      .task {
        do {
          let (set, _, rn) = try await dcApiHandler.validateRequest(context.request)
          requestSet = set
          websiteName = context.requestingWebsiteOrigin?.absoluteString ?? rn ??
          "Website name not available"
        } catch {
          errorMessage = String(describing: error)
        }
      }
  } // body

  func acceptVerification() async throws {
    try await context.sendResponse { rawRequest in
      try await dcApiHandler.validateConsistency(request: context.request, rawRequest: rawRequest)
      // validate the signatures
      try await dcApiHandler.validateRawRequest(rawRequest: rawRequest)
      let responseData = try await dcApiHandler.buildAndEncryptResponse(
        request: context.request, rawRequest: rawRequest,
        originUrl: context.requestingWebsiteOrigin?.absoluteString)
      return ISO18013MobileDocumentResponse(responseData: responseData)
    }
  }
}
