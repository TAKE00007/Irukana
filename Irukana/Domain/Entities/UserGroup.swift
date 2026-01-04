import Foundation

struct UserGroup: Codable {
    let groupId: UUID
    let userId: UUID
    
    init(groupId: UUID, userId: UUID) {
        self.groupId = groupId
        self.userId = userId
    }
}
