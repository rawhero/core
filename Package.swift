// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Core",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "Core",
            targets: ["Core"]),
    ],
    dependencies: [
        .package(name: "Archivable", url: "https://github.com/archivable/package.git", .branch("main"))
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: ["Archivable"],
            path: "Sources"),
        .testTarget(
            name: "Tests",
            dependencies: ["Core"],
            path: "Tests"),
    ]
)
