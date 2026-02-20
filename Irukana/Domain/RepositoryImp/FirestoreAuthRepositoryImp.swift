import Foundation
import FirebaseFirestore

final class FirestoreAuthRepositoryImp: AuthRepository {
    private let db = Firestore.firestore()
    private var col: CollectionReference { db.collection("users") }
    
    func login(name: String, password: String) async throws -> User {
        // パスワードをハッシュ化
        let hash = hashPassword(password)
    
        let snap = try await col
            .whereField("name", isEqualTo: name)
            .whereField("passwordHash", isEqualTo: hash)
            .getDocuments()
        
        guard let doc = snap.documents.first else {
            throw AuthError.failLogin
        }
        
        let userDoc = try doc.data(as: UserDoc.self)

        guard let user = userDoc.toDomain() else {
            throw AuthError.invalidUserData
        }
        
        return user
    }
    
    func signUp(name: String, password: String, birthday: Date?) async throws -> User {
        let id = UUID()
        let hash = hashPassword(password)
        
        let ref = col.document(id.uuidString)
        
        // nameが重複してないか
        let snap = try await col.whereField("name", isEqualTo: name).getDocuments()
        guard snap.documents.isEmpty else {
            throw AuthError.nameAlreadyExist
        }
                
        let user = User(id: id, name: name, birthday: birthday)
        let userDoc = user.toDoc(passwordHash: hash)
        try ref.setData(from: userDoc)
        
        return user
    }
}
