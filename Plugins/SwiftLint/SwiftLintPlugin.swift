import PackagePlugin

@main
struct SwiftLintPlugin: BuildToolPlugin {

    /// This entry point is called when operating on a Swift package.
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        print("context: \(context)")
        print("target: \(target)")
        return [
            .buildCommand(
                displayName: " -*- SwiftLint Build Tool Plugin execution for Swift package \(target.name) -*-",
                executable: try context.tool(named: "swiftlint").path,
                arguments: [
                    "lint",
                    "--config", "\(context.package.directory.appending(".swiftlint.yml"))",
                    "--cache-path", "\(context.pluginWorkDirectory.appending("cache"))",
                    "\(target.directory)"
                ]
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
        print("target: \(target)")
        return [
            .buildCommand(
                displayName: " -*- SwifLint Build Tool Plugin execution for Xcode project \(target.displayName) -*-",
                executable: try context.tool(named: "swiftlint").path,
                arguments: [
                    "lint",
                    "--config", "\(context.xcodeProject.directory.appending(".swiftlint.yml"))",
                    "--cache-path", "\(context.pluginWorkDirectory.appending("cache"))",
                    "\(context.xcodeProject.directory)"
                ]
            )
        ]
    }
}
#endif
