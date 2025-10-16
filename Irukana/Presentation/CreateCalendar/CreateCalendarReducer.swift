//
//  CreateCalendarReducer.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/16.
//

import Foundation

struct CreateCalendarReducer {
    
    func reduce(state: inout CreateCalendarState, action: CreateCalendarAction) {
        switch action {
        case .tapCreateCalendar:
            //TODO: 画面遷移の処理をかく
            print("本当はCalendarPageに移動する")
            state.path.append(.createNew)
        case .tapJoinCalendar:
            //TODO: 画面遷移の処理をかく
            print("本当は共有CalendarPageに移動する")
            state.path.append(.join)
        }
    }
}
