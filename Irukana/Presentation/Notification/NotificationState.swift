import Foundation

struct NotificationState: Equatable {
    var dinnerStatus: DinnerStatus?
    var schedules: [Schedule]
    
    var isLoading: Bool
    
    var dinnerStatusErrorMessage: String?
    var scheduleErrorMessage: String?
    
    init(
        dinnerStatus: DinnerStatus? = nil,
        schedules: [Schedule] = [],
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
