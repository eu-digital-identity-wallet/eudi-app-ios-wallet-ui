// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "feature-proximity",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "feature-proximity",
      targets: ["feature-proximity"])
  ],
  dependencies: [
    .package(name: "feature-common", path: "./feature-common"),
    .package(name: "feature-test", path: "./feature-test")
  ],
  targets: [
    .target(
      name: "feature-proximity",
      dependencies: [
        "feature-common"
      ],
      path: "./Sources"
    ),
    .testTarget(
      name: "feature-proximity-tests",
      dependencies: [
        "feature-proximity",
        "feature-common",
        "feature-test"
      ],
      path: "./Tests"
    )
  ]
)
