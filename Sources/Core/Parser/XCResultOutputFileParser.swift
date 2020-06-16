import Foundation
import Files
import Entity

enum OutputReaderError: Error {
    case cannotReadFile
    case getEmptyData
    
    case cannotGetTestNumberForMetrics
    case cannotGetFailedTestNumberForMetrics
    
    var localizedDescription: String {
        switch self {
        case .cannotReadFile:
            return "Cannot read output.json file. Check if it exists and disk read permissions."
        case .getEmptyData:
            return "Cannot get any data from output.json. Check if it is empty."
        case .cannotGetFailedTestNumberForMetrics:
            return "Failed to get metrics. Cannot get number of failures."
        case .cannotGetTestNumberForMetrics:
            return "Failed to get metrics. Cannot get number of executed tests."
        }
    }
}

final class XCResultOutputFileParser {
    
    private static let fileName = "output.json"
    
    init() {}
    
    func getOutput() throws -> XCTestMetricsOutput {
        
        do {
            let data = try readOutputFile()
            
            // TODO: Extract this one into some structure
            let output = try JSONDecoder().decode(Output.self, from: data)
            let failures = output.issues.testFailureSummaries?.failures ?? []
            let metrics = try createTestMetrics(with: output.metrics)
            
            let metricsOutput: XCTestMetricsOutput
            if failures.isEmpty == true {
                metricsOutput = XCTestMetricsOutput(testMetrics: metrics, failures: [], date: Date())
            } else {
                let mapped = failures.map {
                    FailureTest(name: $0.testCaseName.value, target: $0.producingTarget.value)
                }
                metricsOutput = XCTestMetricsOutput(testMetrics: metrics, failures: mapped, date: Date())
            }
            
            return metricsOutput
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
