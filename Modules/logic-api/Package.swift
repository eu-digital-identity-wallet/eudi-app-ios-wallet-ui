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
      url: "https://github.com/Brightify/Cuckoo.git",
      .upToNextMinor(from: "1.9.1")
    )
  ],
  targets: [
    .target(
      name: "logic-api",
      dependencies: [
        "logic-business",
        .product(
          name: "Alamofire",
          package: "Alamofire"
        ),
        .product(
          name: "netfox",
          package: "netfox"
        ),
        .product(
          name: "Cuckoo",
          package: "Cuckoo"
        )
      ],
      path: "./Sources"
    ),
    .testTarget(
      name: "logic-api-test",
      dependencies: [
        "logic-business",
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
