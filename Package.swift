// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "GithubActionsStats",
  platforms: [
    .macOS(.v12)
  ],
  products: [
    .executable(
      name: "GithubActionsStats",
      targets: ["GithubActionsStats"]),
    .library(
      name: "GithubActionsStatsCore",
      targets: ["GithubActionsStatsCore"])
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.4"),
  ],
  targets: [
    .executableTarget(
      name: "GithubActionsStats",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        "GithubActionsStatsCore"
      ]),
    .target(
      name: "GithubActionsStatsCore")
  ])
