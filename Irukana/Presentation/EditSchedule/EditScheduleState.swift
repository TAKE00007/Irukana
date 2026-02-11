import Foundation

struct EditScheduleState: Equatable {
    var calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        return cal
    }()
    
    var title:String
    var isAllDay: Bool
    var startAt: Date
    var endAt: Date
    var notifyAt: ScheduleReminder?
    var color: ScheduleColor
    
    var users: [User]
    var selectedUserIds: Set<UUID> = []
    
    var isEdited = false
    
    init(
        calendar: Calendar,
        title: String,
        isAllDay: Bool,
        startAt: Date,
        endAt: Date,
        notifyAt: ScheduleReminder?,
        color: ScheduleColor,
        users: [User],
    ) {
        self.calendar = calendar
        self.title = title
        self.isAllDay = isAllDay
        self.startAt = startAt
        self.endAt = endAt
        self.notifyAt = notifyAt
        self.color = color
        self.users = users
        self.selectedUserIds = Set(users.map(\.id))
    }
}
