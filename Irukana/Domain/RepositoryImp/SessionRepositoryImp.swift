import Foundation


// TODO: 後で処理を共通化する
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

    func loadIsNotification() -> Bool? {
        defaults.bool(forKey: UserDefaultsKey.isNotification)
    }
    
    func saveIsNotification(_ isNotification: Bool) {
        defaults.set(isNotification, forKey: UserDefaultsKey.isNotification)
    }
    
    func clearIsNotification() {
        defaults.removeObject(forKey: UserDefaultsKey.isNotification)
    }
}
