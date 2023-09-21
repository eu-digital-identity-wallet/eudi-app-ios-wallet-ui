// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "feature_onboarding",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "feature_onboarding",
      targets: ["feature_onboarding"]
    )
  ],
  dependencies: [
    .package(name: "logic_business", path: "./logic_business"),
    .package(name: "logic_ui", path: "./logic_ui"),
    .package(name: "logic_api", path: "./logic_api")
  ],
  targets: [
    .target(
      name: "feature_onboarding",
      dependencies: [
        "logic_business",
        "logic_ui",
        "logic_api"
      ],
      path: "./Sources"
    )
  ]
)
