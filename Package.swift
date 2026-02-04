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
        .package(url: "https://github.com/William-Weng/WWSVGImageView", from: "1.0.2")
    ],
    targets: [
        .target(name: "WWHUD", dependencies: ["WWSVGImageView"], resources: [.process("Xib") , .copy("Privacy")])
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
