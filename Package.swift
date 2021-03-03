// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Tina",
    platforms: [.iOS(.v10), .macOS(.v10_12), .tvOS(.v10), .watchOS(.v3)],
    products: [
        .library(name: "Tina", targets: ["Tina"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.4.0")),
//        .package(url: "https://github.com/KKLater/SmartCodable.git", .upToNextMajor(from: "0.0.1"))
        .package(url: "https://github.com/KKLater/SmartCodable.git", .branch("dev"))


    ],
    targets: [
        .target(name: "Tina", dependencies: ["Alamofire", "SmartCodable"]),
        .testTarget(name: "TinaTests", dependencies: ["Tina"]),
    ]
)
