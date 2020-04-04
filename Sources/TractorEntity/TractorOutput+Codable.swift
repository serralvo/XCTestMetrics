import Foundation

public extension TractorOutput {
    
    public static var encoder: JSONEncoder {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)

        return encoder
    }
    
    public static var decoder: JSONDecoder {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }
    
}
