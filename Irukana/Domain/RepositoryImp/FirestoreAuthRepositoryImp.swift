//
//  FirestoreAuthRepositoryImp.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/11/23.
//

import Foundation
import FirebaseFirestore

final class FirestoreAuthRepositoryImp: AuthRepository {
    private let db = Firestore.firestore()
    private var col: CollectionReference { db.collection("users") }
    
    func login(name: String, password: String) async throws -> User {
        // パスワードをハッシュ化
        let hash = hashPassword(password)
        
        // ユーザーネームが等しいものが見つかれば返す
        let snap = try await col.whereField("name", isEqualTo: name).getDocuments()
        
        guard let doc = snap.documents.first else {
            // TODO: エラーは後で書く
            throw NSError()
        }
        
        let userDoc = try doc.data(as: UserDoc.self)
        
        guard userDoc.passwordHash == hash else {
            // TODO: エラーは後でかく
            throw NSError()
        }
        
        guard let user = userDoc.toDomain() else {
            // TODO: エラーは後でかく
            throw NSError()
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
            // TODO: エラーは後でかく
            throw NSError()
        }
                
        let user = User(id: id, name: name, passwordHash: hash, birthday: birthday)
        
        let userDoc = user.toDoc(id: id)
        
        try ref.setData(from: userDoc)
        
        return user
    }
}
