// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "feature-test",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "feature-test",
      targets: ["feature-test"]
    )
  ],
  dependencies: [
    .package(name: "logic-core", path: "./logic-core"),
    .package(name: "logic-test", path: "./logic-test"),
    .package(name: "logic-business", path: "./logic-business"),
    .package(name: "logic-ui", path: "./logic-ui"),
    .package(name: "logic-api", path: "./logic-api"),
    .package(name: "logic-analytics", path: "./logic-analytics"),
    .package(name: "logic-authentication", path: "./logic-authentication")
  ],
  targets: [
    .target(
      name: "feature-test",
      dependencies: [
        "logic-core",
        "logic-test",
        "logic-business",
        "logic-ui",
        "logic-api",
        "logic-analytics",
        "logic-authentication"
      ],
      path: "./Sources"
    )
  ]
)
