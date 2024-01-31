// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic-api",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "logic-api",
      targets: ["logic-api"])
  ],
  dependencies: [
    .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.6.4"),
    .package(url: "https://github.com/kasketis/netfox", from: "1.21.0"),
    .package(
      name: "logic-business",
      path: "./logic-business"
    ),
    .package(
      name: "logic-analytics",
      path: "./logic-analytics"
    ),
    .package(name: "logic-test", path: "./logic-test")
  ],
  targets: [
    .target(
      name: "logic-api",
      dependencies: [
        "logic-business",
        "logic-analytics",
        .product(
          name: "Alamofire",
          package: "Alamofire"
        ),
        .product(
          name: "netfox",
          package: "netfox"
        )
      ],
      path: "./Sources"
    ),
    .testTarget(
      name: "logic-api-test",
      dependencies: [
        "logic-analytics",
        "logic-business",
        "logic-api",
        "logic-test"
      ],
      path: "./Tests"
    )
  ]
)
