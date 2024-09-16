// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic-resources",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "logic-resources",
      targets: ["logic-resources"])
  ],
  targets: [
    .target(
      name: "logic-resources",
      path: "./Sources",
      resources: [
        .process("Resources")
      ]
    )
  ]
)
