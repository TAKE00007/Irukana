import Foundation
enum RootState {
    case loading
    case loggedOut
    case loggedIn(User, CalendarInfo)
    case createCalendar(User)
}
