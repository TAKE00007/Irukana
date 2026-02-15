import Foundation

struct GroupService {
    let groupRepository: GroupRepository

    func deleteUserInGroup(userId: UUID, groupId: UUID) async throws{
        try await groupRepository.deleteeUserId(userId: userId, groupId: groupId)
    }
}
