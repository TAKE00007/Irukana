//
//  CreateCalendarState.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/16.
//

import Foundation

struct CreateCalendarState: Equatable {
    var path: [CreateCalendarRoute] = []
}

enum CreateCalendarRoute: Hashable {
    case createNew
    case join
}
