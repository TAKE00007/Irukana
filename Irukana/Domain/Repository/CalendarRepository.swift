import Foundation

protocol CalendarRepository {
    func createCalendar(id: UUID, groupId: UUID, name: String) async throws -> CalendarInfo
    func fetchCalendar(id: String) async throws -> CalendarInfo?
    func fetchCalendarsByGroupId(groupId: UUID) async throws -> [CalendarInfo]
}
