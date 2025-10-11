//
//  ScheduleParticipant.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/11.
//

import Foundation

struct ScheduleParticipant {
    let shceduleId: UUID
    let userId: UUID
    
    init(shceduleId: UUID, userId: UUID) {
        self.shceduleId = shceduleId
        self.userId = userId
    }
}
