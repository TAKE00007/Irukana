import Foundation
import UserNotifications

struct AuthRootReducer {
    let service: AuthService
    
    init(service: AuthService) {
        self.service = service
    }
    
    func reduce(state: inout AuthRootState, action: AuthRootAction) -> AuthRootEffect? {
        switch action {
        case .tapSignUp:
            state.isLoading = true
            return .signUp(name: state.name, password: state.password, birthday: state.birthday)
        case .tapLogin:
            state.isLoading = true
            state.loginSucceeded = false
            return .login(name: state.name, password: state.password)
        case let .signUpResponse(.success(user)):
            state.isLoading = false
            state.user = user
            return nil
        case let .signUpResponse(.failure(error)):
            state.isLoading = false
            state.alertContent = AlertContent(title: "エラー", message: error.errorDesctiption)
            return nil
        case let .loginResponse(.success(user)):
            state.isLoading = false
            state.user = user
            state.loginSucceeded = true
            return nil
        case let .loginResponse(.failure(error)):
            state.isLoading = false
            state.alertContent = AlertContent(title: "エラー", message: error.errorDesctiption)
            state.loginSucceeded = false
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
    
    func run(_ effect: AuthRootEffect) async -> AuthRootAction {
        switch effect {
        case let .signUp(name, password, birthday):
            do {
                let user = try await service.signUp(name: name, password: password, birthday: birthday)
                return .signUpResponse(.success(user))
            } catch AuthError.nameAlreadyExist {
                return .signUpResponse(.failure(.nameAlreadyExist))
            } catch {
                return .signUpResponse(.failure(.failSignUp))
            }
        case let .login(name, password):
            do {
                let user = try await service.login(name: name, password: password)
                return .loginResponse(.success(user))
            } catch {
                return .loginResponse(.failure(AuthError.failLogin))
            }
        }
    }
}
