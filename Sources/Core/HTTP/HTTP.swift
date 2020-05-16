import Foundation

public final class HTTP {
    let dispatchGroup = DispatchGroup()
    let client = URLSession.shared
    
    public init() {}
    
    public func sync(request: URLRequest) {
        dispatchGroup.enter()
        let task = client.dataTask(with: request) { [weak self] _, _, _ in
            self?.dispatchGroup.leave()
        }
        task.resume()
        dispatchGroup.wait()
    }
}
