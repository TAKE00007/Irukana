import Foundation

protocol CalendarRepository {
    func createCalendar(id: UUID, groupId: UUID, name: String) async throws -> CalendarInfo
    func fetchCalendar(id: UUID) async throws -> CalendarInfo?
}
