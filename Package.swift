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
        .executable(
            name: "SahamBandarScreenerApp",
            targets: ["SahamBandarScreenerApp"]
        ),
    ],
    targets: [
        .target(
            name: "SahamBandarScreener",
            dependencies: [],
            path: "Sources/SahamBandarScreener"
        ),
        .executableTarget(
            name: "SahamBandarScreenerApp",
            dependencies: ["SahamBandarScreener"],
            path: "Sources/App"
        ),
        .testTarget(
            name: "SahamBandarScreenerTests",
            dependencies: ["SahamBandarScreener"],
            path: "Tests/SahamBandarScreenerTests"
        ),
    ]
)
