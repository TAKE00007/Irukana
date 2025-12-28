//
//  AddState.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/27.
//

import Foundation

struct AddState: Equatable {
    var calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        return cal
    }()
    
    var isDinner: Bool
    var scheduleForm = ScheduleForm()
    var isEdited = false // カレンダーの終了時刻自動で1時間後にする ユーザーが終了時刻を調整した場合、falseになる
    var didInitScheduleForm = false
    
    var alert: AlertState? = nil
}


struct ScheduleForm: Equatable {
    var title = ""
    var isAllDay = false
    var startAt = Date()
    var endAt = Date()
    var notifyAt: ScheduleReminder? = .start
    var color: ScheduleColor = .green
}

struct AlertState: Equatable, Identifiable {
    let id = UUID()
    var title: String
    var message: String?
}
