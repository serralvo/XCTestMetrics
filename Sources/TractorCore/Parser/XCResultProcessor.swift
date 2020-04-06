import Foundation
import Files
import ShellOut

enum XCResultProcessorError: Error {
    case cannotExecuteCommand
    case cannotRemoveJSONFile
}

final class XCResultProcessor {
    
    private static let temporaryOutputFileNameWithExtension = "output.json"
    private let resultFilePath: String
    
    init(resultFilePath: String) {
        self.resultFilePath = resultFilePath
    }
    
    func persistOutputFile() throws {
        do {
            try shellOut(to: ["xcrun xcresulttool get --format json --path \(resultFilePath) > \(XCResultProcessor.temporaryOutputFileNameWithExtension)"])
        } catch {
            // TODO: Use error one to throw
            throw XCResultProcessorError.cannotExecuteCommand
        }
    }
    
    func removeJSONFileFromXCResult() throws {
        do {
            try Folder.current.file(named: XCResultProcessor.temporaryOutputFileNameWithExtension).delete()
        } catch {
            throw XCResultProcessorError.cannotRemoveJSONFile
        }
    }
    
}
