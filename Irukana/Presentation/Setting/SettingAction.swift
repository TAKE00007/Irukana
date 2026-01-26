import Foundation

enum SettingAction {
    case tapLogout
    case logoutCompleted
    
    case setNotificationTime(Date)
    case setIsNotification(Bool)
}

enum SettingEffect {
    case logout
}
