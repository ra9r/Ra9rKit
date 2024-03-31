// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Ra9rKit",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Ra9rCore",
            targets: ["Ra9rCore"]),
        .library(
            name: "Ra9rUI",
            targets: ["Ra9rUI"]),
        .library(
            name: "Ra9rCrypto",
            targets: ["Ra9rCrypto"]),
        .library(
            name: "Ra9rNotification",
            targets: ["Ra9rNotification"]),
        .library(
            name: "Ra9rPDF",
            targets: ["Ra9rPDF"])
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Ra9rCore"),
        .target(
            name: "Ra9rCrypto"),
        .target(
            name: "Ra9rNotification"),
        .target(
            name: "Ra9rUI",
            dependencies: ["Ra9rCore"]),
        .target(
            name: "Ra9rPDF"),
        .testTarget(
            name: "Ra9rCryptoTests",
            dependencies: ["Ra9rCrypto"]),
        .testTarget(
            name: "Ra9rCoreTests",
            dependencies: ["Ra9rCore"]),
    ]
)
