import Foundation

struct DIContainer {
    let authService: AuthService
    let dinnerService: DinnerStatusService
    let scheduleService: ScheduleService
    let calendarService: CalendarService
    let localNotificationService: LocalNotificationService
}
