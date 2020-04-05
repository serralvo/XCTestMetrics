import Foundation
import Plot

final class ListReportGenerator {
    
    func generate() -> String {
        
        let parser = OutputFileParser()
        
        let wrapper = try! parser.getReportWrapper()
        
        let html = HTML(
            .head(
                .title("Tractor Report"),
                .stylesheet("styles.css")
            ),
            .body(
                .div(
                    .h1("Tractor Report")
                ),
                .wrapped(wrapper)
            )
        )
        
        return html.render()
    }
    
}

private extension Node where Context: HTML.BodyContext {
    static func wrapped(_ report: ReportWrapper) -> Self {
        let tests = report.failureTests.map { $0 }
        
        return .div(
            .summary(report),
            .h3("Failure Tests"),
            .ul(.forEach(tests) {
                .li("\($0.numberOfOccurrences) - \($0.failureTest.name)")
            })
        )
    }
    
    static func summary(_ report: ReportWrapper) -> Self {
        return .h2("Status - Success: \(report.numberOfSuccess) - Failure: \(report.numberOfFailures)")
    }
}
