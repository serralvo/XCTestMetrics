import Foundation
import Files

enum OutputReaderError: Error {
    case cannotReadFile
    case getEmptyData
}

final class XCResultOutputFileParser {
    
    private static let fileName = "output.json"
    
    init() {}
    
    private func get() {
        
    }
    
    private func readOutputFile() throws -> Data {
        do {
            guard let data = try Files.File(path: XCResultOutputFileParser.fileName).readAsString().data(using: .utf8) else {
                throw OutputReaderError.getEmptyData
            }
            
            return data
        } catch {
            throw OutputReaderError.cannotReadFile
        }
    }
    
}
