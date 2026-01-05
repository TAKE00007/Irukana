import SwiftUI

private struct InjectedKey: EnvironmentKey {
    static let defaultValue: DIContainer = .init(
        authService: AuthService(repository: DummyAuthRepository()),
        dinnerService: DinnerStatusService(
            dinnerStatusRepository: DummyDinnerStatusRepository(),
            userRepository: DummyUserRepository()),
        scheduleService: ScheduleService(
            scheduleRepository: DummyScheduleRepository(),
            userRepository: DummyUserRepository(),
            scheduleParticipantRepository: DummyScheduleParticipantRepository()
        ),
        calendarService: CalendarService(calendarRepository: DummyCalendarRepository(), groupRepository: DummyGroupRepository())
    )
}

extension EnvironmentValues {
    var injected: DIContainer {
        get { self[InjectedKey.self] }
        set { self[InjectedKey.self] = newValue }
    }
}

struct DummyAuthRepository: AuthRepository {
    func login(name: String, password: String) async throws -> User {
        return User(id: UUID(), name: name, passwordHash: "dummy", birthday: nil)
    }
    
    func signUp(name: String, password: String, birthday: Date?) async throws -> User {
        return User(id: UUID(), name: name, passwordHash: "dummy", birthday: nil)
    }
}

struct DummyDinnerStatusRepository: DinnerStatusRepository {
    func upsertAnswer(groupId: UUID, date: Date, userId: UUID, answer: DinnerAnswer) async throws {
    
    }
    
    func fetch(groupId: UUID, date: Date) async throws -> DinnerStatus? {
        return nil
    }
    
    func fetchMonth(groupId: UUID, anyDayInMonth: Date) async throws -> [DinnerStatus] {
        return []
    }
    
    
}

struct DummyScheduleRepository: ScheduleRepository {
    func addSchedule(calendarId: UUID, title: String, startAt: Date, endAt: Date, notifyAt: Date?, color: ScheduleColor, isAllDay: Bool) async throws -> Schedule {
        return Schedule(id: UUID(), calendarId: UUID(), title: "", startAt: Date(), endAt: Date(), notifyAt: nil, color: .green, isAllDay: false, createdAt: Date())
    }
    
    func updateSchedule(id: UUID, calendarId: UUID, title: String, startAt: Date, endAt: Date, notifyAt: Date?, color: ScheduleColor, isAllDay: Bool) async throws -> Schedule {
        return Schedule(id: UUID(), calendarId: UUID(), title: "", startAt: Date(), endAt: Date(), notifyAt: nil, color: .green, isAllDay: false, createdAt: Date() )
    }
    
    func fetch(id: UUID) async throws -> Schedule? {
        return nil
    }
    
    func fetchRecentlyCreated(calendarId: UUID, createdAt: Date) async throws -> [Schedule]? {
        return nil
    }
    
    
    func fetchMonth(calendarId: UUID, anyDayInMonth: Date) async throws -> [Schedule] {
        return []
    }
    
    func deleteSchedule(id: UUID) async throws {
        
    }
}

struct DummyUserRepository: UserRepository {
    func fetchUser(id: UUID) async throws -> User? {
        return nil
    }
}

struct DummyScheduleParticipantRepository: ScheduleParticipantRepository {
    func addScheduleParticipant(scheduleId: UUID, userIds: [UUID]) async throws {
    }

    func fetchBySchedule(scheduleId: UUID) async throws -> [UUID] {
        return []
    }
    
    func fetchByUser(userId: UUID) async throws -> [UUID] {
        return []
    }
}

struct DummyCalendarRepository: CalendarRepository {
    func createCalendar(id: UUID, groupId: UUID, name: String) async throws -> CalendarInfo {
        return CalendarInfo(id: UUID(), groupId: UUID(), name: "")
    }
    
    func fetchCalendar(id: UUID) async throws -> CalendarInfo? {
        return nil
    }
}

struct DummyGroupRepository: GroupRepository {
    func addGroup(userId: UUID, groupId: UUID) async throws {
    }
}
