// swift-tools-version: 6.0.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic-test",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "logic-test",
      targets: ["logic-test"]
    )
  ],
  dependencies: [
    .package(
      url: "https://github.com/Brightify/Cuckoo.git",
      from: "2.0.9"
    ),
    .package(
      url: "https://github.com/groue/CombineExpectations.git",
      from: "0.10.0"
    )
  ],
  targets: [
    .target(
      name: "logic-test",
      dependencies: [
        "CombineExpectations",
        .product(
          name: "Cuckoo",
          package: "Cuckoo"
        )
      ],
      path: "./Sources"
    )
  ]
)
