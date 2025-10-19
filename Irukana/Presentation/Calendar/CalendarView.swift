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
    
    @State private var currentMonth: Date = Date()
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7)
    var body: some View {
        HStack {
            Text("\(year)年\(month)月")
                .padding()
            Spacer()
        }
        LazyVGrid(columns: columns) {
            Text("月")
            Text("火")
            Text("水")
            Text("木")
            Text("金")
            Text("土")
            Text("日")
        }
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
}

#Preview {
    CalendarView()
}

private extension CalendarView {
    var year: Int { calendar.component(.year, from: currentMonth) }
    var month: Int { calendar.component(.month, from: currentMonth) }
    
    var startOfMonth: Date {
        let comps = calendar.dateComponents([.year, .month], from: currentMonth)
        return calendar.date(from: comps)!
    }
    
    // 月の日数
    var numberOfDays: Int {
        calendar.range(of: .day, in: .month, for: currentMonth)!.count
    }
    
    // 月初が何曜日か？月曜から右に何日目かを返す
    var firstWeekdayIndex: Int {
        let weekday = calendar.component(.weekday, from: startOfMonth)
        return (weekday - calendar.firstWeekday + 7) % 7
    }
    
    
}
