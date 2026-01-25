import Foundation

struct RootReducer {
    let service: AuthService
    
    init(service: AuthService) {
        self.service = service
    }
    
    func reduce(state: inout RootState, action: RootAction) -> RootEffect? {
        switch action {
        case .onAppear:
            state = .loading
            return .restoreSession
        case .sessionResponse(let result):
            switch result {
            case let .success((user, calendarInfo)):
                state = .loggedIn(user, calendarInfo)
                return nil
            case .failure(_):
                state = .loggedOut
                return nil
            }
        }
    }
    
    func run(_ effect: RootEffect) async -> RootAction {
        switch effect {
        case .restoreSession:
            do {
                guard let (user, calendarInfos) = try await service.autoLogin()
                else { return .sessionResponse(.failure(AuthError.userIdNotFound)) }

                guard let calendarInfo = calendarInfos.first
                else { return .sessionResponse(.failure(AuthError.userNotFound)) }
                
                return .sessionResponse(.success((user, calendarInfo) ))
            } catch {
                return .sessionResponse(.failure(AuthError.userIdNotFound))
            }
        }
    }
}
