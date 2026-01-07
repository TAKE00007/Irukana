import Foundation

struct CalendarReducer {
    let dinnerStatusService: DinnerStatusService
    let scheduleService: ScheduleService
    let calendarId: UUID
    let groupId: UUID
    var now: () -> Date = { Date() }
    
    init(dinnerStatusService: DinnerStatusService, scheduleService: ScheduleService, calendarId: UUID, groupId: UUID, now: @escaping () -> Date) {
        self.dinnerStatusService = dinnerStatusService
        self.scheduleService = scheduleService
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
            case .success(let dinnerStatusList):
                state.dinnerStatusList = dinnerStatusList
                state.dinnerStatusByDay = Dictionary(uniqueKeysWithValues: dinnerStatusList.map { ($0.day, $0) })
                state.errorMessage = nil
            case .failure(let error):
                state.isLoading = false
                state.errorMessage = error.errorDescription
            }
            
            switch scheduleResult {
            case .success(let scheduleList):
                state.scheduleList = scheduleList
                let byDay = Dictionary(grouping: scheduleList) { schedule in
                    Calendar.current.startOfDay(for: schedule.startAt)
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
        }
    }
        
    func run(_ effect: CalendarEffect) async -> CalendarAction {
        // baseMonthStatrに基づいて1ヶ月分ロードする
        // 別でonChangeでカレンダーの月が変わった時に1ヶ月分ロードするようにする
        switch effect {
        case .load(let visibleMonthStart):
            async let dinnerStatusList: Result<[DinnerStatus],DinnerStatusError> = {
                do {
                    guard let  dinnerStatusList = try await dinnerStatusService.loadDinnerStatusMonth(groupId: groupId, date:visibleMonthStart)
                    else { return .failure(DinnerStatusError.faileLoadDinnerStatus) }
                    
                    return .success(dinnerStatusList)
                } catch {
                    return .failure(DinnerStatusError.faileLoadDinnerStatus)
                }
            }()
            
            async let scheduleList: Result<[Schedule], ScheduleError> = {
                do {
                    guard let scheduleList = try await scheduleService.loadScheduleMonth(calendarId: calendarId, now: visibleMonthStart)
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
