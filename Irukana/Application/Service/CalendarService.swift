import Foundation

struct CalendarService {
    let calendarRepository: CalendarRepository
    let groupRepository: GroupRepository
    
    func createCalendarInfo(userId: UUID, name: String) async throws -> CalendarInfo {
        let id = UUID()
        let groupId = UUID()
        
        // TODO: 要検討部分
        try await groupRepository.addGroup(userId: userId, groupId: groupId)
        
        return try await calendarRepository.createCalendar(id: id, groupId: groupId, name: name)
    }
    
    // TODO: アップデートするのも必要
    
    func loadCalendarInfo(id: UUID) async throws -> CalendarInfo? {
        return try await calendarRepository.fetchCalendar(id: id)
    }
}
