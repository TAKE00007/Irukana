import Foundation
import FirebaseFirestore

struct FirestoreGroupRepositoryImp: GroupRepository {
    private let db = Firestore.firestore()
    private var col: CollectionReference { db.collection("usersGroups") }
    
    func addGroup(userId: UUID, groupId: UUID) async throws {
        let docId = "\(groupId.uuidString)_\(userId.uuidString)"
        let ref = col.document(docId)
        
        let userGroup = UserGroup(groupId: groupId, userId: userId)
        
        let docUserGroup = userGroup.toDoc()
        
        try ref.setData(from: docUserGroup)
    }
    
    func fetchUserIds(groupId: UUID) async throws -> [UUID] {
        let response = try await col.whereField("groupId", isEqualTo: groupId.uuidString).getDocuments()
        
        return try response.documents.compactMap { try $0.data(as: UserGroupDoc.self).toDomain()?.userId }
    }
    
    func fetchGroupIds(userId: UUID) async throws -> [UUID] {
        let response = try await col.whereField("userId", isEqualTo: userId.uuidString).getDocuments()
        
        return try response.documents.compactMap { try $0.data(as: UserGroupDoc.self).toDomain()?.groupId }
    }
    
    func deleteeUserId(userId: UUID, groupId: UUID) async throws {
        let docId = "\(groupId.uuidString)_\(userId.uuidString)"
        let ref = col.document(docId)
        
        try await ref.delete()
    }
}
