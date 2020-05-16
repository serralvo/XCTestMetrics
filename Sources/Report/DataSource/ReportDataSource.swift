import Foundation
import Entity

protocol ReportDataSource {
    func getReportWrapper() throws -> ReportWrapper
    func getOutput() throws -> [XCTestMetricsOutput]
}

struct FailureTestReport {
    let failureTest: FailureTest
    let numberOfOccurrences: Int
}

struct ReportWrapper {
    let numberOfSuccess: Int
    let failureTests: [FailureTestReport]
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
