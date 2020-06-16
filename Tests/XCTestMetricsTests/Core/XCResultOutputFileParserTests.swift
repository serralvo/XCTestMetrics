import Foundation
import Files
import XCTest

@testable import Core

final class XCResultOutputFileParserTests: XCTestCase {
    
    private let sut = XCResultOutputFileParser()
    
    func test_getOutput_withOutOutputFile_shouldThrowError() {
        
        try? Folder.current.file(named: "output.json").delete()
        
        XCTAssertThrowsError(try sut.getOutput()) { error in
            XCTAssertEqual(error as? OutputReaderError, OutputReaderError.cannotReadFile)
        }

    }
    
}
