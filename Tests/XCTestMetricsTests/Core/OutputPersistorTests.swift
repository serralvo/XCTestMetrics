import Foundation
import Entity
import Files
import XCTest

@testable import Core

final class OutputPersistorTests: XCTestCase {
    
    override class func tearDown() {
        try? Folder.current.subfolder(named: "xctestmetrics-output").delete()
    }
 
    func test_persistJSON_shouldSaveFileOnExpectedFolder() {
        let output = XCTestMetricsOutput(testMetrics: .init(count: 0, failedCount: 0), failures: [])
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
