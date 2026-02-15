import Foundation

struct SettingReducer {
    let groupId: UUID
    let service: AuthService
    let localNotificaitonService: LocalNotificationService
    let groupService: GroupService
    
    init(
        service: AuthService,
        localNotificationService: LocalNotificationService,
        groupService: GroupService
    ) {
        self.service = service
        self.localNotificaitonService = localNotificationService
        self.groupService = groupService
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
        case .deleteUser(let user):
            return .deleteUser(user)
        case .deleteCompleted:
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
        case .deleteUser(let user):
            do {
                try await groupService.deleteUserInGroup(userId: user.id, groupId: groupId)
                return .deleteCompleted
            }  catch {
                print(error.localizedDescription)
                return .deleteCompleted //TODO: エラー時の処理はいつか考える
            }
        }
    }
}
