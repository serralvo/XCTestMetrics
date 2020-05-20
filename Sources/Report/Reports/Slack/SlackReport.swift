import Foundation
import Core
import Display
import Entity

enum SlackReportError: Error {
    case cannotGetDataSource
}

private struct Attachment: Encodable {
    let color: String
    let title: String
    let titleLink: String
    let fields: [SlackReportField]
    let footer: String
    
    enum CodingKeys: String, CodingKey {
        case color, title, fields, footer
        case titleLink = "title_link"
    }
}

private struct Report: Encodable {
    let attachments: [Attachment]
}

final class SlackReport {
    
    private let dataSource: ReportDataSource
    
    init(withDataSource dataSource: ReportDataSource) {
        self.dataSource = dataSource
    }
    
    func publish(toURL url: URL) throws {
        let report = try generate()
        let data = try JSONEncoder().encode(report)
        
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
    
    private func generate() throws -> Report {
        do {
            let wrapper = try dataSource.getReportWrapper()
            let output = try dataSource.getOutput()
         
            let attachment = Attachment(
                color: "#36a64f", // TODO: Get color based on flakyness percentage
                title: "XCTestMetrics Report",
                titleLink: "https://github.com/serralvo/XCTestMetrics",
                fields: generateFields(with: wrapper),
                footer: generateDateRange(with: output)
            )
            
            return Report(attachments: [attachment])
            
        } catch {
            throw SlackReportError.cannotGetDataSource
        }
    }
    
    private func generateFields(with wrapper: ReportWrapper) -> [SlackReportField] {
        let builder = SlackReportAttachmentBuilder(source: wrapper)
        
        let executed = builder.build(withType: .executed)
        let passed = builder.build(withType: .passed)
        let failed = builder.build(withType: .failed)
        let topFailedTest = builder.build(withType: .topFailure)
        
        return [executed, passed, failed, topFailedTest]
    }
    
    private func generateDateRange(with output: [XCTestMetricsOutput]) -> String {
        
        guard let firstDate = output.first?.date, let lastDate = output.last?.date else { return
            "Invalid data set"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        return "Results from *\(dateFormatter.string(from: firstDate))* to *\(dateFormatter.string(from: lastDate))*."
    }
    
    private func testsString(with report: ReportWrapper) -> String {
        // TODO: please refactor this one
        let tests = report.failureTests.map { $0 }
        
        var result = ""
        for test in tests {
            result += " \(test.numberOfOccurrences) - \(test.failureTest.name)\n"
        }
        return result
    }
    
}
