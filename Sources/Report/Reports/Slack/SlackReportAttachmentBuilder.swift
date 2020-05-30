import Foundation

struct SlackReportField: Encodable {
    let title: String
    let value: String
}

final class SlackReportAttachmentBuilder {
    
    enum ReportType {
        case executed
        case passed
        case failed
        case topFailure
        case listOfFailures
    }
    
    private let source: ReportWrapper
    
    init(source: ReportWrapper) {
        self.source = source
    }
    
    func build(withType type: ReportType) -> SlackReportField {
        switch type {
        case .executed:
            return SlackReportField(title: "Executed tests", value: "\(source.numberOfTests)")
        case .passed:
            return SlackReportField(title: "Passed tests", value: "\(source.numberOfSuccess)")
        case .failed:
            guard source.numberOfFailures > 0 else {
                return SlackReportField(title: "Failed tests", value: "🎉 No test failed. Congrats")
            }
            
            return SlackReportField(title: "Failed tests", value: "\(source.numberOfFailures)")
        case .topFailure:
            guard let first = source.failureTests.first else {
                return SlackReportField(title: "Test with the highest number of failures", value: "🎉 No test failed. Congrats")
            }
            
            return SlackReportField(title: "Test with the highest number of failures", value: "\(first.failureTest.name) (\(first.numberOfOccurrences) times)")
        case .listOfFailures:
            let failures = source.failureTests.map { $0 }
            var failuresAsString = ""
            for failure in failures {
                failuresAsString += "\(failure.failureTest.name) - (\(failure.numberOfOccurrences) times)\n"
            }

            return SlackReportField(title: "List of failures", value: failuresAsString)
        }
        
    }
    
}
