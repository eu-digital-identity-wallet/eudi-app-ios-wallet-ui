// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic-analytics",
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: "logic-analytics",
      targets: ["logic-analytics"])
  ],
  dependencies: [
    .package(
      name: "logic-business",
      path: "./logic-business"
    )
  ],
  targets: [
    .target(
      name: "logic-analytics",
      dependencies: [
        "logic-business"
      ],
      path: "./Sources"
    )
  ]
)
