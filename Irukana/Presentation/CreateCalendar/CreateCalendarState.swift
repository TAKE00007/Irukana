import Foundation

struct CreateCalendarState: Equatable {
    var path: [CreateCalendarRoute] = []
    var calendarName: String = ""
    var calendarId: String = ""
    var calendarInfo: CalendarInfo?
}

enum CreateCalendarRoute: Hashable {
    case createNew
    case join
}
