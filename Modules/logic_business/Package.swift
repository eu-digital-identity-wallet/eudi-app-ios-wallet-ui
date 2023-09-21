// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic_business",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "logic_business",
      targets: ["logic_business"]
    )
  ],
  dependencies: [
    .package(
      url: "https://github.com/eu-digital-identity-wallet/eudi-lib-ios-siop-openid4vp-swift.git",
      from: "0.0.62"
    )
  ],
  targets: [
    .target(
      name: "logic_business",
      dependencies: [
        .product(
          name: "SiopOpenID4VP",
          package: "eudi-lib-ios-siop-openid4vp-swift"
        )
      ],
      path: "./Sources"
    ),
    .testTarget(
      name: "logic_business_test",
      dependencies: [
        "logic_business",
        .product(
          name: "SiopOpenID4VP",
          package: "eudi-lib-ios-siop-openid4vp-swift"
        )
      ],
      path: "./Tests"
    ),
  ]
)
