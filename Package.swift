// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "GithubStats",
  platforms: [
    .macOS(.v12)
  ],
  products: [
    .executable(
      name: "GithubStats",
      targets: ["GithubStats"]),
    .library(
      name: "GithubStatsCore",
      targets: ["GithubStatsCore"])
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.4"),
    .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.1")
  ],
  targets: [
    .executableTarget(
      name: "GithubStats",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        "GithubStatsCore"
      ]),
    .target(
      name: "GithubStatsCore",
      dependencies: [
        .product(name: "Rainbow", package: "Rainbow")
      ]),
    .testTarget(
      name: "GithubStatsTests",
      dependencies: ["GithubStatsCore"])
  ])
