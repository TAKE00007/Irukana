import Foundation

enum NotificationAction {
    case onAppear
    
    case initialResponse(
        dinner: Result<(DinnerStatus, [User]), DinnerStatusError>,
        schedule: Result<[(Schedule, [User])], ScheduleError>
    )
}

enum NotificationEffect {
    case loadInitial
}
