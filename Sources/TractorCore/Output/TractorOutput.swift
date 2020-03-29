import Foundation

struct TractorOutput: Codable {
    let testMetrics: TestMetrics
    let failures: [FailureTest]
    let date: Date
}

struct TestMetrics: Codable {
    let count: Int
    let failedCount: Int
}

struct FailureTest: Codable {
    let name: String
    let target: String
}
