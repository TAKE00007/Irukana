import Foundation

protocol LocalNotificationRepository {
    func initSetup() async
    func setDinnerNotification(notificationAt: Date) async
    func removeDinnerNotification()
}
