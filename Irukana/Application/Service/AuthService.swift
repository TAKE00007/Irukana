import Foundation

struct AuthService {
    let authRepository: AuthRepository
    let sessionRepository: SessionRepository
    let userRepository: UserRepository
    let groupRepository: GroupRepository
    let calendarRepository: CalendarRepository
    
    func login(name: String, password: String) async throws -> User {
        let user = try await authRepository.login(name: name, password: password)
        return user
    }
    
    func signUp(name: String, password: String, birthday: Date?) async throws -> User {
        let user = try await authRepository.signUp(name: name, password: password, birthday: birthday)
        sessionRepository.saveUserId(user.id.uuidString)
        return user
    }
    
    func autoLogin() async throws -> (User, [CalendarInfo])? {
        guard let userId = sessionRepository.loadUserId() else { return nil }
        guard let uuid = UUID(uuidString: userId) else { return nil }
        guard let user =  try await userRepository.fetchUser(id: uuid) else { return nil }
        let groupIds =  try await groupRepository.fetchGroupIds(userId: uuid) // 今は1個しか返ってこない
        var calendarInfos: [CalendarInfo] = []
        for groupId in groupIds {
            guard let calendrInfo = try await calendarRepository.fetchCalendarByGroupId(groupId: groupId) else { continue }
            calendarInfos.append(calendrInfo)
        }

        return (user, calendarInfos)
    }
}
