//
//  AuthRepository.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/11/23.
//

import Foundation

protocol AuthRepository {
    func login(name: String, password: String) async throws -> User
    func signUp(name: String, password: String, birthday: Date?) async throws -> User
}
