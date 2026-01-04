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
            case .success(let dinnerStatusWithUsers):
                let dinnerStatus = dinnerStatusWithUsers.0
                let users = dinnerStatusWithUsers.1
                
                state.dinnerStatus = dinnerStatus
                
                var mappedAnswers: [(name: String, answer: DinnerAnswer)] = []
                
                for (userId, answer) in dinnerStatus.answers {
                    let name = users.first(where: { $0.id == userId })?.name ?? "不明"
                    mappedAnswers.append((name: name, answer: answer))
                }
                mappedAnswers.sort { $0.name < $1.name }
                state.answers = mappedAnswers
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
            async let dinner: Result<(DinnerStatus, [User]), DinnerStatusError> = {
                do {
                    guard
                        let dinnerStatusWithUsers = try await dinnerStatusService.loadDinnerStatusWithUsers(groupId: groupId, date: now())
                    else
                        { return .failure(DinnerStatusError.faileLoadDinnerStatus) }
                    
                    return .success(dinnerStatusWithUsers)
                } catch {
                    return .failure(DinnerStatusError.faileLoadDinnerStatus)
                }
            }()
            
            async let schedules: Result<[(Schedule, [User])], ScheduleError> = {
                do {
                    let schedules = try await scheduleService.loadScheduleCreatedInLast24Hours(calendarId: calendarId, now: now())
                    
                    return .success(schedules)
                } catch {
                    return .failure(ScheduleError.failLoadSchedule)
                }
            }()
            
            return .initialResponse(dinner: await dinner, schedule: await schedules)
        }
    }
}
