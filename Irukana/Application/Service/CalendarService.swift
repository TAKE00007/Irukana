import Foundation

struct CalendarService {
    let calendarRepository: CalendarRepository
    let groupRepository: GroupRepository
    
    func createCalendarInfo(userId: UUID, name: String) async throws -> CalendarInfo {
        let id = UUID()
        let groupId = UUID()
        
        // TODO: 本当はまとめたい
        try await groupRepository.addGroup(userId: userId, groupId: groupId)
        
        return try await calendarRepository.createCalendar(id: id, groupId: groupId, name: name)
    }
    
    // TODO: アップデートするのも必要
    
    func loadCalendarInfo(id: String) async throws -> CalendarInfo? {
        guard let uuid = UUID(uuidString: id) else { return nil }
        return try await calendarRepository.fetchCalendar(id: uuid)
    }
}
