import Foundation

struct SettingState: Equatable {
    var users: [User] = []
    var isNotification = false
    var notificationTime: Date
    var isLogOut: Bool = false
}
