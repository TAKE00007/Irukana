import Foundation

final class SessionRepositoryImp: SessionRepository {
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func loadUserId() -> String? {
        defaults.string(forKey: UserDefaultsKey.userId)
    }
    
    func saveUserId(_ userId: String) {
        defaults.set(userId, forKey: UserDefaultsKey.userId)
    }
    
    func clearUserId() {
        defaults.removeObject(forKey: UserDefaultsKey.userId)
    }
}
