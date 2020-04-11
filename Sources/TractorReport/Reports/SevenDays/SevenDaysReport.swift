import Foundation
import Plot

final class SevenDaysReport {
    
    private let dataSource: ReportDataSource
    
    init(withDataSource dataSource: ReportDataSource) {
        self.dataSource = dataSource
    }
    
    func generate() -> String {
        
        let list = ListReportGenerator(withDataSource: dataSource)
        let heatMap = HeatMapGenerator(withDataSource: dataSource)
        
        let listNode = list.generate()
        let heatMapNode = try! heatMap.generate()
        
        let html = HTML(
            .head(.title("Tractor Report"), .stylesheet("styles.css")
            ),
            .body(
                .div(.h1("Tractor Report")),
                .div(listNode),
                .div(heatMapNode)
            )
        )
        
        return html.render()
    }
    
}
