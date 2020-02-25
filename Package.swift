// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ThirdPartyJWTAuthentication",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "ThirdPartyJWTAuthentication",
            targets: ["ThirdPartyJWTAuthentication"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-beta"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0-beta"),
        .package(url: "https://github.com/vapor/jwt.git", from: "4.0.0-beta")
    ],
    targets: [
        .target(
            name: "ThirdPartyJWTAuthentication",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "JWT", package: "jwt")
        ]),
        .testTarget(
            name: "ThirdPartyJWTAuthenticationTests",
            dependencies: ["ThirdPartyJWTAuthentication"]),
    ]
)
