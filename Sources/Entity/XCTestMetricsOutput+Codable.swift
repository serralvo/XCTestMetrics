import Foundation

public extension XCTestMetricsOutput {
    
    static var dateFormat: String = "yyyy-MM-dd HH:mm:ss"
    
    static var encoder: JSONEncoder {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = XCTestMetricsOutput.dateFormat
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)

        return encoder
    }
    
    static var decoder: JSONDecoder {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = XCTestMetricsOutput.dateFormat
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }
    
}
