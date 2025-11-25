//
//  LoginReducer.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/11/24.
//

import Foundation

struct LoginReducer {
    let service: AuthService
    
    init(service: AuthService) {
        self.service = service
    }
    
    func reduce(state: inout LoginState, action: LoginAction) -> LoginEffect? {
        switch action {
        case .tapSignUp:
            state.isLoading = true
            return .signUp(name: state.name, password: state.password, birthday: state.birthday)
        case .tapLogin:
            state.isLoading = true
            return .login(name: state.name, password: state.password)
        case let .signUpResponse(.success(user)):
            state.isLoading = false
            state.user = user
            return nil
        case let .signUpResponse(.failure(error)):
            state.isLoading = false
            state.errorMessage = error.localizedDescription
            return nil
        case let .loginResponse(.success(user)):
            state.isLoading = false
            state.user = user
            return nil
        case let .loginResponse(.failure(error)):
            state.isLoading = false
            state.errorMessage = error.localizedDescription
            return nil
        case .tapSignUpButton:
            state.isSignUp = true
            return nil
        case .tapLoginButton:
            state.isLogin = true
            return nil
        case .dismissSignUp:
            state.isSignUp = false
            return nil
        case .dismissLoginButton:
            state.isLogin = false
            return nil
        }
    }
    
    func run(_ effect: LoginEffect) async -> LoginAction {
        switch effect {
        case let .signUp(name, password, birthday):
            do {
                let user = try await service.signUp(name: name, password: password, birthday: birthday)
                return .signUpResponse(.success(user))
            } catch {
                return .signUpResponse(.failure(error))
            }
        case let .login(name, password):
            do {
                let user = try await service.login(name: name, password: password)
                return .loginResponse(.success(user))
            } catch {
                return .loginResponse(.failure(error))
            }
        }
    }
}
