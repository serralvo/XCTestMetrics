import Foundation
import TractorCore
import TractorDisplay

private struct SlackReportAttachment: Encodable {
    let text: String
    let color: String
}

private struct Report: Encodable {
    let text: String
    let attachments: [SlackReportAttachment]
}

final class SlackReport {
    
    private let dataSource: ReportDataSource
    
    init(withDataSource dataSource: ReportDataSource) {
        self.dataSource = dataSource
    }
    
    private func generate() -> Report {
        
        let wrapper = try! dataSource.getReportWrapper()
        
        let executed = SlackReportAttachment(text: "🛠 Executed tests: *\(wrapper.numberOfTests)*", color: "#abb7b7")
        let passed = SlackReportAttachment(text: "✅ Passed tests: *\(wrapper.numberOfSuccess)*", color: "#2ecc71")
        let failed = SlackReportAttachment(text: "🚫 Failed tests: *\(wrapper.numberOfFailures)*", color: "#d91e18")
        
        return Report(text: "🚜 Tractor Report: ", attachments: [executed, passed, failed])
    }
    
    func publish() {
        
        let report = generate()
        let data = try! JSONEncoder().encode(report)
        
        var request = URLRequest(url: URL(string: "")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        Display.info(message: "Sending report to Slack...")
        
        let http = HTTP()
        http.sync(request: request)
    }
    
}
