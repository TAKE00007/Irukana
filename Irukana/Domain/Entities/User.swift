import Foundation

struct User: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var name: String
    var photoURL: String?
    var birthday: Date?
    
    init(id: UUID, name: String, photoURL: String? = nil, birthday: Date? = nil) {
        self.id = id
        self.name = name
        self.photoURL = photoURL
        self.birthday = birthday
    }
}
