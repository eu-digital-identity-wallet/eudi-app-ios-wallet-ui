// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic-business",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "logic-business",
      targets: ["logic-business"]
    )
  ],
  dependencies: [
    .package(
      url: "https://github.com/firebase/firebase-ios-sdk",
      from: "10.3.0"
    ),
    .package(
      url: "https://github.com/securing/IOSSecuritySuite.git",
      from: "1.9.5"
    ),
    .package(
      url: "https://github.com/kishikawakatsumi/KeychainAccess.git",
      from: "3.0.0"
    ),
    .package(
      url: "https://github.com/iziz/libPhoneNumber-iOS.git",
      branch: "master"
    ),
    .package(
      url: "https://github.com/nsagora/peppermint",
      from: "1.2.0"
    ),
    .package(
      name: "logic-resources",
      path: "./logic-resources"
    ),
    .package(
      url: "https://github.com/eu-digital-identity-wallet/eudi-lib-ios-wallet-kit.git",
      from: "0.1.0"
    )
    ,
    .package(name: "logic-test", path: "./logic-test")
  ],
  targets: [
    .target(
      name: "logic-business",
      dependencies: [
        "logic-resources",
        "IOSSecuritySuite",
        "KeychainAccess",
        .product(
          name: "Peppermint",
          package: "peppermint"
        ),
        .product(
          name: "libPhoneNumber",
          package: "libPhoneNumber-iOS"
        ),
        .product(
          name: "EudiWalletKit",
          package: "eudi-lib-ios-wallet-kit"
        ),
        .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
        .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk")
      ],
      path: "./Sources"
    ),
    .testTarget(
      name: "logic-business-test",
      dependencies: [
        "logic-business",
        "logic-test"
      ],
      path: "./Tests"
    )
  ]
)
