//
//  NotificationStatus.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/30.
//

import Foundation

enum NotificationState {
    case loaded(DinnerStatus)
    case failed(String)
}
