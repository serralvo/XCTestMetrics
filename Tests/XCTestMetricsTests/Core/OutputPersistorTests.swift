import Foundation
import Core
import Entity
import Files
import XCTest

final class OutputPersistorTests: XCTestCase {
 
    func test_persistJSON_shouldSaveFileOnExpectedFolder() {
        let output = XCTestMetricsOutput(testMetrics: TestMetrics.init(count: 0, failedCount: 0), failures: [])
        let fileName = "file-name"
        
        let sut = OutputPersistor(with: output, fileName: fileName)
        
        do {
            try sut.persistJSON()
        } catch {
            XCTAssert(false, "Expected success")
        }
        
        XCTAssertEqual(Folder.current.containsFile(at: "xctestmetrics-output/xctm-\(fileName).json"), true)
    }
    
}
