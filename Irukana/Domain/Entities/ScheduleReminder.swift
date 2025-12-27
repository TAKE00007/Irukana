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
}
