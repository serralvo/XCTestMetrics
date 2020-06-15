import Foundation
import ShellOut

protocol ShellExecutableProtocol {
    func run(withCommands commands: [String]) throws
}

final class ShellExecutable: ShellExecutableProtocol {
    
    func run(withCommands commands: [String]) throws {
        try shellOut(to: commands)
    }
}
