//
//  LoginAction.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/11/24.
//

import Foundation

enum LoginAction {
    case tapSignUpButton
    case tapLoginButton
    case dismissSignUp
    case dismissLoginButton
    
    case tapSignUp
    case tapLogin
    case signUpResponse(Result<User, Error>)
    case loginResponse(Result<User, Error>)
}

enum LoginEffect {
    case signUp(name: String, password: String, birthday: Date)
    case login(name: String, password: String)
}
