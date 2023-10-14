// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "feature-authentication",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "feature-authentication",
      targets: ["feature-authentication"])
  ],
  dependencies: [
    .package(name: "feature-common", path: "./feature-common"),
    .package(name: "feature-test", path: "./feature-test")
  ],
  targets: [
    .target(
      name: "feature-authentication",
      dependencies: [
        "feature-common"
      ],
      path: "./Sources"
    ),
    .testTarget(
      name: "feature-authenticationTests",
      dependencies: [
        "feature-authentication",
        "feature-common",
        "feature-test"
      ],
      path: "./Tests"
    )
  ]
)
