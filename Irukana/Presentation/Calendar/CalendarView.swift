import SwiftUI
import UIKit

struct CalendarView: View {
    private var reducer: CalendarReducer
    @State private var state = CalendarState()
    
    let user: User
    let groupId: UUID
    
    init(reducer: CalendarReducer, user: User, groupId: UUID) {
        self.reducer = reducer
        self.user = user
        self.groupId = groupId
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                MonthTitle(date: state.visibleMonthStart ?? Date())
                Spacer()
                // TODO: 本当はSwiftUIでやりたい
                Button {
                    UIPasteboard.general.string = state.calendarId?.uuidString
                    reducer.reduce(state: &state, action: .tapCopy)
                } label: {
                    Image(systemName: "calendar")
                        .foregroundStyle(.black)
                }
                .padding(.trailing, 12)
                
            }
            .padding(.vertical, 8)
            .alert("コピーしました", isPresented: $state.showCopiedAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(state.calendarId?.uuidString ?? "")
            }
            
            WeekdayHeader()
                .padding(.bottom, 4)
        }
        
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(state.offsetRange, id: \.self) { offset in
                    
                        let monthStart = state.calendar.date(byAdding: .month, value: offset, to: state.baseMonthStart)!
                        
                        HStack {
                            Text(monthStart.formatted(.dateTime.month()))
                                .foregroundStyle(state.calendar.isDate(monthStart, equalTo: state.baseMonthStart, toGranularity: .month) ? .red : .black)
                                .font(.title2)
                                .bold()
                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        
                        Divider()
                        
                        MonthGrid(
                            user: user,
                            monthStart: monthStart,
                            calendar: state.calendar,
                            answerByDay: state.answerByDay,
                            scheduleByDay: state.scheduleByDay,
                            groupId: groupId
                        )
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
    let user: User
    let monthStart: Date
    let calendar: Calendar
    let answerByDay: [Date : [(name: String, answer: DinnerAnswer)]]
    let scheduleByDay: [Date : [(Schedule, [User])]]
    let groupId: UUID
    
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
                let status = answerByDay[key]
                let scheduleStatus = scheduleByDay[key]

                DayCell(
                    user: user,
                    day: day,
                    answers: status ?? [],
                    schedules: scheduleStatus ?? [],
                    calendar: calendar,
                    groupId: groupId
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
    @Environment(\.injected) private var container
    let user: User
    let day: Int
    let answers: [(name: String, answer: DinnerAnswer)]
    let schedules: [(Schedule, [User])]
    let calendar: Calendar
    let groupId: UUID
    
    var body: some View {
        VStack(spacing: 5) {
            Text("\(day)")
            ForEach(answers, id: \.name) { (name, answer) in
                HStack {
                    Text(name.prefix(1))
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
            // TODO: 予定を長押しした時にカレンダーの情報が表示されるようにしたい
            // 名前は取得できるようにした
            if !schedules.isEmpty {
                ForEach(schedules, id: \.0.id) { (schedule, users) in
                    NavigationLink {
                        EditScheduleView(
                            reducer: EditScheduleReducer(
                                scheduleService: container.scheduleService,
                                calendarService: container.calendarService,
                                groupId: groupId,
                                scheduleId: schedule.id,
                                userId: user.id,
                                calendarId: schedule.calendarId,
                                now: { Date() }
                            ),
                            state: EditScheduleState(
                                calendar: calendar,
                                title: schedule.title,
                                isAllDay: schedule.isAllDay,
                                startAt: schedule.startAt,
                                endAt: schedule.endAt,
                                color: schedule.color,
                                users: users
                            )
                        )
                    } label: {
                        HStack {
                            Text(schedule.title)
                            Spacer()
                        }
                        .font(.caption)
                        .lineLimit(1)
                        .foregroundStyle(Color.black)
                        .frame(maxWidth: .infinity)
                        .background(schedule.color.color.opacity(0.2))
                    }
                }
            }
            
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
