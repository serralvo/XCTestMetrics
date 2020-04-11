import Foundation
import TractorEntity
import Plot

enum HeatMapIndex {
    case unavailable
    case withValue(value: Double)
}

struct SevenDaysHeatMapDataSource {
    let day: Int
    let available: Bool
}

enum HeatMapGeneratorError: Error {
    case cannotGetOutput
}

final class HeatMapGenerator {
    
    private let dataSource: ReportDataSource
    
    init(withDataSource dataSource: ReportDataSource) {
        self.dataSource = dataSource
    }
    
    func generate() throws -> Node<HTML.BodyContext> {
        do {
            let output = try dataSource.getOutput()
            let days = getDaysOfReport(with: output)
            
            let indexes: [HeatMapIndex] = days.map {
                indexByDay(with: $0, output: output)
            }
            
            return Node.div(.wrapped(indexes))
        } catch {
            throw HeatMapGeneratorError.cannotGetOutput
        }
        
    }
    
    private func getDaysOfReport(with output: [TractorOutput]) -> [SevenDaysHeatMapDataSource] {
        
        // TODO: Refactor this one, please.
        
        var days: [Int] = []
        
        let calendar = Calendar.current
        let dates = output.map { $0.date }
        
        for date in dates {
            let components = calendar.dateComponents([.day], from: date)
            
            if days.contains(components.day!) == false {
                days.append(components.day!)
            }
        }
        
        var sevenDays: [SevenDaysHeatMapDataSource] = []
        for day in days {
            sevenDays.append(SevenDaysHeatMapDataSource(day: day, available: true))
        }
        
        if sevenDays.count < 7 {
            
            let size = sevenDays.count + 1
            let target = 7
            
            for _ in size...target {
                sevenDays.append(SevenDaysHeatMapDataSource(day: 0, available: false))
            }
            
        }
        
        return sevenDays
    }
    
    private func indexByDay(with day: SevenDaysHeatMapDataSource, output: [TractorOutput]) -> HeatMapIndex {
        
        guard day.available else {
            return HeatMapIndex.unavailable
        }
        
        let calendar = Calendar.current
        
        let outputs = output.filter { (output) -> Bool in
            let date = output.date
            let dateDay = calendar.dateComponents([.day], from: date)
            
            return dateDay.day! == day.day
        }
        
        let metrics = outputs.map { $0.testMetrics }
        
        let total = metrics.reduce(0, { count, metric in
            count + metric.count
        })
        
        let failure = metrics.reduce(0, { count, metric in
            count + metric.failedCount
        })
        
        if failure == 0 {
            return HeatMapIndex.withValue(value: 100)
        } else {
            return HeatMapIndex.withValue(value: 100 - Double(total / failure))
        }
    }
    
}

private extension Node where Context: HTML.BodyContext {

    static func wrapped(_ indexes: [HeatMapIndex]) -> Self {
        
        return .div(
            .h4("Heat Map - Seven Days"),
            .table(
                .class("heatmap"),
                .tr(
                    .forEach(indexes) {
                        .td(.class($0.className()), "\($0.value())")
                    }
                )
            )
        )
    }
    
}

private extension HeatMapIndex {
    
    func value() -> String {
        switch self {
        case .unavailable:
            return "N/A"
        case .withValue(let value):
            return "\(value)"
        }
    }
    
    func className() -> String {
        switch self {
        case .unavailable:
            return "unavailable"
        case .withValue(let value):
            switch value {
            case ..<50:
                return "bad"
            case 50...89:
                return "medium"
            case 90...95:
                return "good"
            case 96...99:
                return "almost-perfect"
            case 100:
                return "perfect"
            default:
                return "undefined"
            }
        }
    }
    
}
