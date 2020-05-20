import Foundation
import Files
import ShellOut
import Display

enum RegisterError: Error {
    case cannotGetResultFilePath
}

public class LogRegister {
    
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
            throw RegisterError.cannotGetResultFilePath
        }
        
        guard let resultFilePath = derivedData.subfolders.first(where: { $0.name.contains(xcResultExtension) } )?.path else {
            throw RegisterError.cannotGetResultFilePath
        }
        
        return resultFilePath
    }
    
    
    private func persistOutputJSON() throws {
        let output = try XCResultOutputFileParser().getOutput()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH.mm.ss"
        
        let resultName = formatter.string(from: Date())
        let persistor = OutputPersistor(with: output, fileName: resultName)
        try persistor.persistJSON()
        
        Display.success(message: "Log has been saved. Check it on xctestmetrics-output folder.")
    }
    
}
