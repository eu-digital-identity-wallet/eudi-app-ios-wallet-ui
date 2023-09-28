// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic-ui",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "logic-ui",
      targets: ["logic-ui"]
    )
  ],
  dependencies: [
    .package(
      name: "logic-business",
      path: "./logic-business"
    ),
    .package(
      url: "https://github.com/canopas/UIPilot.git",
      from: "2.0.0"
    ),
    .package(
      url: "https://github.com/twostraws/CodeScanner",
      from: "2.0.0"
    ),
    .package(
      url: "https://github.com/exyte/ActivityIndicatorView.git",
      from: "1.1.1"
    ),
    .package(
      url: "https://github.com/elai950/AlertToast.git",
      from: "1.3.9"
    ),
    .package(name: "logic-test", path: "./logic-test")
  ],
  targets: [
    .target(
      name: "logic-ui",
      dependencies: [
        "logic-business",
        .product(
          name: "CodeScanner",
          package: "CodeScanner"
        ),
        .product(
          name: "UIPilot",
          package: "UIPilot"
        ),
        .product(
          name: "ActivityIndicatorView",
          package: "ActivityIndicatorView"
        ),
        .product(
          name: "AlertToast",
          package: "AlertToast"
        )
      ],
      path: "./Sources"
    ),
    .testTarget(
      name: "logic-ui-test",
      dependencies: [
        "logic-ui",
        "logic-business",
        "logic-test"
      ],
      path: "./Tests"
    )
  ]
)
