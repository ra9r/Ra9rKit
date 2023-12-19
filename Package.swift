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
            name: "Ra9rAuth",
            targets: ["Ra9rAuth"]),
        .library(
            name: "Ra9rUI",
            targets: ["Ra9rUI"]),
        .library(
            name: "Ra9rPDF",
            targets: ["Ra9rPDF"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "10.19.1")),
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", .upToNextMajor(from: "7.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Ra9rCore"),
        .target(
            name: "Ra9rAuth",
            dependencies: [
                "Ra9rCore",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                //                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                //                .product(name: "FirebaseAnalyticsSwift", package: "firebase-ios-sdk"),
                //                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                //                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk"),
                //                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
                    .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
                .product(name: "GoogleSignInSwift", package: "GoogleSignIn-iOS")
            ]),
        .target(
            name: "Ra9rUI",
            dependencies: ["Ra9rCore"]),
        .target(
            name: "Ra9rPDF"),
        .testTarget(
            name: "Ra9rCoreTests",
            dependencies: ["Ra9rCore"]),
    ]
)
