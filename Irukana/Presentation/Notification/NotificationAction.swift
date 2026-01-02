//
//  NotificationAction.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/30.
//

import Foundation

enum NotificationAction {
    case onAppear
    
    case dinnerStatusResponse(Result<DinnerStatus, DinnerStatusError>)
}

enum NotificationEffect {
    case loadDinnerStatus
}
