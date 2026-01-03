//
//  ScheduleParticipant.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/11.
//

import Foundation

struct ScheduleParticipant: Codable {
    let scheduleId: UUID
    let userId: UUID
    
    init(scheduleId: UUID, userId: UUID) {
        self.scheduleId = scheduleId
        self.userId = userId
    }
}
