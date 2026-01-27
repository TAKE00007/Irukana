import Foundation

struct CalendarService {
    let calendarRepository: CalendarRepository
    let groupRepository: GroupRepository
    let userRepository: UserRepository
    
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

    func loadUsers(groupId: UUID) async throws -> [User] {
        let userIds = try await groupRepository.fetchUserIds(groupId: groupId)
        guard !userIds.isEmpty else { return [] }
        
        let users: [User] = try await withThrowingTaskGroup(of: User.self) { group in
            for userId in userIds {
                group.addTask {
                    guard let user = try await userRepository.fetchUser(id: userId)
                    else { throw UserError.userNotFound }
                    return user
                }
            }
            
            var fetcedUsers: [User] = []
            
            for try await user in group {
                fetcedUsers.append(user)
            }
            
            return fetcedUsers
        }
        return users
    }
}
