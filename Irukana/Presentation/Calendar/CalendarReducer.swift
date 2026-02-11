import Foundation

struct CalendarReducer {
    let dinnerStatusService: DinnerStatusService
    let scheduleService: ScheduleService
    let user: User
    let calendarId: UUID
    let groupId: UUID
    var now: () -> Date = { Date() }
    
    init(dinnerStatusService: DinnerStatusService, scheduleService: ScheduleService, user: User, calendarId: UUID, groupId: UUID, now: @escaping () -> Date) {
        self.dinnerStatusService = dinnerStatusService
        self.scheduleService = scheduleService
        self.user = user
        self.calendarId = calendarId
        self.groupId = groupId
        self.now = now
    }
    
    @discardableResult
    func reduce(state: inout CalendarState, action: CalendarAction) -> CalendarEffect? {
        switch action {
        case .onAppear:
            state.calendarId = calendarId
            state.isLoading = true
            state.visibleMonthStart = state.baseMonthStart
            let monthStart = state.visibleMonthStart ?? Date()
            return .load(visibleMonthStart: monthStart)
        case let .initialResponse(dinner: dinnerResult, schedule: scheduleResult):
            state.isLoading = false
            
            switch dinnerResult {
            case .success(let dinnerStatusWithUsers):
                let (dinnerStatuses, users) = dinnerStatusWithUsers
                state.dinnerStatusList = dinnerStatuses
                
                let userById = Dictionary(uniqueKeysWithValues: users.map { ($0.id, $0) })
                
                var answerByDay: [Date: [(name: String, answer: DinnerAnswer)]] = [:]
                for dinnerStatus in dinnerStatuses {
                    var mappedAnswers: [(name: String, answer: DinnerAnswer)] = []
                    for (userId, answer) in dinnerStatus.answers {
                        let name = userById[userId]?.name ?? "不明"
                        mappedAnswers.append((name: name, answer: answer))
                    }
                    mappedAnswers.sort { $0.name < $1.name }
                    answerByDay[dinnerStatus.day] = mappedAnswers
                }
                state.answerByDay = answerByDay
                state.errorMessage = nil
            case .failure(let error):
                state.isLoading = false
                state.errorMessage = error.errorDescription
            }
            
            switch scheduleResult {
            case .success(let scheduleList):
                state.scheduleList = scheduleList
                let byDay = Dictionary(grouping: scheduleList) { schedule in
                    Calendar.current.startOfDay(for: schedule.0.startAt)
                }
                state.scheduleByDay = byDay
                state.scheduleErrorMessage = nil
            case .failure(let error):
                state.isLoading = false
                state.scheduleErrorMessage = error.errorDescription
            }
            
            return nil
        case .tapCopy:
            state.showCopiedAlert = true
            return nil
        case .updateSchedule(let schedule):
            var foundUsers: [User]? = nil
            for (key, list) in state.scheduleByDay {
                if let index = list.firstIndex(where: { $0.0.id == schedule.id }) {
                    foundUsers = list[index].1
                    state.scheduleByDay[key]?.remove(at: index)
                    break
                }
            }
            
            let newKey = state.calendar.startOfDay(for: schedule.startAt)
            
            // TODO: userも編集時に返す必要がありそう
            let users = foundUsers ?? []
            
            state.scheduleByDay[newKey, default: []].append((schedule, users))
            
            return nil
        }
    }
        
    func run(_ effect: CalendarEffect) async -> CalendarAction {
        // baseMonthStatrに基づいて1ヶ月分ロードする
        // 別でonChangeでカレンダーの月が変わった時に1ヶ月分ロードするようにする
        switch effect {
        case .load(let visibleMonthStart):
            async let dinnerStatusList: Result<([DinnerStatus],[User]),DinnerStatusError> = {
                do {
                    let  dinnerStatusList = try await dinnerStatusService.loadDinnerStatusMonth(groupId: groupId, date:visibleMonthStart)
                    return .success(dinnerStatusList)
                } catch {
                    return .failure(DinnerStatusError.faileLoadDinnerStatus)
                }
            }()
            
            async let scheduleList: Result<[(Schedule, [User])], ScheduleError> = {
                do {
                    let scheduleList = try await scheduleService.loadScheduleMonth(calendarId: calendarId, now: visibleMonthStart)
                    guard !scheduleList.isEmpty
                    else { return .failure(ScheduleError.failLoadSchedule) }
                    
                    return .success(scheduleList)
                } catch {
                    return .failure(ScheduleError.failLoadSchedule)
                }
            }()
            
            return .initialResponse(dinner: await dinnerStatusList, schedule: await scheduleList)
        }
    }
}
