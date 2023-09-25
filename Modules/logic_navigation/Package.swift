// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic_navigation",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "logic_navigation",
      targets: ["logic_navigation"]
    )
  ],
  dependencies: [
    .package(name: "feature_onboarding", path: "./feature_onboarding")
  ],
  targets: [
    .target(
      name: "logic_navigation",
      dependencies: [
        "feature_onboarding"
      ],
      path: "./Sources"
    ),
    .testTarget(
      name: "logic_navigation_test",
      dependencies: [
        "feature_onboarding",
      ],
      path: "./Tests"
    ),
  ]
)
