import Foundation

enum NotificationAction {
    case onAppear
    
    case initialResponse(
        dinner: Result<DinnerStatus, DinnerStatusError>,
        schedule: Result<[Schedule], ScheduleError>
    )
}

enum NotificationEffect {
    case loadInitial
}
