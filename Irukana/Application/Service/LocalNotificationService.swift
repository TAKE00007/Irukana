import Foundation

struct LocalNotificationService {
    let localNotificationRepository: LocalNotificationRepository
    let sessionRepository: SessionRepository
    
    func updateIsNotification(isNotification: Bool) {
        if !isNotification {
            localNotificationRepository.removeDinnerNotification()
        }

        sessionRepository.saveIsNotification(isNotification)
    }
    
    func loadIsNotification() -> Bool? {
        return sessionRepository.loadIsNotification()
    }
    
    func setDinnerNotification(notificationAt: Date) async {
        await localNotificationRepository.setDinnerNotification(notificationAt: notificationAt)
    }
    
    func setReminder(scheduleId: UUID, title: String, notificationAt: Date) async {
        await localNotificationRepository.setReminder(scheduleId: scheduleId, title: title, notificationAt: notificationAt)
    }
    
    func removeDinnerNotification() {
        localNotificationRepository.removeDinnerNotification()
    }
}
