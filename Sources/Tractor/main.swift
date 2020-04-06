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
        
        func run() throws {
            let report = TractorReportGenerator()
            report.generate()
        }
    }
    
}

// Tractor.main()

// Tractor.main(["help"])
//Tractor.main(["report"])
// Tractor.main(["log", "/Users/fabricioserralvo/Library/Developer/Xcode/DerivedData/FlakyTestsProject-gybqxibuurferncjaxlbxkwsptqj"])

