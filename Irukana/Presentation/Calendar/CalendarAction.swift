import Foundation

enum CalendarAction {
    case onAppear
    case initialResponse(
        dinner: Result<[DinnerStatus], DinnerStatusError>,
        schedule: Result<[Schedule], ScheduleError>
    )
    case tapCopy
}

enum CalendarEffect {
    case load(visibleMonthStart: Date)
}
