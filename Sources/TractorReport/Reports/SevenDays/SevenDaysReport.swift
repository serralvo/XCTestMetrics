import Foundation
import Plot

final class SevenDaysReport {
    
    private let dataSource: ReportDataSource
    
    init(withDataSource dataSource: ReportDataSource) {
        self.dataSource = dataSource
    }
    
    func generate() -> String {
        
        let list = ListReportGenerator(withDataSource: dataSource)
        let listNode = list.generate()
        
        let html = HTML(
            .head(.title("Tractor Report"), .stylesheet("styles.css")
            ),
            .body(
                .div(.h1("Tractor Report")),
                .div(listNode)
            )
        )
        
        return html.render(indentedBy: .tabs(1))
    }
    
}
