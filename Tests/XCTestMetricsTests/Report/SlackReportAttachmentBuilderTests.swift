import Entity
import Foundation
import XCTest

@testable import Report

final class SlackReportAttachmentBuilderTests: XCTestCase {
    
    func test_build_withExecuted_shouldReturnExpectedTitleAndValue() {
        let wrapper = ReportWrapper(numberOfSuccess: 5, failureTests: [])
        let sut = SlackReportAttachmentBuilder(source: wrapper)
        
        let executed = sut.build(withType: .executed)
        
        XCTAssertEqual(executed.title, "Executed tests")
        XCTAssertEqual(executed.value, "5")
    }
    
    func test_build_withPassed_shouldReturnExpectedTitleAndValue() {
        let wrapper = ReportWrapper(numberOfSuccess: 150, failureTests: [])
        let sut = SlackReportAttachmentBuilder(source: wrapper)
        
        let passed = sut.build(withType: .passed)
        
        XCTAssertEqual(passed.title, "Passed tests")
        XCTAssertEqual(passed.value, "150")
    }
    
    func test_build_withFailedAndNoFailure_shouldReturnExpectedTitleAndValue() {
        let wrapper = ReportWrapper(numberOfSuccess: 150, failureTests: [])
        let sut = SlackReportAttachmentBuilder(source: wrapper)
        
        let failed = sut.build(withType: .failed)
        
        XCTAssertEqual(failed.title, "Failed tests")
        XCTAssertEqual(failed.value, "🎉 No test failed. Congrats")
    }
    
    func test_build_withFailed_shouldReturnExpectedTitleAndValue() {
        let failureTest = FailureTestReport(failureTest: FailureTest(name: "Test", target: "Some Target"), numberOfOccurrences: 5)
        let wrapper = ReportWrapper(numberOfSuccess: 150, failureTests: [failureTest])
        let sut = SlackReportAttachmentBuilder(source: wrapper)
        
        let failed = sut.build(withType: .failed)
        
        XCTAssertEqual(failed.title, "Failed tests")
        XCTAssertEqual(failed.value, "5")
    }
    
}
