import FirebaseFirestore

struct ScheduleDoc: Codable {
    @DocumentID var id: String?
    let calendarId: String
    let title: String
    let startAt: Timestamp
    let endAt: Timestamp
    let notifyAt: Timestamp?
    let color: String
    let isAllDay: Bool
}

extension ScheduleDoc {
    func toDomain() -> Schedule? {
        guard let id, let uid = UUID(uuidString: id) else { return nil }
        
        guard let calId = UUID(uuidString: calendarId) else { return nil }
        
        let scheduleColor: ScheduleColor = ScheduleColor(rawValue: color) ?? .green
        
        return Schedule(
            id: uid,
            calendarId: calId,
            title: title,
            startAt: startAt.dateValue(),
            endAt: endAt.dateValue(),
            notifyAt: notifyAt?.dateValue(),
            color: scheduleColor,
            isAllDay: isAllDay
        )
    }
}

extension Schedule {
    func toDoc() -> ScheduleDoc {
        let uid = id.uuidString
        let calId = calendarId.uuidString
        
        let notifyAtTimeStamp = notifyAt.map { Timestamp(date: $0) }
        
        return ScheduleDoc(
            id: uid,
            calendarId: calId,
            title: title,
            startAt: Timestamp(date: startAt),
            endAt: Timestamp(date: endAt),
            notifyAt: notifyAtTimeStamp,
            color: color.rawValue,
            isAllDay: isAllDay
        )
    }
}
