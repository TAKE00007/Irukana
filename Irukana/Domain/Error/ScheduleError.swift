import Foundation

enum ScheduleError: Error {
    case scheduleNotFound
}

extension ScheduleError {
    var errorDescription: String? {
        switch self {
        case .scheduleNotFound:
            return "予定が見つかりません"
        }
    }
}
