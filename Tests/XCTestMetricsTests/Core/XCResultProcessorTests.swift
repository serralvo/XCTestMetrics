import Foundation
import Files
import XCTest

@testable import Core

final class XCResultProcessorTests: XCTestCase {
    
    private lazy var sut = XCResultProcessor(resultFilePath: "filePath", shell: spy)
    private let spy = ShellExecutableProtocolSpy()
    
    func test_persistOutputFile_shouldCallShellWithCorrectParameters() {
        
        try? sut.persistOutputFile()
        
        XCTAssertEqual(spy.runCalled, true)
        XCTAssertEqual(spy.runPassed, ["xcrun xcresulttool get --format json --path filePath > output.json"])
    }
    
    func test_removeJSONFileFromXCResult_shouldRemoveFile() {
        
        try? Folder.current.createFile(at: "output.json")
        
        XCTAssertEqual(Folder.current.containsFile(at: "output.json"), true)
        
        do {
            try sut.removeJSONFileFromXCResult()
            XCTAssertEqual(Folder.current.containsFile(at: "output.json"), false)
        } catch {
            XCTFail("Expected success")
        }
    }
    
}
