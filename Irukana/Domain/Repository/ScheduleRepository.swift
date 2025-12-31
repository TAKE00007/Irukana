import Foundation

protocol ScheduleRepository {
    func addSchedule(calendarId: UUID, title: String, startAt: Date, endAt: Date, notifyAt: Date?, color: ScheduleColor, isAllDay: Bool) async throws -> Schedule
    func updateSchedule(id: UUID, calendarId: UUID, title: String, startAt: Date, endAt: Date, notifyAt: Date?, color: ScheduleColor, isAllDay: Bool) async throws -> Schedule
    func fetch(id: UUID) async throws -> Schedule?
    func fetchRecentlyCreated(calendarId: UUID, createdAt: Date) async throws -> [Schedule]?
    func fetchMonth(calendarId: UUID, anyDayInMonth: Date) async throws -> [Schedule]
    func deleteSchedule(id: UUID) async throws
}
