// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic-api",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "logic-api",
      targets: ["logic-api"])
  ],
  dependencies: [
    .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.6.4"),
    .package(
      name: "logic-business",
      path: "./logic-business"
    ),
    .package(
      name: "logic-analytics",
      path: "./logic-analytics"
    ),
    .package(
      name: "logic-core",
      path: "./logic-core"
    ),
    .package(name: "logic-test", path: "./logic-test")
  ],
  targets: [
    .target(
      name: "logic-api",
      dependencies: [
        "logic-business",
        "logic-core",
        "logic-analytics",
        .product(
          name: "Alamofire",
          package: "Alamofire"
        )
      ],
      path: "./Sources"
    ),
    .testTarget(
      name: "logic-api-tests",
      dependencies: [
        "logic-api",
        "logic-analytics",
        "logic-business",
        "logic-core",
        "logic-test"
      ],
      path: "./Tests"
    )
  ]
)
