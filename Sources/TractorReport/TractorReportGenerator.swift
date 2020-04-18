import Files
import Foundation
import Plot
import TractorEntity
import TractorDisplay

public class TractorReportGenerator {
    
    public enum ReportType {
        case slack
        case html
    }
    
    public init() {}
    
    public func generate(withType type: ReportType) {
        switch type {
        case .html:
            generateHTMLReport()
        case .slack:
            generateSlackReport()
        }
    }
    
    private func generateHTMLReport() {
        Display.info(message: "Creating HTML report...")
        
        let output = OutputFileParser()
        let report = HTMLReport(withDataSource: output)
        
        let content = report.generate()
        let htmlData = content.data(using: .utf8)
        let cssData = StyleFile.content.data(using: .utf8)
        
        do {
            try Folder.current.createFile(at: "tractor-report/report.html", contents: htmlData)
            try Folder.current.createFile(at: "tractor-report/styles.css", contents: cssData)
            Display.success(message: "Report has been saved. Check it on tractor-report folder.")
        } catch  {
            Display.error(message: error.localizedDescription)
        }
    }
    
    private func generateSlackReport() {
        
    }
    
}
