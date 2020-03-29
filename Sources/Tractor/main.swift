import TractorCore
import ArgumentParser

struct Tractor: ParsableCommand {
    @Option() var XCReportPath: String
    
    func run() throws {
        let register = TractorRegister(reportFileName: XCReportPath)
        try register.createTestRegister()
    }
}

// Test-FlakyTestsProject-2020.03.28_19-49-19--0300 success
// Test-FlakyTestsProject-2020.03.28_19-49-24--0300 failure

Tractor.main(["--xc-report-path", "Test-FlakyTestsProject-2020.03.28_19-49-24--0300"])
