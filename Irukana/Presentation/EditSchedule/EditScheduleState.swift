import Foundation

struct EditScheduleStatus: Equatable {
    var calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        return cal
    }()
    
    var title:String
    var isAllDay: Bool
    var startAt: Date
    var endAt: Date
    var notifyAt: ScheduleReminder?
    var color: ScheduleColor
    
    var users: [User]
    var selectedUserIds: Set<UUID> = []
    
    var isShowColor = false
    var isShowParticipant = false
    var isShowAlarm = false
}
