import Foundation
import FirebaseFirestore

final class FirestoreUserRepositoryImp: UserRepository {
    private let db = Firestore.firestore()
    private var col: CollectionReference { db.collection("users") }
    
    func fetchUser(id: UUID) async throws -> User? {
        let snap = try await col.document(id.uuidString).getDocument()
        
        guard snap.exists else {
            throw UserError.userNotFound
        }
        
        let user = try snap.data(as: UserDoc.self)
        
        return user.toDomain()
    }
}
