import Foundation

@testable import Core

final class ShellExecutableProtocolSpy: ShellExecutableProtocol {

    private(set) var runCalled: Bool = false
    private(set) var runPassed: [String]?
    
    func run(withCommands commands: [String]) throws {
        runCalled = true
        runPassed = commands
    }
    
}
