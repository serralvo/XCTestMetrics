import Foundation
import XCTest

@testable import Core

final class XCResultProcessorTests: XCTestCase {
    
    private let spy = ShellExecutableProtocolSpy()
    
    func test_persistOutputFile_shouldCallShellWithCorrectParameters() {
        
        let sut = XCResultProcessor(resultFilePath: "filePath", shell: spy)
        
        try? sut.persistOutputFile()
        
        XCTAssertEqual(spy.runCalled, true)
        XCTAssertEqual(spy.runPassed, ["xcrun xcresulttool get --format json --path filePath > output.json"])
    }
    
}
