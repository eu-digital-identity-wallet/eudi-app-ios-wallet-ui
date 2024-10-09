// swift-tools-version: 6.0.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "feature-login",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "feature-login",
      targets: ["feature-login"]
    )
  ],
  dependencies: [
    .package(name: "feature-common", path: "./feature-common"),
    .package(name: "feature-test", path: "./feature-test")
  ],
  targets: [
    .target(
      name: "feature-login",
      dependencies: [
        "feature-common"
      ],
      path: "./Sources"
    ),
    .testTarget(
      name: "feature-login-tests",
      dependencies: [
        "feature-login",
        "feature-common",
        "feature-test"
      ],
      path: "./Tests"
    )
  ]
)
