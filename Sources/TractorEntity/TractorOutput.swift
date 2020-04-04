import Foundation

public struct TractorOutput: Codable {
    public let testMetrics: TestMetrics
    public let failures: [FailureTest]
    public let date: Date
    
    public init(testMetrics: TestMetrics, failures: [FailureTest], date: Date = Date()) {
        self.testMetrics = testMetrics
        self.failures = failures
        self.date = date
    }
}

public struct TestMetrics: Codable {
    public let count: Int
    public let failedCount: Int
    
    public init(count: Int, failedCount: Int) {
        self.count = count
        self.failedCount = failedCount
    }
}

public struct FailureTest: Codable {
    public let name: String
    public let target: String
    
    public init(name: String, target: String) {
        self.name = name
        self.target = target
    }
}
