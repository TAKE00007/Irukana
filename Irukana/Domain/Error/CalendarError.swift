import Foundation

enum CalendarError: Error {
    case calendarNotFound
    case failCreateCalendar
}

extension CalendarError {
    var errorDesctiption: String? {
        switch self {
        case .calendarNotFound:
            return "カレンダーが見つかりません"
        case .failCreateCalendar:
            return "カレンダー作成に失敗しました"
        }
    }
}
