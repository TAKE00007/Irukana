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
    
    init(shceduleId: UUID, userId: UUID) {
        self.scheduleId = shceduleId
        self.userId = userId
    }
}
