import Foundation

enum AddAction {
    case onAppear
    
    case tapDinnerYes
    case tapDinnerNo
    
    // 予定追加
    case setTitle(String)
    case setAllDay(Bool)
    case setStartAt(Date)
    case setEndAt(Date)
    case setNotifyAt(ScheduleReminder)
    case setColor(ScheduleColor)
    
    case tapSave
    
    case dinnerStatusResponse(Result<Bool, DinnerStatusError>)
    case saveResponse(Result<Schedule, ScheduleError>)
    case usersResponse(Result<[User], UserError>)
    
    case toggleUserSelection(UUID)
}

enum AddEffect {
    case upsert(isYes: Bool)
    case saveSchedule(calendarId: UUID, title: String, startAt: Date, endAt: Date, notifyAt: ScheduleReminder?, color: ScheduleColor, isAllDay: Bool, userIds: [UUID])
    case loadUsers
}
