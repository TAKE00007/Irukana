import Foundation

enum ScheduleReminder: String, CaseIterable, Identifiable {
    case start
    case beforeTenMinute
    case beforeHour
    
    public var id: String { rawValue }
    
    public var name: String {
        switch self {
        case .start:
            return "開始時"
        case .beforeTenMinute:
            return "10分前"
        case .beforeHour:
            return "1時間前"
        }
    }
    
    public var description: String {
        switch self {
        case .start:
            return "開始時に通知が届きます。"
        case .beforeTenMinute:
            return "10分前に通知が届きます。"
        case .beforeHour:
            return "1時間前に通知が届きます。"
        }
    }
    
    public func reminderDate(startAt: Date, calendar: Calendar = .current) -> Date? {
        switch self {
        case .start:
            return startAt
        case .beforeTenMinute:
            return calendar.date(byAdding: .minute, value: -10, to: startAt)
        case .beforeHour:
            return calendar.date(byAdding: .hour, value: -1, to: startAt)
        }
    }
}
