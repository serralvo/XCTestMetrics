import Foundation

// MARK: - Output
struct Output: Codable {
    let issues: Issues
    let metrics: Metrics

    enum CodingKeys: String, CodingKey {
        case issues, metrics
    }
}

// MARK: - ID
struct ID: Codable {
    let value: String

    enum CodingKeys: String, CodingKey {
        case value = "_value"
    }
}

// MARK: - Issues
struct Issues: Codable {
    let testFailureSummaries: TestFailureSummaries

    enum CodingKeys: String, CodingKey {
        case testFailureSummaries
    }
}

// MARK: - TestFailureSummaries
struct TestFailureSummaries: Codable {
    let failures: [TestFailureSummariesValue]

    enum CodingKeys: String, CodingKey {
        case failures = "_values"
    }
}

// MARK: - TestFailureSummariesValue
struct TestFailureSummariesValue: Codable {
    let message, producingTarget, testCaseName: ID

    enum CodingKeys: String, CodingKey {
        case message, producingTarget, testCaseName
    }
    
    var description: String {
        return "Failed: \(testCaseName.value) - \(producingTarget.value)"
    }
}

// MARK: - Metrics
struct Metrics: Codable {
    let testsCount: ID
    let testsFailedCount: ID
}
