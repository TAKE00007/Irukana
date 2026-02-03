import Foundation

enum SettingAction {
    case tapLogout
    case logoutCompleted
    
    case setNotificationTime(Date)
    case setIsNotification(Bool)
    case setNotificationCompleted
}

enum SettingEffect {
    case logout
    case setNotification(Date)
}
