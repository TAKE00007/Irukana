import Foundation

enum CalendarAction {
    case onAppear
    case initialResponse(
        dinner: Result<[DinnerStatus], DinnerStatusError>,
        schedule: Result<[Schedule], ScheduleError>
    )
}

enum CalendarEffect {
    case load(visibleMonthStart: Date)
}
