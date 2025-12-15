//
//  CalendarState.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/11/05.
//

import Foundation

struct CalendarState {
    var calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        return cal
    }()
    
    // カレンダーのロードする範囲
    let monthsBefore = 24
    let monthsAfter = 24
    var offsetRange: [Int] { Array(-monthsBefore...monthsAfter) }
    
    // カレンダーを表示するときにbaseになる
    var baseMonthStart: Date {
        let date = Date()
        let comps = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: comps)!
    }
    
    // カレンダーを表示し始める月
    var visibleMonthStart: Date? = nil
    
    
    var dinnerStatus: DinnerStatus? = nil
    var isLoading: Bool = false
    var errorMessage: String? = nil
}
