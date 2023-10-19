// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic-navigation",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "logic-navigation",
      targets: ["logic-navigation"]
    )
  ],
  dependencies: [
    .package(name: "feature-common", path: "./feature-common"),
    .package(name: "feature-startup", path: "./feature-startup"),
    .package(name: "feature-login", path: "./feature-login"),
    .package(name: "feature-dashboard", path: "./feature-dashboard"),
    .package(name: "feature-authentication", path: "./feature-authentication")
  ],
  targets: [
    .target(
      name: "logic-navigation",
      dependencies: [
        "feature-common",
        "feature-startup",
        "feature-login",
        "feature-dashboard",
        "feature-authentication"
      ],
      path: "./Sources"
    )
  ]
)
