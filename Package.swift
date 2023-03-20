// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AmiiboAPI",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v11),
        .tvOS(.v11),
        .watchOS(.v4),
    ],
    products: [
        .library(
            name: "AmiiboAPI",
            targets: ["AmiiboAPI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.1"))
    ],
    targets: [
        .target(
            name: "AmiiboAPI",
            dependencies: ["Alamofire"]
        ),
        .testTarget(
            name: "AmiiboAPITests",
            dependencies: ["AmiiboAPI"]
        ),
    ]
)
