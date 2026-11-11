// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SahamBandarScreener",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "SahamBandarScreener",
            targets: ["SahamBandarScreener"]
        ),
    ],
    targets: [
        .target(
            name: "SahamBandarScreener",
            dependencies: [],
            path: "Sources/SahamBandarScreener"
        ),
        .testTarget(
            name: "SahamBandarScreenerTests",
            dependencies: ["SahamBandarScreener"],
            path: "Tests/SahamBandarScreenerTests"
        ),
    ]
)
