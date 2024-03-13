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
    ],
    targets: [
        .target(name: "WWHUD", resources: [.copy("Privacy")])
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
