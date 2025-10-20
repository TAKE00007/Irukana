//
//  CalendarView.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/19.
//

import SwiftUI

struct CalendarView: View {
    // 日本向けのカレンダー設定
    private var calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.locale = Locale(identifier: "ja_JP")
        cal.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        cal.firstWeekday = 2
        return cal
    }()
    
    private let monthsBefore = 24
    private let monthsAfter = 24
    
    private var baseMonthStart: Date {
        startOfMonth(for: Date())
    }
    
    @State private var currentMonth: Date = Date()
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7)
    var body: some View {
        VStack() {
            MonthHeader(monthStart: currentMonth, calendar: calendar)
        }
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                ForEach(offsetRange, id: \.self) { offset in
                    let monthStart = calendar.date(byAdding: .month, value: offset, to: baseMonthStart)!
                    
                    MonthGrid(monthStart: monthStart, calendar: calendar)
            
                }
            }
        }
    }
    
    private var offsetRange: [Int] {
        Array(-monthsBefore...monthsAfter)
    }
}

private struct MonthGrid: View {
    let monthStart: Date
    let calendar: Calendar
    
    private var columns: [GridItem] { Array(repeating: .init(.flexible()), count: 7) }
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach((0..<firstWeekdayIndex).map { "pad-\($0)" }, id: \.self) { _ in
                Color.clear
                    .frame(maxWidth: .infinity, minHeight: 32)
            }
            
            ForEach(1...numberOfDays, id: \.self) { day in
                Text("\(day)")
                    .frame(maxWidth: .infinity, minHeight: 32)
            }
        }
    }
    
    // 月の日数
    var numberOfDays: Int {
        calendar.range(of: .day, in: .month, for: monthStart)!.count
    }
    
    // 月初が何曜日か？月曜から右に何日目かを返す
    var firstWeekdayIndex: Int {
        let weekday = calendar.component(.weekday, from: monthStart)
        return (weekday - calendar.firstWeekday + 7) % 7
    }
}

private struct WeekdayHeader: View {
    private let symbols = ["月", "火", "水", "木", "金", "土", "日"]
    
    private var columns: [GridItem] { Array(repeating: .init(.flexible()), count: 7) }
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(symbols, id: \.self) { day in
                Text(day)
                    .foregroundStyle(color(for: day))
            }
        }
    }
    
    private func color(for symbol: String) -> Color {
        switch symbol {
        case "土": return Color(.systemBlue)
        case "日": return Color(.systemRed)
        default: return Color.primary
        }
    }
}

private struct MonthHeader: View {
    let monthStart: Date
    let calendar: Calendar
    
    var body: some View {
        VStack(alignment: .leading) {
            let comps = calendar.dateComponents([.year, .month], from: monthStart)
            Text("\(comps.year!)年\(comps.month!)月")
                .font(.title3)
            
            WeekdayHeader()
        }
    }
}

private func startOfMonth(for date: Date, using calendar: Calendar = {
    var cal = Calendar(identifier: .gregorian)
    cal.locale = Locale(identifier: "ja_JP")
    cal.timeZone = TimeZone(identifier: "Asia/Tokyo")!
    cal.firstWeekday = 2
    return cal
}()) -> Date {
    let comps = calendar.dateComponents([.year, .month], from: date)
    return calendar.date(from: comps)!
}

#Preview {
    CalendarView()
}

private extension CalendarView {
    var year: Int { calendar.component(.year, from: currentMonth) }
    var month: Int { calendar.component(.month, from: currentMonth) }
    
    
    
}
