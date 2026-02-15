import Foundation

enum SettingAction {
    case onAppear
    
    case tapLogout
    case logoutCompleted
    
    case setNotificationTime(Date)
    case setIsNotification(Bool)
    case setNotificationCompleted
    
    case userResponse(Result<[User], UserError>)
    
    case deleteUser(User)
    case deleteCompleted
}

enum SettingEffect {
    case logout

    case setNotification(Date)
    case deleteNotification
    
    case loadUsers
    case deleteUser(User)
}
