import Foundation

enum GroupError: Error {
    case userInGroupNotFound
}

extension GroupError {
    var errorDesctiption: String? {
        switch self {
        case .userInGroupNotFound:
            return "そのグループのユーザーが存在しません"
        }
    }
}
