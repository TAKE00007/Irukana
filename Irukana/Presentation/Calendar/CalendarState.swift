//
//  CalendarState.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/11/05.
//

import Foundation

struct CalendarState {
    var dinnerStatus: DinnerStatus? = nil
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var visibleMonthStart: Date? = nil
    var calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        return cal
    }()
    var baseMonthStart: Date {
        let date = Date()
        let comps = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: comps)!
    }
    let monthsBefore = 24
    let monthsAfter = 24
    var offsetRange: [Int] { Array(-monthsBefore...monthsAfter) }
}
