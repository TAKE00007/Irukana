import Foundation

struct SettingReducer {
    let groupId: UUID
    let service: AuthService
    let localNotificaitonService: LocalNotificationService
    let groupService: GroupService
    
    init(
        groupId: UUID,
        service: AuthService,
        localNotificationService: LocalNotificationService,
        groupService: GroupService
    ) {
        self.groupId = groupId
        self.service = service
        self.localNotificaitonService = localNotificationService
        self.groupService = groupService
    }
    
    @discardableResult
    func reduce(state: inout SettingState, action: SettingAction) -> SettingEffect? {
        switch action {
        case .onAppear:
            return .loadUsers
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
            return .loadUsers
        case .userResponse(let result):
            switch result {
            case .success(let users):
                state.users = users
                return nil
            case .failure(_):
                return nil
            }
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
        case .loadUsers:
            do {
                let users = try await groupService.feetchUsers(groupId: groupId)
                guard !users.isEmpty else { return .userResponse(.failure(UserError.userNotFound))}
                return .userResponse(.success(users))
            } catch {
                return .userResponse(.failure(UserError.userNotFound))
            }
        }
    }
}
