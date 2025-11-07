//
//  CalendarReducer.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/11/05.
//

import Foundation

struct CalendarReducer {
    let service: DinnerStatusService
    let groupId: UUID
    var now: () -> Date = { Date() }
    
    init(service: DinnerStatusService, groupId: UUID, now: @escaping () -> Date) {
        self.service = service
        self.groupId = groupId
        self.now = now
    }
    
    func reduce(state: inout CalendarState?, action: CalendarAction) -> CalendarEffect? {
        switch action {
        case .onAppear:
            return .load
        }
    }
    
    func run(_ effect: CalendarEffect) async throws -> DinnerStatus? {
        switch effect {
        case .load:
            return try await service.loadDinnerStatus(groupId: groupId, date: now())
        }
    }
}
