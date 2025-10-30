//
//  NotificationReducer.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/30.
//

import Foundation

struct NotificationReducer {
    let service: UpsertDinnerStatutsService
    let groupId: UUID
    var now: () -> Date = { Date() }
    
    init(
        service: UpsertDinnerStatutsService,
        groupId: UUID,
        now: @escaping () -> Date = { Date() }
    ) {
        self.service = service
        self.groupId = groupId
        self.now = now
    }
    
    func reduce(state: inout NotificationState?, action: NotificationAction) -> NotificationEffect? {
        switch action {
        case .onAppear:
            return .load
        }
    }
    
    func run(_ effect: NotificationEffect) async throws -> DinnerStatus? {
        switch effect {
        case .load:
            return try await service.repository.fetch(groupId: groupId, date: now())  // TODO: serviceから取るように修正
        }
    }
    
    
}
