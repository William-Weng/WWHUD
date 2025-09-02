// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWHUD",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "WWHUD", targets: ["WWHUD"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "WWHUD", resources: [.process("Xib") , .copy("Privacy")])
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
