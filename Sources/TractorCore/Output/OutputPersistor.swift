import Foundation
import Files
import TractorEntity

enum OutputPersistorError: Error {
    case cannotPersistFile
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
            let encoder = getEncoder()
            let fileToSave = try encoder.encode(tractorOutputToPersist)

            try Folder.current.createFile(
                at: "tractor-output/to-\(outputFileName).json",
                contents: fileToSave
            )
        } catch {
            throw OutputPersistorError.cannotPersistFile
        }
    }
    
    private func getEncoder() -> JSONEncoder {
        return TractorOutput.encoder
    }
    
}
