import Foundation

public class Display {
    
    public static func error(message: String) {
        print("🚫 Error: \(message)")
    }
    
    public static func warning(message: String) {
        print("⚠️ Warning: \(message)")
    }
    
    public static func info(message: String) {
        print("ℹ️ \(message)")
    }
    
    public static func success(message: String) {
        print("✅ Success! \(message)")
    }
    
}
