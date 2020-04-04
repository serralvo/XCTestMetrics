import Foundation
import Files
import TractorEntity

enum OutputReaderError: Error {
    case cannotReadFile
    case getEmptyData
    
    case cannotGetTestNumberForMetrics
    case cannotGetFailedTestNumberForMetrics
}

final class XCResultOutputFileParser {
    
    private static let fileName = "output.json"
    
    init() {}
    
    func getOutput() throws -> TractorOutput {
        
        do {
            let data = try readOutputFile()
            
            let output = try JSONDecoder().decode(Output.self, from: data)
            let failures = output.issues.testFailureSummaries?.failures ?? []
            let metrics = try createTestMetrics(with: output.metrics)
            
            let tractorOutput: TractorOutput
            if failures.isEmpty == true {
                tractorOutput = TractorOutput(testMetrics: metrics, failures: [], date: Date())
            } else {
                let mapped = failures.map {
                    FailureTest(name: $0.testCaseName.value, target: $0.producingTarget.value)
                }
                tractorOutput = TractorOutput(testMetrics: metrics, failures: mapped, date: Date())
            }
            
            return tractorOutput
        } catch {
            throw error
        }
    }
    
    private func createTestMetrics(with metrics: Metrics) throws -> TestMetrics {
        guard let testCount = Int(metrics.testsCount.value) else {
            throw OutputReaderError.cannotGetTestNumberForMetrics
        }
        
        let failedCount: Int
        if let value = metrics.testsFailedCount?.value {
            guard let count = Int(value) else {
                throw OutputReaderError.cannotGetFailedTestNumberForMetrics
            }
            failedCount = count
        } else {
            failedCount = 0
        }
        
        return TestMetrics(count: testCount, failedCount: failedCount)
    }
    
    // MARK: - Output file
    
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
