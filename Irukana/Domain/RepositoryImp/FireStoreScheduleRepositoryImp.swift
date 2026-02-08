import Foundation
import FirebaseFirestore

final class FireStoreScheduleRepositoryImp: ScheduleRepository {
    private let db = Firestore.firestore()
    private var col: CollectionReference { db.collection("schedules") }
    
    func addSchedule(calendarId: UUID, title: String, startAt: Date, endAt: Date, notifyAt: Date?, color: ScheduleColor, isAllDay: Bool) async throws -> Schedule {
        let id = UUID()
        
        let ref = col.document(id.uuidString)
        
        let schedule = Schedule(id: id, calendarId: calendarId, title: title, startAt: startAt, endAt: endAt, notifyAt: notifyAt, color: color, isAllDay: isAllDay, createdAt: Date())
        
        let docSchedule = schedule.toDoc()
        
        try ref.setData(from: docSchedule)
        
        return schedule
    }
    
    func updateSchedule(id: UUID, calendarId: UUID, title: String, startAt: Date, endAt: Date, notifyAt: Date?, color: ScheduleColor, isAllDay: Bool) async throws -> Schedule {
        let ref = col.document(id.uuidString)
        
        let schedule = Schedule(
            id: id,
            calendarId: calendarId,
            title: title,
            startAt: startAt,
            endAt: endAt,
            notifyAt: notifyAt,
            color: color,
            isAllDay: isAllDay,
            createdAt: Date()
        )
        
        let docSchedule = schedule.toDoc()
        
        // 指定した予定があるかどうか
        let snap = try await col.whereField("id", isEqualTo: id.uuidString).getDocuments()
        guard !snap.documents.isEmpty else {
            throw ScheduleError.scheduleNotFound
        }
        
        try ref.setData(from: docSchedule)
        
        return schedule
    }
    
    func fetch(id: UUID) async throws -> Schedule? {
        let calId = id.uuidString
        let snap = try await col.document(calId).getDocument()
        guard snap.exists else { return nil }
        
        let schedule = try snap.data(as: ScheduleDoc.self)
        
        return schedule.toDomain()
    }
    
    func fetchRecentlyCreated(calendarId: UUID, createdAt: Date) async throws -> [Schedule]? {
        let (start, end) = FormatterStore.last24HoursRange(for: createdAt)
        
        let response = try await col
            .whereField("calendarId", isEqualTo: calendarId.uuidString)
            .whereField("createdAt", isGreaterThanOrEqualTo: start)
            .whereField("createdAt", isLessThan: end)
            .order(by: "createdAt", descending: false)
            .getDocuments()
        
        return try response.documents.compactMap { try $0.data(as: ScheduleDoc.self).toDomain() }
    }
    
    func fetchMonth(calendarId: UUID, anyDayInMonth: Date) async throws -> [Schedule] {
        let (start, end) = FormatterStore.monthRange(for: anyDayInMonth)
        
        let response = try await col
            .whereField("calendarId", isEqualTo: calendarId.uuidString)
            .whereField("startAt", isGreaterThanOrEqualTo: start)
            .whereField("startAt", isLessThan: end)
            .order(by: "startAt", descending: false)
            .getDocuments()
        
        return try response.documents.compactMap {
            try $0.data(as: ScheduleDoc.self).toDomain()
        }
    }
    
    func deleteSchedule(id: UUID) async throws {
        let ref = col.document(id.uuidString)
        
        try await ref.delete()
    }
}
