import Foundation

enum RootAction {
    case onAppear
    
    case sessionResponse(Result<User, AuthError>)
}

enum RootEffect {
    case restoreSession
}
