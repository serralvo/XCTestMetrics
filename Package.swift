// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Tractor",
    dependencies: [
    ],
    targets: [
        .target(name: "TractorCore"),
        .target(name: "Tractor", dependencies: ["TractorCore"]),
        .testTarget(name: "TractorTests", dependencies: ["Tractor"]),
    ]
)
