// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic-authentication",
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: "logic-authentication",
      targets: ["logic-authentication"])
  ],
  dependencies: [
    .package(
      name: "logic-business",
      path: "./logic-business"
    ),
    .package(
      name: "logic-core",
      path: "./logic-core"
    ),
    .package(
      name: "logic-analytics",
      path: "./logic-analytics"
    ),
    .package(
      name: "logic-resources",
      path: "./logic-resources"
    ),
    .package(
      name: "logic-test",
      path: "./logic-test"
    )
  ],
  targets: [
    .target(
      name: "logic-authentication",
      dependencies: [
        "logic-core",
        "logic-business",
        "logic-resources",
        "logic-analytics"
      ],
      path: "./Sources"
    ),
    .testTarget(
      name: "logic-authentication-tests",
      dependencies: [
        "logic-authentication",
        "logic-core",
        "logic-business",
        "logic-analytics",
        "logic-test"
      ],
      path: "./Tests"
    )
  ]
)
