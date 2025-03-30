// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "TreeWalk",
  platforms: [
    .macOS(.v10_15),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
  ],
  targets: [
    .executableTarget(
      name: "TreeWalk",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ]
    ),
    .testTarget(name: "Tests", dependencies: ["TreeWalk"]),
  ]
)
