import Foundation

enum ScheduleError: Error {
    case scheduleNotFound
    case failAddSchedule
    case failLoadSchedule
}

extension ScheduleError {
    var errorDescription: String? {
        switch self {
        case .scheduleNotFound:
            return "予定が見つかりません"
        case .failAddSchedule:
            return "予定登録に失敗しました"
        case .failLoadSchedule:
            return "予定取得を失敗しました"
        }
    }
}
