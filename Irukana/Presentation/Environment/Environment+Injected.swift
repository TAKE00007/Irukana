//
//  Environment+Injected.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/11/24.
//

import SwiftUI

private struct InjectedKey: EnvironmentKey {
    static let defaultValue: DIContainer = .init(
        authService: AuthService(repository: DummyAuthRepository()),
        dinnerService: DinnerStatusService(repository: DummyDinnerStatusRepository())
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
