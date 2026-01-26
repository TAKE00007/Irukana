import Foundation

struct SettingReducer {
    let service: AuthService
    
    init(service: AuthService) {
        self.service = service
    }
    
    @discardableResult
    func reduce(state: inout SettingState, action: SettingAction) -> SettingEffect? {
        switch action {
        case .tapLogout:
            return .logout
        case .logoutCompleted:
            state.isLogOut = true
            return nil
        case .setNotificationTime(let notifyAt):
            state.notificationTime = notifyAt
            return nil
        case .setIsNotification(let isNotification):
            state.isNotification = isNotification
            return nil
        }
    }
    
    func run(_ effect: SettingEffect) -> SettingAction {
        switch effect {
        case .logout:
            service.logout()
            return .logoutCompleted
        }
    }
}
