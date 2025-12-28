//
//  AddAction.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/27.
//

import Foundation

enum AddAction {
    case tapDinnerYes
    case tapDinnerNo
    
    // 予定追加
    case setTitle(String)
    case setAllDay(Bool)
    case setStartAt(Date)
    case setEndAt(Date)
    case setNotifyAt(ScheduleReminder)
    case setColor(ScheduleColor)
    
    case tapSave
    
    case dinnerStatusResponse(Result<Bool, DinnerStatusError>)
    case saveResponse(Result<Schedule, ScheduleError>)
}

enum AddEffect {
    case upsert(isYes: Bool)
    case saveSchedule(calendarId: UUID, title: String, startAt: Date, endAt: Date, notifyAt: ScheduleReminder?, color: ScheduleColor, isAllDay: Bool)
}
