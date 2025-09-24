// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic-assembly",
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: "logic-assembly",
      targets: ["logic-assembly"]
    )
  ],
  dependencies: [
    .package(name: "feature-common", path: "./feature-common"),
    .package(name: "feature-startup", path: "./feature-startup"),
    .package(name: "feature-dashboard", path: "./feature-dashboard"),
    .package(name: "feature-presentation", path: "./feature-presentation"),
    .package(name: "feature-issuance", path: "./feature-issuance"),
    .package(name: "feature-proximity", path: "./feature-proximity")
  ],
  targets: [
    .target(
      name: "logic-assembly",
      dependencies: [
        "feature-common",
        "feature-startup",
        "feature-dashboard",
        "feature-presentation",
        "feature-issuance",
        "feature-proximity"
      ],
      path: "./Sources"
    )
  ]
)
