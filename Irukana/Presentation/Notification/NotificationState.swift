import Foundation

struct NotificationState {
    var dinnerStatus: DinnerStatus?
    var answers: [(name: String, answer: DinnerAnswer)]  = []
    var schedules: [(Schedule, [User])]

    var isLoading: Bool
    
    var dinnerStatusErrorMessage: String?
    var scheduleErrorMessage: String?
    
    init(
        dinnerStatus: DinnerStatus? = nil,
        answers: [(name: String, answer: DinnerAnswer)] = [],
        schedules: [(Schedule, [User])] = [],
        isLoading: Bool = false,
        dinnerStatusErrorMessage: String? = nil,
        scheduleErrorMessage: String? = nil
    ) {
        self.dinnerStatus = dinnerStatus
        self.schedules = schedules
        self.answers = answers
        self.isLoading = isLoading
        self.dinnerStatusErrorMessage = dinnerStatusErrorMessage
        self.scheduleErrorMessage = scheduleErrorMessage
    }
}
