// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic-storage",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "logic-storage",
      targets: ["logic-storage"]
    )
  ],
  dependencies: [
    .package(
      url: "https://github.com/realm/realm-swift.git",
      from: "10.54.1"
    ),
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
        "logic-resources",
        .product(name: "RealmSwift", package: "realm-swift")
      ],
      path: "./Sources"
    )
  ]
)
