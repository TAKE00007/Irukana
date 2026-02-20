import Foundation

enum AuthError: Error {
    case userNotFound
    case invalidPassword
    case invalidUserData
    case nameAlreadyExist
    case userIdNotFound
    case failLogin
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
        case .userIdNotFound:
            return "userIdがuserDefaultに保存されていません"
        case .failLogin:
            return "ユーザー名かパスワードが間違っています"
        }
    }
}
