import PackagePlugin
import Foundation

@main
struct SwiftLintCommandPlugin: CommandPlugin {

    /// This entry point is called when operating on a Swift package.
    func performCommand(context: PluginContext, arguments: [String]) throws {
        print(" -*- SwiftLint Command Plugin execution for Swift package \(context.package.displayName) -*-")
        //print("context: \(context)")
        //print("arguments: \(arguments)")

        let tool = try context.tool(named: "swiftlint").path.string
        let cache = context.pluginWorkDirectory.appending("cache").string
        let toolArgs = getArgs(cache: cache, arguments: arguments)
        let targetNames = getTargetNames(arguments: arguments)

        if targetNames.isEmpty {
            try runCommand(tool: tool, toolArgs: toolArgs)
        } else {
            let targets = try context.package.targets(named: targetNames)
            for target in targets {
                print(" * processing module target \(target.name)")
                guard let target = target as? SourceModuleTarget else { continue }
                print(" - processing source directory \(target.directory)")
                try runCommand(tool: tool, toolArgs: toolArgs + [target.directory.string])
            }
        }
    }

}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftLintCommandPlugin: XcodeCommandPlugin {

    /// This entry point is called when operating on an Xcode project.
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        print(" -*- SwifLint Command Plugin execution for Xcode project \(context.xcodeProject.displayName) -*-")
        //print("context: \(context)")
        //print("arguments: \(arguments)")

        let tool = try context.tool(named: "swiftlint").path.string
        let cache = context.pluginWorkDirectory.appending("cache").string
        let toolArgs = getArgs(cache: cache, arguments: arguments)
        let targetNames = getTargetNames(arguments: arguments)

        if targetNames.isEmpty {
            try runCommand(tool: tool, toolArgs: toolArgs)
        } else {
            let targets = context.xcodeProject.targets.filter { targetNames.contains($0.displayName) }
            for target in targets {
                print(" * processing Xcode target \(target.displayName)")
                for file in target.inputFiles where file.type == .source {
                    print(" - processing source file \(file.path)")
                    try runCommand(tool: tool, toolArgs: toolArgs + [file.path.string])
                }
            }
        }
    }
}
#endif

extension SwiftLintCommandPlugin {

    private func runCommand(tool: String, toolArgs: [String]) throws {
        let toolURL = URL(fileURLWithPath: tool)

        //print("run: \(toolURL) \(toolArgs)")
        let process = try Process.run(toolURL, arguments: toolArgs)
        process.waitUntilExit()

        if process.terminationStatus != 0 || process.terminationReason != .exit {
            let msg = "[\(process.terminationStatus)] \(process.terminationReason)"
            Diagnostics.error("\(toolURL) command failed: \(msg)")
        }
    }

    private func getArgs(cache: String, arguments: [String]) -> [String] {
        var args = [
            "lint",
            "--cache-path", "\(cache)"
        ]

        var argumentExtractor = ArgumentExtractor(arguments)

        for configFile in argumentExtractor.extractOption(named: "config") {
            args.append(contentsOf: ["--config", configFile])
        }

        if let reporter = argumentExtractor.extractOption(named: "reporter").first {
            args.append(contentsOf: ["--reporter", reporter])
        }

        if argumentExtractor.extractFlag(named: "strict") > 0 {
            args.append("--strict")
        }
        return args
    }

    private func getTargetNames(arguments: [String]) -> [String] {
        var argExtractor = ArgumentExtractor(arguments)
        return argExtractor.extractOption(named: "target")
    }

}
