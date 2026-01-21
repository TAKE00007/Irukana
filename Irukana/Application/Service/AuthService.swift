import Foundation

struct AuthService {
    let authRepository: AuthRepository
    let sessionRepository: SessionRepository
    let userRepository: UserRepository
    
    func login(name: String, password: String) async throws -> User {
        let user = try await authRepository.login(name: name, password: password)
        return user
    }
    
    func signUp(name: String, password: String, birthday: Date?) async throws -> User {
        let user = try await authRepository.signUp(name: name, password: password, birthday: birthday)
        sessionRepository.saveUserId(user.id.uuidString)
        return user
    }
    
    func restoreSession() async throws -> User? {
        guard let userId = sessionRepository.loadUserId() else { return nil }
        guard let uuid = UUID(uuidString: userId) else { return nil }
        let user =  try await userRepository.fetchUser(id: uuid)
        return user
    }
}
