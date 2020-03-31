import TractorCore
import TractorReport
import ArgumentParser

struct Tractor: ParsableCommand {
    @Option() var XCReportPath: String?
    @Argument() var report: String?
    
    func run() throws {
        if let path = XCReportPath {
            let register = TractorRegister(reportFileName: path)
            try register.createTestRegister()
        } else if report != nil {
            let report = TractorReportGenerator()
            report.generate()
        }
        
    }
}

// Test-FlakyTestsProject-2020.03.28_19-49-19--0300 success
// Test-FlakyTestsProject-2020.03.28_19-49-24--0300 failure

Tractor.main(["report"])
// Tractor.main(["--xc-report-path", "Test-FlakyTestsProject-2020.03.28_19-49-24--0300"])
