import Foundation
import TractorEntity

struct ReportWrapper {
    let numberOfSuccess: Int
    let failureTests: [FailureTestReport]
}

struct FailureTestReport {
    let failureTest: FailureTest
    let numberOfOccurrences: Int
}

extension ReportWrapper {
    var numberOfFailures: Int {
        return failureTests.reduce(0, { count, test in
            count + test.numberOfOccurrences
        })
    }
    
    var numberOfTests: Int {
        return numberOfSuccess + numberOfFailures
    }
}

protocol ReportDataSource {
    func getReportWrapper() throws -> ReportWrapper
    func getOutput() throws -> [TractorOutput]
}
