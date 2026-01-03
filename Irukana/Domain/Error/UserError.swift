import Foundation

enum UserError: Error {
    case userNotFound
}

extension UserError {
    var errorDesctiption: String? {
        switch self {
        case .userNotFound:
            return "ユーザーが存在しません"
        }
    }
}
