//
//  CalendarView.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/19.
//

import SwiftUI

struct CalendarView: View {
    private var reducer: CalendarReducer
    @State private var state = CalendarState()
    
    init(reducer: CalendarReducer) {
        self.reducer = reducer
    }
    
    var body: some View {
        VStack() {
            MonthTitle(date: state.visibleMonthStart ?? Date())
                .padding(.top, 8)
            
            WeekdayHeader()
                .padding(.bottom, 4)
        }
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(state.offsetRange, id: \.self) { offset in
                    
                        let monthStart = state.calendar.date(byAdding: .month, value: offset, to: state.baseMonthStart)!
                        
                        MonthGrid(monthStart: monthStart, calendar: state.calendar, dinnerStatus: state.dinnerStatus)
                            .id(monthStart)
                            .overlay {
                                MonthVisibleMarker(monthStart: monthStart).frame(height: 0)
                            }
                    }
                }
                .onPreferenceChange(MonthYPreference.self) { values in
                    guard let nearest = values.min(by: { abs($0.minY) < abs($1.minY) }) else { return }
                    if state.visibleMonthStart != nearest.monthStart {
                        state.visibleMonthStart = nearest.monthStart
                    }
                }
            }
            .coordinateSpace(name: "scroll")
            .task {
                proxy.scrollTo(state.baseMonthStart, anchor: .top)
                if let effect = reducer.reduce(state: &state, action: .onAppear) {
                    do {
                        if let dinnerStatus = try await reducer.run(effect) {
                            _ = reducer.reduce(
                                state: &state,
                                action: .dinnerStatusResponse(.success(dinnerStatus))
                            )
                        }
                    } catch {
                        _ = reducer.reduce(
                            state: &state,
                            action: .dinnerStatusResponse(.failure(error))
                        )
                    }
                }
            }
        }
    }
}

private struct MonthTitle: View {
    let date: Date
    var body: some View {
        let dateString = date.formatted(.dateTime.year().month())
        HStack {
            Text("\(dateString)")
            Spacer()
        }
        .padding(.horizontal, 12)
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
                    .frame(maxWidth: .infinity, minHeight: 20)
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

private struct MonthGrid: View {
    let monthStart: Date
    let calendar: Calendar
    let dinnerStatus: DinnerStatus?
    
    private var columns: [GridItem] { Array(repeating: .init(.flexible()), count: 7) }
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach((0..<firstWeekdayIndex).map { "pad-\($0)" }, id: \.self) { _ in
                Color.clear
                    .frame(maxWidth: .infinity, minHeight: 32)
            }
            
            ForEach(1...numberOfDays, id: \.self) { day in
                DayCell(
                    day: day,
                    answers: dinnerStatus?.answers ?? [:]
                )
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

private struct DayCell: View {
    let day: Int
    let answers: [UUID: DinnerAnswer]
    
    var body: some View {
        VStack(spacing: 5) {
            Text("\(day)")
            if day == 1 {
                ForEach(answers.keys.sorted(by: { $0.uuidString < $1.uuidString }), id: \.self) { uuid in
                    let answer = answers[uuid] ?? .unknown
                    Text(label(for: answer))
                        .font(.caption2)
                        .bold()
                }
            }
            
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
    }
}

private func label(for answer: DinnerAnswer) -> String {
    switch answer {
    case .need: return "いる"
    case .noneed: return "いらない"
    case .unknown: return "未回答"
    }
}

// MARK: 月の位置を親Viewに通知
private struct MonthY: Equatable {
    let monthStart: Date
    let minY: CGFloat
}

private struct MonthYPreference: PreferenceKey {
    static var defaultValue: [MonthY] = []
    static func reduce(value: inout [MonthY], nextValue: () -> [MonthY]) {
        value.append(contentsOf: nextValue())
    }
}

private struct MonthVisibleMarker: View {
    let monthStart: Date
    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(
                    key: MonthYPreference.self,
                    value: [MonthY(monthStart: monthStart,
                                   minY: proxy.frame(in: .named("scroll")).minY)]
                )
        }
    }
}

//#Preview {
//    CalendarView()
//}
