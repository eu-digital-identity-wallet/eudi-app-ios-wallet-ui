// swift-tools-version: 6.0.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic-core",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "logic-core",
      targets: ["logic-core"])
  ],
  dependencies: [
    .package(
      url: "https://github.com/eu-digital-identity-wallet/eudi-lib-ios-wallet-kit.git",
      exact: "0.11.4"
    ),
    .package(
      name: "logic-resources",
      path: "./logic-resources"
    ),
    .package(
      name: "logic-business",
      path: "./logic-business"
    ),
    .package(
      name: "logic-storage",
      path: "./logic-storage"
    )
  ],
  targets: [
    .target(
      name: "logic-core",
      dependencies: [
        "logic-resources",
        "logic-business",
        "logic-storage",
        .product(
          name: "EudiWalletKit",
          package: "eudi-lib-ios-wallet-kit"
        )
      ],
      path: "./Sources"
    )
  ]
)
