import Foundation

struct SettingReducer {
    func reduce(state: inout SettingState, action: SettingAction) {
        switch action {
        case .tapLoggedOut:
            break
        case .setNotificationTime(let notifyAt):
            state.notificationTime = notifyAt
        case .setIsNotification(let isNotification):
            state.isNotification = isNotification
        }
    }
}
