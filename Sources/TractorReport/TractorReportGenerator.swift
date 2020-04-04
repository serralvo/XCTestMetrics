import Files
import Foundation
import Plot

// should create a module with this one :point-down:

struct TractorOutput: Codable {
    let testMetrics: TestMetrics
    let failures: [FailureTest]
    let date: Date
}

struct TestMetrics: Codable {
    let count: Int
    let failedCount: Int
}

struct FailureTest: Codable {
    let name: String
    let target: String
}

public class TractorReportGenerator {
    
    private func getDecoder() -> JSONDecoder {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }
 
    public init() {}
    
    public func generate() {
        
        let folder = try? Folder.current.subfolder(named: "tractor-output")
        
        if let files = folder?.files {
            var content: [String] = []
            for file in files where file.name.contains("to-") {
                if let stringContent = try? file.readAsString() {
                    content.append(stringContent)
                }
            }
            
            var output: [TractorOutput] = []
            for str in content {
            
                guard let data = str.data(using: .utf8) else { break }
                
                if let to = try? getDecoder().decode(TractorOutput.self, from: data) {
                    output.append(to)
                }
                
            }
            
            print(output)
            
            let html = HTML(
                .head(
                    .title("Tractor Report"),
                    .stylesheet("styles.css")
                ),
                .body(
                    .div(
                        .h1("Tractor Report")
                    ),
                    .wrapped(output.last!),
                    .div(
                        .p("Made with love")
                    )
                )
            )
            
            let contentString = html.render()
            let htmlData = contentString.data(using: .utf8)
            
            try? Folder.current.createFile(at: "tractor-report/report.html", contents: htmlData)
        }
        
        // load files from tractor-output folder
        // generates a array of object
        // start: 0, end: 2
        //
        
    }
    
}

extension Node where Context: HTML.BodyContext {
    static func wrapped(_ output: TractorOutput) -> Self {
        let tests = output.failures.map { $0 }
        
        return .div(
            .h1("Failure Tests"),
            .ul(.forEach(tests) {
                .li("\($0.name) - \($0.target)")
            })
        )
    }
}
