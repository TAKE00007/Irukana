//
//  CalendarAction.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/11/05.
//

import Foundation

enum CalendarAction {
    case onAppear
    case dinnerStatusResponse(Result<[DinnerStatus], Error>)
}

enum CalendarEffect {
    case load(visibleMonthStart: Date)
}
