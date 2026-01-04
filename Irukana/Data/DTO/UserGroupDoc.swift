import FirebaseFirestore

struct UserGroupDoc: Codable {
    @DocumentID var id: String?
    var groupId: String
    var userId: String
}

extension UserGroupDoc {
    func toDomain() -> UserGroup? {
        guard let gId = UUID(uuidString: groupId) else { return nil }
        guard let uId = UUID(uuidString: userId) else { return nil }
        
        return UserGroup(groupId: gId, userId: uId)
    }
}

extension UserGroup {
    func toDoc() -> UserGroupDoc {
        let gId = groupId.uuidString
        let uId = userId.uuidString
        
        return UserGroupDoc(groupId: gId, userId: uId)
    }
}

