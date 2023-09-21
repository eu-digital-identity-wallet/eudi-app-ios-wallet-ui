// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic_api",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "logic_api",
      targets: ["logic_api"])
  ],
  dependencies: [
    .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.6.4"),
    .package(url: "https://github.com/kasketis/netfox", from: "1.21.0"),
    .package(
      name: "logic_business",
      path: "./logic_business"
    )
  ],
  targets: [
    .target(
      name: "logic_api",
      dependencies: [
        "logic_business",
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
    )
  ]
)
