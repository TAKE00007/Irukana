import Foundation

enum SettingAction {
    case tapLogout
    case logoutCompleted
    
    case setNotificationTime(Date)
    case setIsNotification(Bool)
    case setNotificationCompleted
    
    case deleteUser(User)
    case deleteCompleted
}

enum SettingEffect {
    case logout
    case setNotification(Date)
    
    case deleteUser(User)
}
