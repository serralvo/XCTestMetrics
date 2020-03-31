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
        }
        
        // load files from tractor-output folder
        // generates a array of object
        // start: 0, end: 2
        // 
        
        let html = HTML(
            .head(
                .title("My website"),
                .stylesheet("styles.css")
            ),
            .body(
                .div(
                    .h1("Tractor Report"),
                    .p("Writing HTML in Swift is pretty great!")
                )
            )
        )
        
        let content = html.render()
        
    }
    
}
