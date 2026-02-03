import Foundation

protocol SessionRepository {
    func loadUserId() -> String?
    func saveUserId(_ userId: String)
    func loadIsNotification() -> Bool?
    func saveIsNotification(_ isNotification: Bool)
    func clearUserId()
}

enum UserDefaultsKey {
    static let userId = "userId"
    static let isNotification = "isNotification"
}
