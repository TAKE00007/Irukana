import Foundation

struct NotificationReducer {
    let dinnerStatusService: DinnerStatusService
    let scheduleService: ScheduleService
    let calendarId: UUID
    let groupId: UUID
    var now: () -> Date = { Date() }
    
    init(
        dinnerStatusService: DinnerStatusService,
        scheduleService: ScheduleService,
        calendarId: UUID,
        groupId: UUID,
        now: @escaping () -> Date = { Date() }
    ) {
        self.dinnerStatusService = dinnerStatusService
        self.scheduleService = scheduleService
        self.calendarId = calendarId
        self.groupId = groupId
        self.now = now
    }
    
    func reduce(state: inout NotificationState, action: NotificationAction) -> NotificationEffect? {
        switch action {
        case .onAppear:
            state.isLoading = true
            state.dinnerStatusErrorMessage = nil
            state.scheduleErrorMessage = nil
            return .loadInitial
        case let .initialResponse(dinner: dinnerResult, schedule: scheduleResult):
            state.isLoading = false
            
            switch dinnerResult {
            case .success(let dinnerStatus):
                state.dinnerStatus = dinnerStatus
            case .failure(let error):
                state.dinnerStatusErrorMessage = error.errorDescription
            }
            
            switch scheduleResult {
            case .success(let schedules):
                state.schedules = schedules
            case .failure(let error):
                state.scheduleErrorMessage = error.errorDescription
            }
            
            return nil
        }
    }
    
    func run(_ effect: NotificationEffect) async -> NotificationAction {
        switch effect {
        case .loadInitial:
            async let dinner: Result<DinnerStatus, DinnerStatusError> = {
                do {
                    guard
                        let dinnerStatus = try await dinnerStatusService.loadDinnerStatus(groupId: groupId, date: now())
                    else
                        { return .failure(DinnerStatusError.faileLoadDinnerStatus) }
                    
                    return .success(dinnerStatus)
                } catch {
                    return .failure(DinnerStatusError.faileLoadDinnerStatus)
                }
            }()
            
            async let schedules: Result<[Schedule], ScheduleError> = {
                do {
                    guard
                        let schedules = try await scheduleService.loadScheduleCreatedInLast24Hours(calendarId: calendarId, now: now())
                    else { return .failure(ScheduleError.failLoadSchedule) }
                    
                    return .success(schedules)
                } catch {
                    return .failure(ScheduleError.failLoadSchedule)
                }
            }()
            
            return .initialResponse(dinner: await dinner, schedule: await schedules)
        }
    }
}
