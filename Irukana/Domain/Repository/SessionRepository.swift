import Foundation

protocol SessionRepository {
    func loadUserId() -> String?
    func saveUserId(_ userId: String)
    func clearUserId()
}

enum UserDefaultsKey {
    static let userId = "userId"
}
