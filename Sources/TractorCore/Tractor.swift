import Foundation
import Files
import ShellOut

public class TractorGen {
    
    private let resultName: String

    public init(reportFileName: String) {
        resultName = reportFileName
    }
    
    public func log() {
        do {
            try generateOutputFile(reportFileName: resultName)
            parse()
        } catch {
            print(error)
        }
    }
    
    func generateOutputFile(reportFileName: String) throws {
        let processor = XCResultProcessor(resultName: reportFileName)
        try processor.persistOutputFile()
    }
    
    func parse() {
        
        do {
            let data = try Files.File(path: "output.json").readAsString().data(using: .utf8)
            let output = try? JSONDecoder().decode(Output.self, from: data!)

            let failures = output?.issues.testFailureSummaries.failures ?? []
            
            for failure in failures {
                print(failure.description)
            }
            
            let tractorOutput: TractorOutput
            if failures.isEmpty == true {
                tractorOutput = TractorOutput(failures: [], date: Date())
            } else {
                let mapped = failures.map {
                    FailureTest(name: $0.testCaseName.value, target: $0.producingTarget.value)
                }
                tractorOutput = TractorOutput(failures: mapped, date: Date())
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
            
            let fileToSave = try? encoder.encode(tractorOutput)
            
            let x = try Folder.current.createFile(at: "tractor-output/to-\(resultName).json", contents: fileToSave)
            
            // needs commit this file :point-up:
            
        } catch {
            print(error)
        }
        
        // generate a structure
        // save it on disc
    }
    
}
