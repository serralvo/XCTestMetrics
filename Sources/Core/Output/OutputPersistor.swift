import Foundation
import Files
import ShellOut
import Entity

enum OutputPersistorError: Error {
    case cannotPersistFile
    case cannotCommitOutputFile
    
    var localizedDescription: String {
        switch self {
        case .cannotCommitOutputFile:
            return "Cannot commit output file. Check git permissions."
        case .cannotPersistFile:
            return "Cannot save output file. Check disk permissions."
        }
    }
}

final class OutputPersistor {
    
    private let outputToPersist: XCTestMetricsOutput
    private let outputFileName: String
    
    init(with output: XCTestMetricsOutput, fileName: String) {
        outputToPersist = output
        outputFileName = fileName
    }
    
    func persistJSON() throws {
        do {
            let encoder = XCTestMetricsOutput.encoder
            let fileToSave = try encoder.encode(outputToPersist)

            try Folder.current.createFile(
                at: "xctestmetrics-output/xctm-\(outputFileName).json",
                contents: fileToSave
            )
        } catch {
            throw OutputPersistorError.cannotPersistFile
        }
    }
    
    func commitOutputFile() throws {
        do {
            try shellOut(to: .gitCommit(message: "Added XCTestMetrics register"))
            try shellOut(to: .gitPush())
        } catch {
            throw OutputPersistorError.cannotCommitOutputFile
        }
    }
    
}
