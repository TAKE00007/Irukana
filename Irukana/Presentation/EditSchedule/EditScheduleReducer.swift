import Foundation

struct EditScheduleReducer {
    let scheduleService: ScheduleService
    let calendarService: CalendarService
    let groupId: UUID
    let scheduleId: UUID
    let userId: UUID
    let calendarId: UUID
    var now: () -> Date = { Date() }
    
    init(
        scheduleService: ScheduleService,
        calendarService: CalendarService,
        groupId: UUID,
        scheduleId: UUID,
        userId: UUID,
        calendarId: UUID,
        now: @escaping () -> Date
    ) {
        self.scheduleService = scheduleService
        self.calendarService = calendarService
        self.groupId = groupId
        self.scheduleId = scheduleId
        self.userId = userId
        self.calendarId = calendarId
        self.now = now
    }
    
    func reduce(state: inout EditScheduleState, action: EditScheduleAction) -> EditScheduleEffect? {
        switch action {
        case .onAppear:
            return .loadUsers
        case .setTitle(let title):
            state.title = title
            return nil
        case .setAllDay(let isAllday):
            state.isAllDay = isAllday
            return nil
        case .setStartAt(let date):
            state.startAt = date
            if !state.isEdited {
                state.endAt = state.calendar.date(
                    byAdding: .hour,
                    value: 1,
                    to: state.startAt
                ) ?? date.addingTimeInterval(3600)
            }
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
        case .toggleUserSelection(let user):
            if state.selectedUsers.contains(user) {
                state.selectedUsers.remove(user)
            } else {
                state.selectedUsers.insert(user)
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
                userIds: Array(state.selectedUsers.map { $0.id })
            )
        case .saveResponse(let result):
            switch result {
            case .success(_):
                return nil
            case .failure(_):
                // TODO: 何かアラートを出すようにする
                return nil
            }
        case .usersResponse(let result):
            switch result {
            case .success(let users):
                state.users = users
                return nil
            case .failure(_):
                // TODO: 後でエラー処理を書く
                return nil
            }
        case .tapDelete:
            return .deleteSchedule
        case .deleteResponse(_):
            return nil
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
        case .loadUsers:
            do {
                let users = try await calendarService.loadUsers(groupId: groupId)
                guard !users.isEmpty else {
                    return .usersResponse(.failure(.userNotFound))
                }
                return .usersResponse(.success(users))
            } catch {
                return .usersResponse(.failure(.userNotFound))
            }
        case .deleteSchedule:
            do {
                try await scheduleService.deleteSchedule(scheduleId: scheduleId)
                return .deleteResponse(nil)
            } catch {
                return .deleteResponse(.failAddSchedule)
            }
        }
    }
}
