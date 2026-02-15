import Foundation

public struct FormatterStore {
    /// yyyy-MM-dd
    static var yyyyMMddDashStyle: Date.ISO8601FormatStyle {
        .iso8601.year().month().day().dateSeparator(.dash)
    }
    
    static var yyyyMMddStyle: Date.FormatStyle {
        .dateTime.year().month().day()
    }
    
    static func startOfDay(_ date: Date) -> Date {
        let cal = Calendar(identifier: .gregorian)
        return cal.startOfDay(for: date)
    }
    
    static func monthRange(for date: Date) -> (start: Date, end: Date) {
        let cal = Calendar(identifier: .gregorian)
        
        let baseMonthStart = cal.date(from: cal.dateComponents([.year, .month], from: date))!
        
        let start = cal.date(byAdding: .month, value: -6, to: baseMonthStart)!
        
        let plus6MonthStart = cal.date(byAdding: .month, value: 6, to: baseMonthStart)!
        let end = cal.date(byAdding: .month, value: 1, to: plus6MonthStart)!
        
        return (start, end)
    }
    
    static func last24HoursRange(for date: Date) -> (start: Date, end: Date) {
        let cal = Calendar(identifier: .gregorian)
        let start = cal.date(byAdding: .hour, value: -24, to: date)!
        return (start, date)
    }
}
