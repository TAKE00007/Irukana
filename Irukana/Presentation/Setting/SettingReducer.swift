import Foundation

struct SettingReducer {
    let service: AuthService
    let localNotificaitonService: LocalNotificationService
    
    init(service: AuthService, localNotificationService: LocalNotificationService) {
        self.service = service
        self.localNotificaitonService = localNotificationService
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
            localNotificaitonService.updateIsNotification(isNotification: isNotification)
            return nil
        case .setNotificationCompleted:
            // TODO: 何か処理する
            return nil
        }
    }
    
    func run(_ effect: SettingEffect) async -> SettingAction {
        switch effect {
        case .logout:
            service.logout()
            return .logoutCompleted
        case .setNotification(let date):
            await localNotificaitonService.setDinnerNotification(notificationAt: date)
            return .setNotificationCompleted
        }
    }
}
