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
}
