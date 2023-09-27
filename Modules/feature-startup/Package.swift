// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "feature-startup",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "feature-startup",
      targets: ["feature-startup"]
    )
  ],
  dependencies: [
    .package(name: "logic-business", path: "./logic-business"),
    .package(name: "logic-ui", path: "./logic-ui"),
    .package(name: "logic-api", path: "./logic-api"),
    .package(
      url: "https://github.com/Brightify/Cuckoo.git",
      .upToNextMinor(from: "1.9.1")
    )
  ],
  targets: [
    .target(
      name: "feature-startup",
      dependencies: [
        "logic-business",
        "logic-ui",
        "logic-api"
      ],
      path: "./Sources"
    ),
    .testTarget(
      name: "feature-startup-test",
      dependencies: [
        "feature-startup",
        "logic-business",
        "logic-ui",
        "logic-api",
        .product(
          name: "Cuckoo",
          package: "Cuckoo"
        )
      ],
      path: "./Tests"
    )
  ]
)
