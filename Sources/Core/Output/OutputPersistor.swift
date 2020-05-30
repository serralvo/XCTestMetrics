import Foundation
import Files
import ShellOut
import Entity

enum OutputPersistorError: Error {
    case cannotPersistFile
    
    var localizedDescription: String {
        switch self {
        case .cannotPersistFile:
            return "Cannot save output file. Check disk permissions."
        }
    }
}

public final class OutputPersistor {
    
    private let outputToPersist: XCTestMetricsOutput
    private let outputFileName: String
    
    public init(with output: XCTestMetricsOutput, fileName: String) {
        outputToPersist = output
        outputFileName = fileName
    }
    
    public func persistJSON() throws {
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
    
}
