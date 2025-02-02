import Core
import Report
import ArgumentParser

struct XCTestMetrics: ParsableCommand {
    
    static var _commandName: String = "xctestmetrics"
    
    static var configuration = CommandConfiguration(
        abstract: "Command-line tool that provides metrics about your project tests.",
        subcommands: [Log.self, Report.self]
    )
}

extension XCTestMetrics {
    
    struct Log: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Creates a register about last project test.")
        
        @Argument() var derivedDataPath: String
        
        func run() throws {
            let register = LogRegister(path: derivedDataPath)
            try register.createTestRegister()
        }
    }
    
    struct Report: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Generates a report with collected registers.",
            subcommands: [SlackReport.self, HTMLReport.self]
        )
    }
    
    struct HTMLReport: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Generates a HTML report")
        static var _commandName: String = "html"
        
        func run() throws {
            let report = ReportGenerator()
            report.generate(withType: .html)
        }
    }
    
    struct SlackReport: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Send the report to Slack.")
        static var _commandName: String = "slack"
        
        @Argument() var hookURL: String
        
        func run() throws {
            let report = ReportGenerator()
            report.generate(withType: .slack(url: hookURL))
        }
    }
        
}

XCTestMetrics.main()
