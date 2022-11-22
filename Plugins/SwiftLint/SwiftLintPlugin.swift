import PackagePlugin

@main
struct SwiftLintPlugin: BuildToolPlugin {

    /// This entry point is called when operating on a Swift package.
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        print("context: \(context)")
        print(" target: \(target)")
        return [
            .buildCommand(
                displayName: "SwiftLint Build Tool Plugin execution for Swift package \(target.name)",
                executable: try context.tool(named: "swiftlint").path,
                arguments: [
                    "lint",
                    "--config", "\(context.package.directory.string)/.swiftlint.yml",
                    "--cache-path", "\(context.pluginWorkDirectory.string)/cache",
                    target.directory.string
                ],
                environment: [:]
            )
        ]
    }

}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftLintPlugin: XcodeBuildToolPlugin {

    /// This entry point is called when operating on an Xcode project.
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        print("context: \(context)")
        print(" target: \(target)")
        return [
            .buildCommand(
                displayName: "SwifLint Build Tool Plugin execution for Xcode project \(target.displayName)",
                executable: try context.tool(named: "swiftlint").path,
                arguments: [
                    "lint",
                    "--config", "\(context.xcodeProject.directory.string)/.swiftlint.yml",
                    "--cache-path", "\(context.pluginWorkDirectory.string)/cache",
                    context.xcodeProject.directory.string
                ],
                environment: [:]
            )
        ]
    }
}
#endif
