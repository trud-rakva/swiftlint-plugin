import Foundation
import PackagePlugin

@main
struct SwiftLintCommandPlugin: CommandPlugin {

    func performCommand(context: PluginContext, arguments: [String]) throws {
        let tool = try context.tool(named: "swiftlint")
        let toolURL = URL(fileURLWithPath: tool.path.string)
        var toolArguments = [
            "lint"
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

        toolArguments.append(contentsOf: [ "--cache-path", "\(context.pluginWorkDirectory.string)/cache" ])
                                  
        let process = try Process.run(toolURL, arguments: toolArguments)
        process.waitUntilExit()

        if process.terminationStatus != 0 {
            let msg = "\(process.terminationStatus): \(process.terminationReason)"
            Diagnostics.error("\(toolURL) command failed: \(msg)")
        }
    }

}
