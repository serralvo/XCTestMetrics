import Files
import Foundation
import Plot
import Entity
import Display

public class ReportGenerator {
    
    public enum ReportType {
        case slack(url: String)
        case html
    }
    
    public init() {}
    
    public func generate(withType type: ReportType) {
        switch type {
        case .html:
            generateHTMLReport()
        case .slack(let url):
            generateSlackReport(rawURL: url)
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
            try Folder.current.createFile(at: "xctestmetrics-report/report.html", contents: htmlData)
            try Folder.current.createFile(at: "xctestmetrics-report/styles.css", contents: cssData)
            Display.success(message: "Report has been saved. Check it on xctestmetrics-report folder.")
        } catch  {
            Display.error(message: error.localizedDescription)
        }
    }
    
    private func generateSlackReport(rawURL: String) {
        
        guard let url = URL(string: rawURL) else {
            Display.error(message: "Invalid Slack hook URL.")
            return
        }
        
        Display.info(message: "Creating Slack report...")
        
        let output = OutputFileParser()
        let slack = SlackReport(withDataSource: output)
        
        slack.publish(toURL: url)
        
        Display.success(message: "Report has been published. Check it on slack.")
    }
    
}
