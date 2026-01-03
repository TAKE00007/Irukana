import Foundation

struct NotificationState {
    var dinnerStatus: DinnerStatus?
    var schedules: [(Schedule, [User])]

    var isLoading: Bool
    
    var dinnerStatusErrorMessage: String?
    var scheduleErrorMessage: String?
    
    init(
        dinnerStatus: DinnerStatus? = nil,
        schedules: [(Schedule, [User])] = [],
        isLoading: Bool = false,
        dinnerStatusErrorMessage: String? = nil,
        scheduleErrorMessage: String? = nil
    ) {
        self.dinnerStatus = dinnerStatus
        self.schedules = schedules
        self.isLoading = isLoading
        self.dinnerStatusErrorMessage = dinnerStatusErrorMessage
        self.scheduleErrorMessage = scheduleErrorMessage
    }
}
