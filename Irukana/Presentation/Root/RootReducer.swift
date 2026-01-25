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
            case .success(let user):
                state = .createCalendar(user)
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
                guard let user = try await service.restoreSession()
                else { return .sessionResponse(.failure(AuthError.userIdNotFound)) }
                // TODO: CalendarInfoも取得できるようにする
                return .sessionResponse(.success(user))
            } catch {
                return .sessionResponse(.failure(AuthError.userIdNotFound))
            }
        }
    }
}
