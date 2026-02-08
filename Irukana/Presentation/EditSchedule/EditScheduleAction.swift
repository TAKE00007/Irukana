import Foundation

enum EditScheduleAction {
    case setTitle(String)
    case setAllDay(Bool)
    case setStartAt(Date)
    case setEndAt(Date)
    case setNotifyAt(ScheduleReminder)
    case setColor(ScheduleColor)
    case toggleUserSelection(UUID)
    
    case tapSave
    
    case saveResponse(Result<Schedule, ScheduleError>)
}

enum EditScheduleEffect {
    case saveSchedule(calendarId: UUID, title: String, startAt: Date, endAt: Date, notifyAt: ScheduleReminder?, color: ScheduleColor, isAllDay: Bool, userIds: [UUID])
}
