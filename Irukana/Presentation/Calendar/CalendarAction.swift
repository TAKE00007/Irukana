import Foundation

enum CalendarAction {
    case onAppear
    case initialResponse(
        dinner: Result<([DinnerStatus], [User]), DinnerStatusError>,
        schedule: Result<[(Schedule, [User])], ScheduleError>
    )
    case tapCopy
}

enum CalendarEffect {
    case load(visibleMonthStart: Date)
}
