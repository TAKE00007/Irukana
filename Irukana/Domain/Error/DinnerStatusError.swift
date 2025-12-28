import Foundation

enum DinnerStatusError: Error {
    case failDinnerStatus
}

extension DinnerStatusError {
    var errorDescription: String? {
        switch self {
        case .failDinnerStatus:
            return "dinnerStatusの登録に失敗しました"
        }
    }
}
