import Foundation

enum EditScheduleAction {
    case onAppear
    
    case setTitle(String)
    case setAllDay(Bool)
    case setStartAt(Date)
    case setEndAt(Date)
    case setNotifyAt(ScheduleReminder)
    case setColor(ScheduleColor)
    case toggleUserSelection(UUID)
    
    case tapSave
    case tapDelete
    
    case saveResponse(Result<Schedule, ScheduleError>)
    case usersResponse(Result<[User], UserError>)
    case deleteResponse(ScheduleError?)
}

enum EditScheduleEffect {
    case saveSchedule(calendarId: UUID, title: String, startAt: Date, endAt: Date, notifyAt: ScheduleReminder?, color: ScheduleColor, isAllDay: Bool, userIds: [UUID])
    case loadUsers
    case deleteSchedule
}
