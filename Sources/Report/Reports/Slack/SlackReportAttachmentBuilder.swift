import Foundation

struct SlackReportAttachment: Encodable {
    let text: String
    let color: String
}

final class SlackReportAttachmentBuilder {
    
    enum ReportType {
        case executed
        case passed
        case failed
        case topFailure
    }
    
    private let source: ReportWrapper
    
    init(source: ReportWrapper) {
        self.source = source
    }
    
    func build(withType type: ReportType) -> SlackReportAttachment {
        switch type {
        case .executed:
            return SlackReportAttachment(text: "🛠 Executed tests: *\(source.numberOfTests)*", color: "#abb7b7")
        case .passed:
            return SlackReportAttachment(text: "✅ Passed tests: *\(source.numberOfSuccess)*", color: "#2ecc71")
        case .failed:
            guard source.numberOfFailures > 0 else {
                return SlackReportAttachment(text: "🎉 No test failed. Congrats!", color: "#2ecc71")
            }
            
            return SlackReportAttachment(text: "🚫 Failed tests: *\(source.numberOfFailures)*", color: "#d91e18")
        case .topFailure:
            guard let first = source.failureTests.first else {
                return SlackReportAttachment(text: "🎉 No test failed. Congrats!", color: "#2ecc71")
            }
            
            return SlackReportAttachment(text: "⚠️ Test with the highest number of failures: *\(first.failureTest.name)* (\(first.numberOfOccurrences) times)", color: "#f4d03f")
        }
        
    }
    
}
