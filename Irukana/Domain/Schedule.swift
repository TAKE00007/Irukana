//
//  Schedule.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/11.
//

import Foundation

struct Schedule {
    let id: UUID
    let calendarId: UUID
    var title: String
    var startAt: Date
    var endAt: Date
    var notifyAt: Date?
    var color: String // TODO: あとでColor型を定義する
    
    init(id: UUID, calendarId: UUID, title: String, startAt: Date, endAt: Date, notifyAt: Date?, color: String) {
        self.id = id
        self.calendarId = calendarId
        self.title = title
        self.startAt = startAt
        self.endAt = endAt
        self.notifyAt = notifyAt
        self.color = color
    }
}
