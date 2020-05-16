import Foundation
import Plot

final class ListReportGenerator {
    
    private let dataSource: ReportDataSource
    
    init(withDataSource dataSource: ReportDataSource) {
        self.dataSource = dataSource
    }
    
    func generate() -> Node<HTML.BodyContext> {
        
        // TODO: Remove ! cast
        let wrapper = try! dataSource.getReportWrapper()
        
        let node = Node.div(
            .wrapped(wrapper)
        )
        
        return node
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
        let numberOfTests = "\(report.numberOfTests)"
        let passedTests = "\(report.numberOfSuccess)"
        let failedTests = "\(report.numberOfFailures)"
        
        // TODO: Create a for each for item div
        return .div(
            .class("summary"),
            .div(.class("highlight"), .p("Report")),
            .div(
                .class("item"),
                .div(.class("title"), .p("executed tests")),
                .div(.class("subtitle"), .p("\(numberOfTests)"))
            ),
            .div(
                .class("item"),
                .div(.class("title"), .p("passed tests")),
                .div(.class("subtitle"), .p("\(passedTests)"))
            ),
            .div(
                .class("item"),
                .div(.class("title"), .p("failed tests")),
                .div(.class("subtitle"), .p("\(failedTests)"))
            )
        )
    }
}
