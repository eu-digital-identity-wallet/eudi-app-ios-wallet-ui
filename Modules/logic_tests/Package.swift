// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic_tests",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "logic_tests",
      targets: ["logic_tests_target"]
    )
  ],
  dependencies: [
    .package(name: "feature_onboarding", path: "./feature_onboarding"),
    .package(name: "logic_navigation", path: "./modules/logic_navigation"),
    .package(name: "logic_api", path: "./logic_api"),
    .package(name: "logic_ui", path: "./logic_ui"),
    .package(name: "logic_business", path: "./logic_business"),
  ],
  targets: [
    .testTarget(
      name: "logic_tests_target",
      dependencies: [
        "feature_onboarding",
        "logic_navigation",
        "logic_api",
        "logic_ui",
        "logic_business",
      ],
      path: "./Tests"
    ),
  ]
)
