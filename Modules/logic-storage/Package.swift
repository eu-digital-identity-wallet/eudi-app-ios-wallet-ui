// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic-storage",
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: "logic-storage",
      targets: ["logic-storage"]
    )
  ],
  dependencies: [
    .package(
      name: "logic-business",
      path: "./logic-business"
    ),
    .package(
      name: "logic-resources",
      path: "./logic-resources"
    )
  ],
  targets: [
    .target(
      name: "logic-storage",
      dependencies: [
        "logic-business",
        "logic-resources"
      ],
      path: "./Sources"
    )
  ]
)
