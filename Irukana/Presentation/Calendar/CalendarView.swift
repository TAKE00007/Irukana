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
                        
                        MonthGrid(monthStart: monthStart, calendar: state.calendar, dinnerStatusByDay: state.dinnerStatusByDay, scheduleByDay: state.scheduleByDay)
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
                    let response = await reducer.run(effect)
                    _ = reducer.reduce(state: &state, action: response)
                }
            }
        }
    }
}

private struct MonthTitle: View {
    let date: Date
    var body: some View {
        HStack {
            Text(date.formatted(.dateTime.year().month()))
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
    let dinnerStatusByDay: [Date : DinnerStatus]
    let scheduleByDay: [Date : Schedule]
    
    private var columns: [GridItem] { Array(repeating: .init(.flexible()), count: 7) }
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach((0..<firstWeekdayIndex).map { "pad-\($0)" }, id: \.self) { _ in
                Color.clear
                    .frame(maxWidth: .infinity, minHeight: 32)
            }
            ForEach(1...numberOfDays, id: \.self) { day in
                let date = calendar.date(bySetting: .day, value: day, of: monthStart)!
                let key = calendar.startOfDay(for: date)
                let status = dinnerStatusByDay[key]
                let scheduleStatus = scheduleByDay[key]

                DayCell(
                    day: day,
                    answers: status?.answers ?? [:],
                    schedule: scheduleStatus?.title ?? ""
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
    let schedule: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text("\(day)")
            ForEach(answers.keys.sorted(by: { $0.uuidString < $1.uuidString }), id: \.self) { uuid in
                let answer = answers[uuid] ?? .unknown
                HStack {
                    Text(uuid.uuidString.prefix(1))
                        .padding(2)
                        .background(
                            Circle()
                                .fill(Color(.systemBackground)) //色は仮
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.secondary, lineWidth: 1)
                        )
                    Text(label(for: answer))
                }
                .font(.caption)
                .lineLimit(1)
                .frame(maxWidth: .infinity)
                .background(statusColor(for: answer))
            }
            Text(schedule)
                .font(.caption)
            
            Spacer(minLength: 0)
        }
        .bold()
        .frame(
            maxWidth: .infinity,
            minHeight: 120,
            maxHeight: 120,
        )
    }
}

private func label(for answer: DinnerAnswer) -> String {
    switch answer {
    case .need: return "いる"
    case .noneed: return "いらない"
    case .unknown: return "未回答"
    }
}

private func statusColor(for answer: DinnerAnswer) -> Color {
    switch answer {
    case .need: return .green.opacity(0.2)
    case .noneed: return .red.opacity(0.2)
    case .unknown: return .gray.opacity(0.2)
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
