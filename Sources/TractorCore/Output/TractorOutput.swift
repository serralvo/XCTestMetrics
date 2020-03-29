import Foundation

public struct TractorOutput: Codable {
    public let testMetrics: TestMetrics
    public let failures: [FailureTest]
    public let date: Date
}

public struct TestMetrics: Codable {
    let count: Int
    let failedCount: Int
}

public struct FailureTest: Codable {
    let name: String
    let target: String
}
