import TractorCore
import TractorReport
import ArgumentParser

struct Tractor: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "The best way to get flaky tests on your project.",
        subcommands: [Log.self, Report.self]
    )
}

extension Tractor {
    
    struct Log: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Creates a register about last project build.")
        
        @Argument() var derivedDataPath: String
        
        func run() throws {
            let register = TractorRegister(path: derivedDataPath)
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
            let report = TractorReportGenerator()
            report.generate(withType: .html)
        }
    }
    
    struct SlackReport: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Send the report to Slack.")
        static var _commandName: String = "slack"
        
        @Argument() var hookURL: String
        
        func run() throws {
            let report = TractorReportGenerator()
            report.generate(withType: .slack(url: hookURL))
        }
    }
        
}

//Tractor.main(["help"])
//Tractor.main(["report", "html"])
Tractor.main(["report", "slack", ""])
//Tractor.main(["log", "/Users/fabricioserralvo/Library/Developer/Xcode/DerivedData/FlakyTestsProject-gybqxibuurferncjaxlbxkwsptqj"])

