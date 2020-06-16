import Entity
import Files
import Foundation
import XCTest

@testable import Report

final class OutputFileParserTests: XCTestCase {
    
    private let sut = OutputFileParser()
    
    override class func tearDown() {
        try? Folder.current.subfolder(named: "xctestmetrics-output").delete()
    }
    
    func test_getReportWrapper_whenFolderIsEmpty_shouldThrowError() {
        
        try? Folder.current.subfolder(named: "xctestmetrics-output").delete()
        
        XCTAssertThrowsError(try sut.getReportWrapper()) { error in
            XCTAssertEqual(error as? OutputFileParserError, OutputFileParserError.cannotGenerateReportWrapper)
        }
    }
    
    func test_getReportWrapper_whenFolderHasSomeReport_shouldReturnAValidArray() {
        
        let folder = try? Folder.current.createSubfolder(at: "xctestmetrics-output")
        let _ = try? folder?.createFile(at: XCTestMetricsOutput.fileName(), contents: XCTestMetricsOutput.fixture())
        
        let wrapper = try? sut.getReportWrapper()
        
        XCTAssertEqual(wrapper?.numberOfFailures, 2)
        XCTAssertEqual(wrapper?.numberOfSuccess, 100)
        XCTAssertEqual(wrapper?.numberOfTests, 102)
    }
    
    func test_getOutput_whenFolderIsEmpty_shouldThrowError() {
        
        try? Folder.current.subfolder(named: "xctestmetrics-output").delete()
        
        XCTAssertThrowsError(try sut.getOutput()) { error in
            XCTAssertEqual(error as? OutputFileParserError, OutputFileParserError.outputFolderNotFound)
        }
    }
    
    func test_getOutput_whenFolderHasSomeReport_shouldReturnAValidArray() {
        
        let folder = try? Folder.current.createSubfolder(at: "xctestmetrics-output")
        let _ = try? folder?.createFile(at: XCTestMetricsOutput.fileName(), contents: XCTestMetricsOutput.fixture())
        
        let output = try? sut.getOutput()
        
        XCTAssertEqual(output?.count, 1)
        XCTAssertEqual(output?.first?.testMetrics.count, 100)
        XCTAssertEqual(output?.first?.testMetrics.failedCount, 2)
        XCTAssertEqual(output?.first?.failures.first?.name, "SomeInteractorTest.someFlaky()")
        XCTAssertEqual(output?.first?.failures.first?.target, "FirstTarget")
        XCTAssertEqual(output?.first?.failures.last?.name, "SomeInteractorTest.anotherFlakyOne()")
        XCTAssertEqual(output?.first?.failures.last?.target, "SecondTarget")
    }
    
}

extension XCTestMetricsOutput {
    
    static func fileName() -> String {
        "xctm-2020-03-15 20.30.10.json"
    }
    
    static func fixture() -> Data? {
        """
        {
          "testMetrics": {
            "count": 100,
            "failedCount": 2
          },
          "date": "2020-03-15 20:30:01",
          "failures": [
            {
              "name": "SomeInteractorTest.someFlaky()",
              "target": "FirstTarget"
            },
            {
              "name": "SomeInteractorTest.anotherFlakyOne()",
              "target": "SecondTarget"
            }
          ]
        }
        """.data(using: .utf8)
    }
    
}
