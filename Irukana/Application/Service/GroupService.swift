import Foundation

struct GroupService {
    let userRepository: UserRepository
    let groupRepository: GroupRepository
    
    func feetchUsers(groupId: UUID) async throws -> [User] {
        let userIds = try await groupRepository.fetchUserIds(groupId: groupId)
        
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

    func deleteUserInGroup(userId: UUID, groupId: UUID) async throws{
        try await groupRepository.deleteeUserId(userId: userId, groupId: groupId)
    }
}
