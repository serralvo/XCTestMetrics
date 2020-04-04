import Files
import Foundation
import Plot
import TractorEntity

public class TractorReportGenerator {
    
    private func getDecoder() -> JSONDecoder {
        return TractorOutput.decoder
    }
 
    public init() {}
    
    public func generate() {
        let report = ListReportGenerator()
        let content = report.generate()
        let htmlData = content.data(using: .utf8)
        
        try? Folder.current.createFile(at: "tractor-report/report.html", contents: htmlData)
        
    }
    
}
