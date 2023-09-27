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
      url: "https://github.com/pointfreeco/swift-dependencies.git",
      from: "1.0.0"
    ),
    .package(
      name: "Firebase",
      url: "https://github.com/firebase/firebase-ios-sdk",
      from: "10.3.0"
    ),
    .package(
      url: "https://github.com/Brightify/Cuckoo.git",
      .upToNextMinor(from: "1.9.1")
    )
  ],
  targets: [
    .target(
      name: "logic-business",
      dependencies: [
        .product(
          name: "Dependencies",
          package: "swift-dependencies"
        ),
        .product(name: "FirebaseCrashlytics", package: "Firebase"),
        .product(name: "FirebaseAnalytics", package: "Firebase")
      ],
      path: "./Sources"
    ),
    .testTarget(
      name: "logic-business-test",
      dependencies: [
        "logic-business",
        .product(
          name: "Dependencies",
          package: "swift-dependencies"
        ),
        .product(
          name: "Cuckoo",
          package: "Cuckoo"
        )
      ],
      path: "./Tests"
    )
  ]
)
