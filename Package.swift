// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWHUD",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "WWHUD", targets: ["WWHUD"]),
    ],
    dependencies: [
        .package(url: "https://github.com/William-Weng/WWPrint.git", from: "1.2.0"),
    ],
    targets: [
        .target(name: "WWHUD", dependencies: []),
        .testTarget(name: "WWHUDTests", dependencies: ["WWHUD"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
