// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "feature_startup",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "feature_startup",
      targets: ["feature_startup"]
    )
  ],
  dependencies: [
    .package(name: "logic_business", path: "./logic_business"),
    .package(name: "logic_ui", path: "./logic_ui"),
    .package(name: "logic_api", path: "./logic_api")
  ],
  targets: [
    .target(
      name: "feature_startup",
      dependencies: [
        "logic_business",
        "logic_ui",
        "logic_api"
      ],
      path: "./Sources"
    ),
    .testTarget(
      name: "feature_startup_test",
      dependencies: [
        "feature_startup",
        "logic_business",
        "logic_ui",
        "logic_api",
      ],
      path: "./Tests"
    ),
  ]
)
