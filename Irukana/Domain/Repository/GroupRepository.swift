import Foundation

protocol GroupRepository {
    func addGroup(userId: UUID, groupId: UUID) async throws
    func fetchUserIds(groupId: UUID) async throws -> [UUID]
}
