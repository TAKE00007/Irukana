import Foundation
 
enum CreateCalendarAction {
    case tapCreateCalendar
    case tapJoinCalendar
    
    case setCalendarName(String)
    case setCalendarId(String)
    
    case createCalendar
    case joinCalendar
    
    case createCalendarResponse(Result<CalendarInfo, CalendarError>)
    case joinCalendarResponse(Result<CalendarInfo, CalendarError>)
}

enum CreateCalendarEffect {
    case createCalendar(calendarName: String)
    case joinCalendar(calendarId: String)
}
