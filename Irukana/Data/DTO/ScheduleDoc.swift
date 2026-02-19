import FirebaseFirestore

struct ScheduleDoc: Codable {
    @DocumentID var id: String?
    let calendarId: String
    let title: String
    let startAt: Timestamp
    let endAt: Timestamp
    let notifyAt: String?
    let color: String
    let isAllDay: Bool
    let createdAt: Timestamp
}

extension ScheduleDoc {
    func toDomain() -> Schedule? {
        guard let id, let uid = UUID(uuidString: id) else { return nil }
        
        guard let calId = UUID(uuidString: calendarId) else { return nil }
        
        let scheduleColor: ScheduleColor = ScheduleColor(rawValue: color) ?? .green
        
        let reminder: ScheduleReminder? = notifyAt.flatMap(ScheduleReminder.init(rawValue: ))
        
        return Schedule(
            id: uid,
            calendarId: calId,
            title: title,
            startAt: startAt.dateValue(),
            endAt: endAt.dateValue(),
            notifyAt: reminder,
            color: scheduleColor,
            isAllDay: isAllDay,
            createdAt: createdAt.dateValue()
        )
    }
}

extension Schedule {
    func toDoc() -> ScheduleDoc {
        let uid = id.uuidString
        let calId = calendarId.uuidString
        
        return ScheduleDoc(
            id: uid,
            calendarId: calId,
            title: title,
            startAt: Timestamp(date: startAt),
            endAt: Timestamp(date: endAt),
            notifyAt: notifyAt?.rawValue,
            color: color.rawValue,
            isAllDay: isAllDay,
            createdAt: Timestamp(date: createdAt)
        )
    }
}
