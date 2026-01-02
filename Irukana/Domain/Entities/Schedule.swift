//
//  Schedule.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/11.
//

import Foundation

struct Schedule: Identifiable, Codable, Equatable {
    let id: UUID
    let calendarId: UUID
    var title: String
    var startAt: Date
    var endAt: Date
    var notifyAt: Date?
    var color: ScheduleColor
    var isAllDay: Bool
    var createdAt: Date
    
    init(id: UUID, calendarId: UUID, title: String, startAt: Date, endAt: Date, notifyAt: Date?, color: ScheduleColor, isAllDay: Bool, createdAt: Date) {
        self.id = id
        self.calendarId = calendarId
        self.title = title
        self.startAt = startAt
        self.endAt = endAt
        self.notifyAt = notifyAt
        self.color = color
        self.isAllDay = isAllDay
        self.createdAt = createdAt
    }
}
