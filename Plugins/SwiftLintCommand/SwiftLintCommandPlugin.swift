import PackagePlugin

@main
struct SwiftLintCommandPlugin: CommandPlugin {

    /// This entry point is called when operating on a Swift package.
    func performCommand(context: PluginContext, arguments: [String]) throws {
        print("SwiftLint Command Plugin execution for Swift package \(context.package.displayName)")
        
        let tool = try context.tool(named: "swiftlint")
        let toolURL = URL(fileURLWithPath: tool.path.string)
        var toolArguments = [
            "lint",
            "--cache-path", "\(context.pluginWorkDirectory.string)/cache" ]
        ]

        var argumentExtractor = ArgumentExtractor(arguments)

        if let configFile = argumentExtractor.extractOption(named: "config").first {
            toolArguments.append(contentsOf: ["--config", configFile])
        }

        if let reporter = argumentExtractor.extractOption(named: "reporter").first {
            toolArguments.append(contentsOf: ["--reporter", reporter])
        }

        if argumentExtractor.extractFlag(named: "strict") > 0 {
            toolArguments.append("--strict")
        }

        let process = try Process.run(toolURL, arguments: toolArguments)
        process.waitUntilExit()

        if process.terminationStatus != 0 {
            let msg = "\(process.terminationStatus): \(process.terminationReason)"
            Diagnostics.error("\(toolURL) command failed: \(msg)")
        }
    }

}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftLintCommandPlugin XcodeCommandPlugin {

    /// This entry point is called when operating on an Xcode project.
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        print("SwifLint Command Plugin execution for Xcode project \(context.xcodeProject.displayName)")
        
        let tool = try context.tool(named: "swiftlint")
        let toolURL = URL(fileURLWithPath: tool.path.string)
        var toolArguments = [
            "lint",
            "--cache-path", "\(context.pluginWorkDirectory.string)/cache" ]
        ]

        var argumentExtractor = ArgumentExtractor(arguments)

        if let configFile = argumentExtractor.extractOption(named: "config").first {
            toolArguments.append(contentsOf: ["--config", configFile])
        }

        if let reporter = argumentExtractor.extractOption(named: "reporter").first {
            toolArguments.append(contentsOf: ["--reporter", reporter])
        }

        if argumentExtractor.extractFlag(named: "strict") > 0 {
            toolArguments.append("--strict")
        }

        let process = try Process.run(toolURL, arguments: toolArguments)
        process.waitUntilExit()

        if process.terminationStatus != 0 {
            let msg = "\(process.terminationStatus): \(process.terminationReason)"
            Diagnostics.error("\(toolURL) command failed: \(msg)")
        }
    }
}
#endif
