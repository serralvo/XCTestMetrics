import Foundation
import ShellOut

enum XCResultProcessorError: Error {
    case cannotExecuteCommand
}

final class XCResultProcessor {
    
    private let resultName: String
    
    init(resultName: String) {
        self.resultName = resultName
    }
    
    func persistOutputFile() throws {
        do {
            try shellOut(to: ["xcrun xcresulttool get --format json --path \(resultName).xcresult > output.json"])
        } catch {
            // TODO: Use error one to throw
            throw XCResultProcessorError.cannotExecuteCommand
        }
    }
    
}
