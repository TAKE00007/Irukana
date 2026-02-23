import Foundation

enum AuthRootAction {
    case tapSignUpButton
    case tapLoginButton
    case dismissSignUp
    case dismissLoginButton
    
    case tapSignUp
    case tapLogin
    case signUpResponse(Result<User, AuthError>)
    case loginResponse(Result<User, AuthError>)
}

enum AuthRootEffect {
    case signUp(name: String, password: String, birthday: Date)
    case login(name: String, password: String)
}
