// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic_ui",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "logic_ui",
      targets: ["logic_ui"]
    )
  ],
  dependencies: [
    .package(
      name: "logic_business",
      path: "./logic_business"
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
    )
  ],
  targets: [
    .target(
      name: "logic_ui",
      dependencies: [
        "logic_business",
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
    )
  ]
)
