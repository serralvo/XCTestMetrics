import Foundation
import Plot

final class ListReportGenerator {
    
    func generate() -> String {
        
        let parser = OutputFileParser()
        
        // TODO: Remove ! cast
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
            .h4("Failure Tests"),
            .table(
                .tr(.class("head"), .td("Quantity"), .td("Test Name"), .td("Target")),
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
        let failurePercentage = report.numberOfTests / report.numberOfFailures
        
        let numberOfTests = "🛠 Executed Tests: \(report.numberOfTests)"
        let success = "✅ Passed Tests: \(report.numberOfSuccess)"
        let failures = "🚫 Failed Tests: \(report.numberOfFailures) - \(failurePercentage)%"
        
        return .div(
            .class("summary"),
            .span("\(numberOfTests)"),
            .span("\(success)"),
            .span("\(failures)")
        )
    }
}
