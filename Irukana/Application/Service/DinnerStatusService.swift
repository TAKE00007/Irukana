import Foundation

struct DinnerStatusService {
    let dinnerStatusRepository: DinnerStatusRepository
    let userRepository: UserRepository
    
    func upsertDinnerStatus(groupId: UUID, date: Date, userId: UUID, isYes: Bool) async throws {
        let answer: DinnerAnswer = isYes ? .need : .noneed
        try await dinnerStatusRepository.upsertAnswer(groupId: groupId, date: date, userId: userId, answer: answer)
    }
    
    func loadDinnerStatus(groupId: UUID, date: Date) async throws -> DinnerStatus? {
        return try await dinnerStatusRepository.fetch(groupId: groupId, date: date)
    }
    
    func loadDinnerStatusWithUsers(groupId: UUID, date: Date) async throws -> (DinnerStatus, [User])? {
        guard let dinnerStatus = try await dinnerStatusRepository.fetch(groupId: groupId, date: date)
        else { return nil }
        let userIds = Array(dinnerStatus.answers.keys)
        
        let users: [User] = try await withThrowingTaskGroup(of: User.self) { group in
            for userId in userIds {
                group.addTask {
                    guard let user = try await userRepository.fetchUser(id: userId)
                    else { throw UserError.userNotFound }
                    return user
                }
            }

            var fetchedUsers: [User] = []
            
            for try await user in group {
                fetchedUsers.append(user)
            }

            return fetchedUsers
        }
        
        return (dinnerStatus, users)
    }
    
    func loadDinnerStatusMonth(groupId: UUID, date: Date) async throws -> [DinnerStatus]? {
        return try await dinnerStatusRepository.fetchMonth(groupId: groupId, anyDayInMonth: date)
    }
}
