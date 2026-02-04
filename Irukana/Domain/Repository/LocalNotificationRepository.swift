import Foundation

protocol LocalNotificationRepository {
    func initSetup() async
    func setDinnerNotification(notificationAt: Date) async
    func removeDinnerNotification()
    func setReminder(scheduleId: UUID, title: String, notificationAt: Date) async
}
