import Foundation

final class ReportConfigGenerator {
    
    private let startHour: Int
    private let endHour: Int
    private let bucketSize: Int
    
    init(startHour: Int, endHour: Int, bucketSize: Int) {
        self.startHour = startHour
        self.endHour = endHour
        self.bucketSize = bucketSize
    }
    
    private func generate() -> [ReportConfig] {
        var config: [ReportConfig] = []
        
        for i in startHour...endHour where i.isMultiple(of: bucketSize) {
            config.append(ReportConfig.init(startHour: i, endHour: i + bucketSize))
        }
        
        return config
    }
    
}
