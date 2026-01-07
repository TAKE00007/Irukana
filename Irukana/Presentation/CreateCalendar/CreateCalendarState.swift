import Foundation

struct CreateCalendarState: Equatable {
    var path: [CreateCalendarRoute] = []
    var calendarName: String = ""
    var calendarId: String = ""
    var calendarInfo: CalendarInfo?
    var errorMessage: String? = nil
}

enum CreateCalendarRoute: Hashable {
    case createNew
    case join
}
