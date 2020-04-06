import Foundation
import Files
import ShellOut

enum TractorRegisterError: Error {
    case cannotGetResultFilePath
}

public class TractorRegister {
    
    private let path: String

    public init(path: String) {
        self.path = path
    }
    
    public func createTestRegister() throws {
        do {
            let resultFilePath = try getResultFilePath()
            
            let processor = XCResultProcessor(resultFilePath: resultFilePath)
            try processor.persistOutputFile()
            
            try persistOutputJSON()
            
            try processor.removeJSONFileFromXCResult()
        } catch {
            throw error
        }
    }
    
    private func getResultFilePath() throws -> String {
        let testFolderPath = "/Logs/Test/"
        let xcResultExtension = ".xcresult"
        
        guard let derivedData = try? Folder.init(path: self.path + testFolderPath) else {
            throw TractorRegisterError.cannotGetResultFilePath
        }
        
        guard let resultFilePath = derivedData.subfolders.first(where: { $0.name.contains(xcResultExtension) } )?.path else {
            throw TractorRegisterError.cannotGetResultFilePath
        }
        
        return resultFilePath
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
