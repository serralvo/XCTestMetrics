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
    private let shell: ShellExecutableProtocol
    
    init(resultFilePath: String, shell: ShellExecutableProtocol = ShellExecutable()) {
        self.resultFilePath = resultFilePath
        self.shell = shell
    }
    
    func persistOutputFile() throws {
        do {
            try self.shell.run(withCommands: ["xcrun xcresulttool get --format json --path \(resultFilePath) > \(XCResultProcessor.temporaryOutputFileNameWithExtension)"])
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
