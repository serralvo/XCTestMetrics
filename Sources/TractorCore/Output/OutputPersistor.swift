import Foundation
import Files
import ShellOut
import TractorEntity

enum OutputPersistorError: Error {
    case cannotPersistFile
    case cannotCommitOutputFile
}

final class OutputPersistor {
    
    private let tractorOutputToPersist: TractorOutput
    private let outputFileName: String
    
    init(with output: TractorOutput, fileName: String) {
        tractorOutputToPersist = output
        outputFileName = fileName
    }
    
    func persistJSON() throws {
        do {
            let encoder = TractorOutput.encoder
            let fileToSave = try encoder.encode(tractorOutputToPersist)

            try Folder.current.createFile(
                at: "tractor-output/to-\(outputFileName).json",
                contents: fileToSave
            )
        } catch {
            throw OutputPersistorError.cannotPersistFile
        }
    }
    
    func commitOutputFile() throws {
        do {
            try shellOut(to: .gitCommit(message: "Added tractor register"))
            try shellOut(to: .gitPush())
        } catch {
            throw OutputPersistorError.cannotCommitOutputFile
        }
    }
    
}
