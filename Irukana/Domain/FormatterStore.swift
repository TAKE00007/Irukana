//
//  FormatterStore.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/29.
//

import Foundation

public struct FormatterStore {
    /// yyyy-MM-dd
    static var yyyyMMddDashStyle: Date.ISO8601FormatStyle {
        .iso8601.year().month().day().dateSeparator(.dash)
    }
    
    static func startOfDay(_ date: Date) -> Date {
        let cal = Calendar(identifier: .gregorian)
        return cal.startOfDay(for: date)
    }
    
    static func monthRange(for date: Date) -> (start: Date, end: Date) {
        let cal = Calendar(identifier: .gregorian)
        let start = cal.date(from: cal.dateComponents([.year, .month], from: date))!
        let end = cal.date(byAdding: DateComponents(month: 1), to: start)!
        return (start, end)
    }
    
    static func last24HoursRange(for date: Date) -> (start: Date, end: Date) {
        let cal = Calendar(identifier: .gregorian)
        let start = cal.date(byAdding: .hour, value: -24, to: date)!
        return (start, date)
    }
}
