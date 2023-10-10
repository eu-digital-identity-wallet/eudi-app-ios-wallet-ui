// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic-business",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "logic-business",
      targets: ["logic-business"]
    )
  ],
  dependencies: [
    .package(
      url: "https://github.com/firebase/firebase-ios-sdk",
      from: "10.3.0"
    ),
    .package(name: "logic-test", path: "./logic-test")
  ],
  targets: [
    .target(
      name: "logic-business",
      dependencies: [
        .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
        .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk")
      ],
      path: "./Sources"
    ),
    .testTarget(
      name: "logic-business-test",
      dependencies: [
        "logic-business",
        "logic-test"
      ],
      path: "./Tests"
    )
  ]
)
