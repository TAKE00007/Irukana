import Foundation

struct NotificationState: Equatable {
    var dinnerStatus: DinnerStatus?
    
    var isLoading: Bool
    
    var errorMessage: String?
    
    init(
        dinnerStatus: DinnerStatus? = nil,
        isLoading: Bool = false,
        errorMessage: String? = nil
    ) {
        self.dinnerStatus = dinnerStatus
        self.isLoading = isLoading
        self.errorMessage = errorMessage
    }
}
