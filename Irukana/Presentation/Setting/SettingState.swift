import Foundation

struct SettingState: Equatable {
    var isNotification = false
    var notificationTime: Date
    var isLogOut: Bool = false
}
