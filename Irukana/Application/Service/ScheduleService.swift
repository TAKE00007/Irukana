import Foundation

struct ScheduleService {
    let repository: ScheduleRepository
    
    func addSchedule(calendarId: UUID, title: String, startAt: Date, endAt: Date, notifyAt: ScheduleReminder?, color: ScheduleColor, isAllDay: Bool) async throws -> Schedule {
        
        let reminderDate = notifyAt?.reminderDate(startAt: startAt)
        
        let schedule = try await repository.addSchedule(calendarId: calendarId, title: title, startAt: startAt, endAt: endAt, notifyAt: reminderDate, color: color, isAllDay: isAllDay)
        
        return schedule
    }
    
    func loadScheduleCreatedInLast24Hours(calendarId: UUID, now: Date) async throws -> [Schedule]? {
        let schedules = try await repository.fetchRecentlyCreated(calendarId: calendarId, createdAt: now)
        
        return schedules
    }
}
