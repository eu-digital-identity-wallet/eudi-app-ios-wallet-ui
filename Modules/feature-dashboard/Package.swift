// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "feature-dashboard",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "feature-dashboard",
      targets: ["feature-dashboard"])
  ],
  dependencies: [
    .package(name: "logic-business", path: "./logic-business"),
    .package(name: "logic-ui", path: "./logic-ui"),
    .package(name: "logic-api", path: "./logic-api"),
    .package(name: "feature-test", path: "./feature-test")
  ],
  targets: [
    .target(
      name: "feature-dashboard",
      dependencies: [
        "logic-business",
        "logic-ui",
        "logic-api"
      ],
      path: "./Sources"
    ),
    .testTarget(
      name: "feature-dashboard-tests",
      dependencies: [
        "feature-dashboard",
        "logic-business",
        "logic-ui",
        "logic-api",
        "feature-test"
      ],
      path: "./Tests")
  ]
)
