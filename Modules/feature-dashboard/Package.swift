// swift-tools-version: 6.0.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "feature-dashboard",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "feature-dashboard",
      targets: ["feature-dashboard"])
  ],
  dependencies: [
    .package(name: "feature-common", path: "./feature-common"),
    .package(name: "feature-test", path: "./feature-test")
  ],
  targets: [
    .target(
      name: "feature-dashboard",
      dependencies: [
        "feature-common"
      ],
      path: "./Sources"
    ),
    .testTarget(
      name: "feature-dashboard-tests",
      dependencies: [
        "feature-dashboard",
        "feature-common",
        "feature-test"
      ],
      path: "./Tests")
  ]
)
