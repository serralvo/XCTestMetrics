import Foundation
import Plot

final class ListReportGenerator {
    
    func generate() -> String {
        
        let parser = OutputFileParser()
        
        let wrapper = try! parser.getReportWrapper()
        
        let html = HTML(
            .head(.title("Tractor Report"), .stylesheet("styles.css")
            ),
            .body(
                .div(.h1("Tractor Report")),
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
            .table(
                .tr(.td("Quantity"), .td("Test Name"), .td("Target")),
                .forEach(tests) {
                    .tr(.td("\($0.numberOfOccurrences)"),
                        .td("\($0.failureTest.name)"),
                        .td("\($0.failureTest.target)")
                    )
                }
            )
        )
    }
    
    static func summary(_ report: ReportWrapper) -> Self {
        return .h2("Status - Success: \(report.numberOfSuccess) - Failure Tests: \(report.numberOfFailures)")
    }
}
