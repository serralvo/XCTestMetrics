// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Tractor",
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Files", from: "4.0.0"),
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
        .package(url: "https://github.com/johnsundell/plot.git", from: "0.1.0")
    ],
    targets: [
        .target(name: "TractorCore", dependencies: [
            "Files",
            "ShellOut",
            "Entity",
            "Display"
        ]),
        .target(name: "TractorReport", dependencies: [
            "Files",
            "Plot",
            "Entity",
            "Display",
            "TractorCore"
        ]),
        .target(name: "Display", dependencies: []),
        .target(name: "Entity", dependencies: []),
        .target(name: "Tractor", dependencies: [
            "TractorCore",
            "TractorReport",
            "ArgumentParser"
        ]),
        .testTarget(name: "TractorTests", dependencies: ["Tractor"]),
    ]
)
