// swift-tools-version: 6.0.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic-business",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "logic-business",
      targets: ["logic-business"]
    )
  ],
  dependencies: [
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
      url: "https://github.com/rhummelmose/BluetoothKit.git",
      branch: "master"
    ),
    .package(
      url: "https://github.com/Swinject/Swinject.git",
      from: "2.8.4"
    ),
    .package(
      url: "https://github.com/eu-digital-identity-wallet/SwiftCopyableMacro.git",
      from: "0.0.1"
    ),
    .package(
      url: "https://github.com/eu-digital-identity-wallet/eudi-lib-ios-rqes-ui.git",
      exact: "0.1.2"
    ),
    .package(name: "logic-test", path: "./logic-test")
  ],
  targets: [
    .target(
      name: "logic-business",
      dependencies: [
        "logic-resources",
        "KeychainAccess",
        "BluetoothKit",
        "Swinject",
        .product(
          name: "Peppermint",
          package: "peppermint"
        ),
        .product(
          name: "libPhoneNumber",
          package: "libPhoneNumber-iOS"
        ),
        .product(
          name: "Copyable",
          package: "SwiftCopyableMacro"
        ),
        .product(
          name: "EudiRQESUi",
          package: "eudi-lib-ios-rqes-ui"
        )
      ],
      path: "./Sources"
    ),
    .testTarget(
      name: "logic-business-tests",
      dependencies: [
        "logic-business",
        "logic-test"
      ],
      path: "./Tests"
    )
  ]
)
