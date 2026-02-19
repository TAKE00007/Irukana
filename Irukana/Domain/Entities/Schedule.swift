import Foundation

struct Schedule: Identifiable, Codable, Equatable {
    let id: UUID
    let calendarId: UUID
    var title: String
    var startAt: Date
    var endAt: Date
    var notifyAt: ScheduleReminder?
    var color: ScheduleColor
    var isAllDay: Bool
    var createdAt: Date
    
    init(
        id: UUID,
        calendarId: UUID,
        title: String,
        startAt: Date,
        endAt: Date,
        notifyAt: ScheduleReminder?,
        color: ScheduleColor,
        isAllDay: Bool,
        createdAt: Date
    ) {
        self.id = id
        self.calendarId = calendarId
        self.title = title
        self.startAt = startAt
        self.endAt = endAt
        self.notifyAt = notifyAt
        self.color = color
        self.isAllDay = isAllDay
        self.createdAt = createdAt
    }
}
