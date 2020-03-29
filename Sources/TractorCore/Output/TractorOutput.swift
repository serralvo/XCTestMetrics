import Foundation

public struct TractorOutput: Codable {
    public let failures: [FailureTest]
    public let date: Date
}

public struct FailureTest: Codable {
    let name: String
    let target: String
}
