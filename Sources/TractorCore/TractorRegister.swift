import Foundation
import Files
import ShellOut

public class TractorRegister {
    
    private let path: String

    public init(path: String) {
        self.path = path
    }
    
    public func createTestRegister() throws {
        do {
            let filePath = getResultFilePath()
            try generateOutputFile(reportFileName: filePath)
            try persistOutputJSON()
        } catch {
            throw error
        }
    }
    
    private func getResultFilePath() -> String {
        // TODO: Refactor this one
        guard let derivedData = try? Folder.init(path: self.path + "/Logs/Test/") else { return "" }
        guard let resultName = derivedData.subfolders.first(where: { $0.name.contains(".xcresult") } )?.path else { return "" }
        
        return resultName
    }
    
    private func generateOutputFile(reportFileName: String) throws {
        try XCResultProcessor(resultName: reportFileName).persistOutputFile()
    }
    
    private func persistOutputJSON() throws {
        let tractorOutput = try XCResultOutputFileParser().getOutput()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // TODO: Update this one
        let resultName = formatter.string(from: Date())
        let persistor = OutputPersistor(with: tractorOutput, fileName: resultName)
        try persistor.persistJSON()
        // try persistor.commitOutputFile()
        
        print("🚜 Test register has been saved. Check it on tractor-output folder.")
    }
    
}
