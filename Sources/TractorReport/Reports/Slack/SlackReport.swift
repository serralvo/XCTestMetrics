import Foundation
import TractorCore
import TractorDisplay
import TractorEntity

private struct Report: Encodable {
    let text: String
    let attachments: [SlackReportAttachment]
}

final class SlackReport {
    
    private let dataSource: ReportDataSource
    
    init(withDataSource dataSource: ReportDataSource) {
        self.dataSource = dataSource
    }
    
    func publish(toURL url: URL) {
        
        let report = generate()
        let data = try! JSONEncoder().encode(report)
        
        let request = createRequest(withURL: url, data: data)
        
        Display.info(message: "Sending report to Slack...")
        
        let http = HTTP()
        http.sync(request: request)
    }
    
    private func createRequest(withURL url: URL, data httpBody: Data) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        return request
    }
    
    private func generate() -> Report {
        
        let wrapper = try! dataSource.getReportWrapper()
        let output = try! dataSource.getOutput()
        
        let builder = SlackReportAttachmentBuilder(source: wrapper)
        
        let executed = builder.build(withType: .executed)
        let passed = builder.build(withType: .passed)
        let failed = builder.build(withType: .failed)
        let topFailedTest = builder.build(withType: .topFailure)
        
        let date = SlackReportAttachment(text: generateDateRange(with: output), color: "#abb7b7")
        
        return Report(
            text: "🚜 Tractor Report",
            attachments: [date, executed, passed, topFailedTest, failed]
        )
    }
    
    private func generateDateRange(with output: [TractorOutput]) -> String {
        
        guard let firstDate = output.first?.date, let lastDate = output.last?.date else { return
            "Invalid data set"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        return "📅 Results from *\(dateFormatter.string(from: firstDate))* to *\(dateFormatter.string(from: lastDate))*."
    }
    
    private func testsString(with report: ReportWrapper) -> String {
        let tests = report.failureTests.map { $0 }
        
        var result = ""
        for test in tests {
            result += " \(test.numberOfOccurrences) - \(test.failureTest.name)\n"
        }
        return result
    }
    
}
