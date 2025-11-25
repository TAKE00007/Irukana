//
//  LoginState.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/11/24.
//

import Foundation

struct AuthRootState {
    var name: String = ""
    var birthday: Date = Date()
    var password: String = ""
    
    var user: User? = nil
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    var isSignUp: Bool = false
    var isLogin: Bool = false
}



