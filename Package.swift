// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWHUD",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "WWHUD", targets: ["WWHUD"]),
    ],
    dependencies: [
        .package(name: "WWPrint", url: "https://github.com/William-Weng/WWPrint.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "WWHUD", dependencies: []),
        .testTarget(name: "WWHUDTests", dependencies: ["WWHUD"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
