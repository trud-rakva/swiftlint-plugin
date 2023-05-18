// swift-tools-version: 5.6

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
            url: "https://github.com/realm/SwiftLint/releases/download/0.52.2/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "89651e1c87fb62faf076ef785a5b1af7f43570b2b74c6773526e0d5114e0578e"
        )
    ]
)
