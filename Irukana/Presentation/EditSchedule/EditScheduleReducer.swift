import Foundation

struct EditScheduleReducer {
    let scheduleService: ScheduleService
    let scheduleId: UUID
    let userId: UUID
    let calendarId: UUID
    var now: () -> Date = { Date() }
    
    init(
        scheduleService: ScheduleService,
        scheduleId: UUID,
        userId: UUID,
        calendarId: UUID,
        now: @escaping () -> Date
    ) {
        self.scheduleService = scheduleService
        self.scheduleId = scheduleId
        self.userId = userId
        self.calendarId = calendarId
        self.now = now
    }
    
    func reduce(state: inout EditScheduleState, action: EditScheduleAction) -> EditScheduleEffect? {
        switch action {
        case .setTitle(let title):
            state.title = title
            return nil
        case .setAllDay(let isAllday):
            state.isAllDay = isAllday
            return nil
        case .setStartAt(let date):
            state.startAt = date
            return nil
        case .setEndAt(let date):
            state.endAt = date
            return nil
        case .setNotifyAt(let notifyAt):
            state.notifyAt = notifyAt
            return nil
        case .setColor(let scheduleColor):
            state.color = scheduleColor
            return nil
        case .toggleUserSelection(let uuid):
            if state.selectedUserIds.contains(uuid) {
                state.selectedUserIds.remove(uuid)
            } else {
                state.selectedUserIds.insert(uuid)
            }
            return nil
        case .tapSave:
            return .saveSchedule(
                calendarId: calendarId,
                title: state.title,
                startAt: state.startAt,
                endAt: state.endAt,
                notifyAt: state.notifyAt,
                color: state.color,
                isAllDay: state.isAllDay,
                userIds: Array(state.selectedUserIds)
            )
        case .saveResponse(let result):
            switch result {
            case .success(_):
                return nil
            case .failure(let error):
                // 何かアラートを出すようにする
                return nil
            }
        }
    }
    
    func run(_ effect: EditScheduleEffect) async -> EditScheduleAction {
        switch effect {
        case .saveSchedule(let calendarId, let title, let startAt, let endAt, let notifyAt, let color, let isAllDay, let userIds):
            do {
                let schedule = try await scheduleService.updateSchedule(id: scheduleId, calendarId: calendarId, title: title, startAt: startAt, endAt: endAt, notifyAt: notifyAt, color: color, isAllDay: isAllDay, userIds: userIds)
                
                return .saveResponse(.success(schedule))
            } catch {
                return .saveResponse(.failure(.failAddSchedule)) // エラーを更新用にする
            }
        }
    }
}
