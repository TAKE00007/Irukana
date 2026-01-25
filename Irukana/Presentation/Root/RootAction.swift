import Foundation

enum RootAction {
    case onAppear
    
    case sessionResponse(Result<(User, CalendarInfo), AuthError>)
}

enum RootEffect {
    case restoreSession
}
