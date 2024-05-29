// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SwiftLintPlugin",

    products: [
        .plugin(name: "SwiftLint", targets: ["SwiftLint"]),
        .plugin(name: "SwiftLintCommand", targets: ["SwiftLintCommand"])
    ],

    targets: [
        .plugin(
            name: "SwiftLint",
            capability: .buildTool(),
            dependencies: ["SwiftLintBinary"]
        ),

        .plugin(
            name: "SwiftLintCommand",
            capability: .command(
                intent: .custom(
                    verb: "swiftlint",
                    description: "Switlint Command."
                )
            ),
            dependencies: ["SwiftLintBinary"]
        ),

        .binaryTarget(
            name: "SwiftLintBinary",
            url: "https://github.com/realm/SwiftLint/releases/download/0.55.1/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "722a705de1cf4e0e07f2b7d2f9f631f3a8b2635a0c84cce99f9677b38aa4a1d6"
        )
    ]
)
