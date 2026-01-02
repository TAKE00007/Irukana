import Foundation

enum DinnerStatusError: Error {
    case failDinnerStatus
    case faileLoadDinnerStatus
}

extension DinnerStatusError {
    var errorDescription: String? {
        switch self {
        case .failDinnerStatus:
            return "dinnerStatusの登録に失敗しました"
        case .faileLoadDinnerStatus:
            return "dinnerStatusの取得に失敗しました"
        }
    }
}
