import Foundation
import Files
import ShellOut

public class TractorRegister {
    
    private let resultName: String

    public init(reportFileName: String) {
        resultName = reportFileName
    }
    
    public func createTestRegister() throws {
        do {
            try generateOutputFile(reportFileName: resultName)
            try persistOutputJSON()
        } catch {
            throw error
        }
    }
    
    private func generateOutputFile(reportFileName: String) throws {
        try XCResultProcessor(resultName: reportFileName).persistOutputFile()
    }
    
    private func persistOutputJSON() throws {
        let tractorOutput = try XCResultOutputFileParser().getOutput()
        
        let persistor = OutputPersistor(with: tractorOutput, fileName: resultName)
        try persistor.persistJSON()
        // needs commit this file 👆
        
        print("🚜 Test register has been saved. Check it on tractor-output folder.")
    }
    
}
