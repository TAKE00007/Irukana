import FirebaseFirestore

struct UserDoc: Codable {
    @DocumentID var id: String?
    let name: String
    let passwordHash: String
    let birthday: Timestamp?
}

extension UserDoc {
    func toDomain() -> User? {
        guard let id, let uid = UUID(uuidString: id) else { return nil }
        
        return User(
            id: uid,
            name: name,
            birthday: birthday?.dateValue()
        )
    }
}

extension User {
    func toDoc(passwordHash: String) -> UserDoc {
        let uid = id.uuidString
        
        let birthdayTimeStamp = birthday.map { Timestamp(date: $0) }
        
        return UserDoc(
            id: uid,
            name: name,
            passwordHash: passwordHash,
            birthday: birthdayTimeStamp
        )
    }
}
