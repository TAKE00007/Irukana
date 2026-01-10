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
    
    func loadCalendarInfo(calendarId: String, userId: UUID) async throws -> CalendarInfo? {
        guard let calendarInfo = try await calendarRepository.fetchCalendar(id: calendarId)
        else { return nil }
        
        try await groupRepository.addGroup(userId: userId, groupId: calendarInfo.groupId)
        
        return calendarInfo
    }
}
