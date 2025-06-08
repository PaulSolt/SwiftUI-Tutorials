// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Calculator",
    products: [
        .library(
            name: "Calculator",
            targets: ["Calculator"]),
    ],

    targets: [
        .target(
            name: "Calculator",
            exclude: [
                "Demo.swift"
            ],
            publicHeadersPath: "include"
        ),
        .testTarget(
            name: "CalculatorTests",
            dependencies: ["Calculator"]
        ),
        .testTarget(
            name: "CalculatorTests-Objc",
            dependencies: ["Calculator"]
        ),
    ]
)
