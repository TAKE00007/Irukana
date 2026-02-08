import Foundation
import UserNotifications

struct LocalNotificationRepositoryImp: LocalNotificationRepository {
    private enum AuthorizationPolicy {
        case firstTimeOnly
        case requiresAuthorization
        case requestIfNeeded
    }

    private enum NotificationConfig {
        static let dinnerIdentifier = "dinner.reminder.daily"
        static let scheduleIdentifierPrefix = "schedule.reminder."
        static let dinnerRoute = "dinner"
        static let calendarRoute = "calendar"
        static let title = "確認"
        static let dinnerBody = "今日のご飯、どうしますか？"
    }

    // 初めて通知設定をする時に使う
    func initSetup() async {
        let center = UNUserNotificationCenter.current()
        guard await canScheduleNotification(with: .firstTimeOnly, center: center) else { return }
        
        var components = DateComponents()
        components.hour = 16
        components.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let content = makeNotificationContent(
            title: NotificationConfig.title,
            body: NotificationConfig.dinnerBody,
            route: NotificationConfig.dinnerRoute
        )

        await addNotificationRequest(
            center: center,
            identifier: NotificationConfig.dinnerIdentifier,
            content: content,
            trigger: trigger
        )
    }
    
    func setDinnerNotification(notificationAt: Date) async {
        let center = UNUserNotificationCenter.current()
        guard await canScheduleNotification(with: .requiresAuthorization, center: center) else { return }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: notificationAt)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let content = makeNotificationContent(
            title: NotificationConfig.title,
            body: NotificationConfig.dinnerBody,
            route: NotificationConfig.dinnerRoute
        )

        await addNotificationRequest(
            center: center,
            identifier: NotificationConfig.dinnerIdentifier,
            content: content,
            trigger: trigger
        )
    }
    
    func removeDinnerNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(
            withIdentifiers: [NotificationConfig.dinnerIdentifier]
        )
    }

    func setReminder(scheduleId: UUID, title: String, notificationAt: Date) async {
        let center = UNUserNotificationCenter.current()
        guard await canScheduleNotification(with: .requestIfNeeded, center: center) else { return }
        
        guard notificationAt > Date() else { return }

        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: notificationAt)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let content = makeNotificationContent(
            title: title,
            body: "",
            route: NotificationConfig.calendarRoute
        )

        await addNotificationRequest(
            center: center,
            identifier: "\(NotificationConfig.scheduleIdentifierPrefix)\(scheduleId.uuidString)",
            content: content,
            trigger: trigger
        )
    }

    func removeReminder(scheduleId: UUID) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(
            withIdentifiers: ["\(NotificationConfig.scheduleIdentifierPrefix)\(scheduleId.uuidString)"]
        )
    }
    
    
    private func canScheduleNotification(
        with policy: AuthorizationPolicy,
        center: UNUserNotificationCenter
    ) async -> Bool {
        let status = await checkAuthorizationStatus(center: center)

        switch policy {
        case .firstTimeOnly:
            guard status == .notDetermined else { return false }
            return await requestAuthorizationIfNeeded(center: center)
        case .requiresAuthorization:
            switch status {
            case .notDetermined:
                return await requestAuthorizationIfNeeded(center: center)
            case .authorized, .provisional, .ephemeral:
                return true
            case .denied:
                print("通知が拒否されています")
                return false
            @unknown default:
                return false
            }
        case .requestIfNeeded:
            if status == .notDetermined {
                return await requestAuthorizationIfNeeded(center: center)
            }
            return true
        }
    }

    private func requestAuthorizationIfNeeded(center: UNUserNotificationCenter) async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }

    private func makeNotificationContent(title: String, body: String, route: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = ["route": route]
        return content
    }

    private func addNotificationRequest(
        center: UNUserNotificationCenter,
        identifier: String,
        content: UNMutableNotificationContent,
        trigger: UNCalendarNotificationTrigger
    ) async {
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )

        do {
            try await center.add(request)
        } catch {
            print("通知データを作れなかった")
        }
    }

    private func checkAuthorizationStatus(center: UNUserNotificationCenter) async -> UNAuthorizationStatus {
        let setting = await center.notificationSettings()
        return setting.authorizationStatus
    }
}
