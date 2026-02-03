import Foundation
import UserNotifications

struct LocalNotificationRepositoryImp: LocalNotificationRepository {
    // 初めて通知設定をする時に使う
    func initSetup() async {
        let center = UNUserNotificationCenter.current()
        let status = await checkAuthorizationStatus(center: center)
        
        switch status {
        case .notDetermined:
            do {
                let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
                guard granted else { return }
            } catch {
                return
            }
        default:
            return
        }
        
        var components = DateComponents()
        components.hour = 16
        components.minute = 0
        
        let content = UNMutableNotificationContent()
        content.title = "確認"
        content.body = "今日のご飯、どうしますか？"
        content.sound = .default
        
        content.userInfo = [
            "route": "dinner"
        ]
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "dinner.reminder.daily",
            content: content,
            trigger: trigger
        )
        
        do {
            try await center.add(request)
        } catch {
            print("通知データを作れなかった")
        }
    }
    
    // TODO: 処理が重複しているので後で直す
    func setDinnerNotification(notificationAt: Date) async {
        let center = UNUserNotificationCenter.current()
        let status = await checkAuthorizationStatus(center: center)
        
        switch status {
        case .notDetermined:
            do {
                let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
                guard granted else { return }
            } catch {
                return
            }
        default:
            return
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: notificationAt)
        
        let content = UNMutableNotificationContent()
        content.title = "確認"
        content.body = "今日のご飯、どうしますか？"
        content.sound = .default
        
        content.userInfo = [
            "route": "dinner"
        ]
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "dinner.reminder.daily",
            content: content,
            trigger: trigger
        )
        
        do {
            try await center.add(request)
        } catch {
            print("通知データを作れなかった")
        }
    }
    
    func removeDinnerNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(
            withIdentifiers: ["dinner.reminder.daily"]
        )
    }
    
    private func checkAuthorizationStatus(center: UNUserNotificationCenter) async -> UNAuthorizationStatus {
        let setting = await center.notificationSettings()
        
        return setting.authorizationStatus
    }
}
