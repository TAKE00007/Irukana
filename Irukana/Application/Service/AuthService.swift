//
//  UserService.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/11/24.
//

import Foundation

struct AuthService {
    let repository: AuthRepository
    
    func login(name: String, password: String) async throws -> User? {
        let user = try await repository.login(name: name, password: password)
        return user
    }
    
    func signUp(name: String, password: String, birthday: Date?) async throws -> User? {
        let user = try await repository.signUp(name: name, password: password, birthday: birthday)
        return user
    }
}
