// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "feature-login",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "feature-login",
      targets: ["feature-login"]
    )
  ],
  dependencies: [
    .package(name: "logic-business", path: "./logic-business"),
    .package(name: "logic-ui", path: "./logic-ui"),
    .package(name: "logic-api", path: "./logic-api"),
    .package(name: "feature-test", path: "./feature-test")
  ],
  targets: [
    .target(
      name: "feature-login",
      dependencies: [
        "logic-business",
        "logic-ui",
        "logic-api"
      ],
      path: "./Sources"
    ),
    .testTarget(
      name: "feature-login-tests",
      dependencies: [
        "feature-login",
        "logic-business",
        "logic-ui",
        "logic-api",
        "feature-test"
      ],
      path: "./Tests")
  ]
)
