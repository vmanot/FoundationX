// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "FoundationX",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "FoundationX", targets: ["FoundationX"])
    ],
    dependencies: [
        .package(url: "https://github.com/vmanot/Swallow.git", .branch("master"))
    ],
    targets: [
        .target(name: "FoundationX", dependencies: ["Swallow"], path: "Sources")
    ]
)
