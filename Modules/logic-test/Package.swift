// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic-test",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "logic-test",
      targets: ["logic-test"]
    )
  ],
  dependencies: [
    .package(
      url: "https://github.com/Brightify/Cuckoo.git",
      .upToNextMinor(from: "1.9.1")
    )
  ],
  targets: [
    .target(
      name: "logic-test",
      dependencies: [
        .product(
          name: "Cuckoo",
          package: "Cuckoo"
        )
      ]
    )
  ]
)
