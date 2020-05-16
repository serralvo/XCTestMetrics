import Foundation
import Plot

final class HTMLReport {
    
    private let dataSource: ReportDataSource
    
    init(withDataSource dataSource: ReportDataSource) {
        self.dataSource = dataSource
    }
    
    func generate() -> String {
        
        let list = ListReportGenerator(withDataSource: dataSource)
        let listNode = list.generate()
        
        let html = HTML(
            .head(.title("XCTestMetrics Report"), .stylesheet("styles.css")),
            .body(
                .div(listNode)
            )
        )
        
        return html.render(indentedBy: .tabs(1))
    }
    
}
