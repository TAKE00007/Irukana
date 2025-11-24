//
//  AuthError.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/11/24.
//

import Foundation

enum AuthError: Error {
    case userNotFound
    case invalidPassword
    case invalidUserData
    case nameAlreadyExist
}

extension AuthError {
    var errorDesctiption: String? {
        switch self {
        case .userNotFound:
            return "ユーザーが存在しません"
        case .invalidPassword:
            return "パスワードが一致しません"
        case .invalidUserData:
            return "ユーザーデータが不正です"
        case .nameAlreadyExist:
            return "同じ名前のユーザーが存在しています"
        }
    }
}
