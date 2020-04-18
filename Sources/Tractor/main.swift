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
        static var configuration = CommandConfiguration(abstract: "Generates a report with collected registers.")
        
        enum Report: String, ExpressibleByArgument {
            case html
            case slack
        }

        @Option(help: "The type of report to generate.")
        var type: Report
        
        func run() throws {
            let report = TractorReportGenerator()
            
            switch type {
            case .html:
                report.generate(withType: .html)
            case .slack:
                report.generate(withType: .slack)
            }
        }
        
    }
        
}

// Tractor.main(["help"])
Tractor.main(["report", "--type=slack"])
// Tractor.main(["report", "--type=html"])
// Tractor.main(["log", "/Users/fabricioserralvo/Library/Developer/Xcode/DerivedData/FlakyTestsProject-gybqxibuurferncjaxlbxkwsptqj"])

