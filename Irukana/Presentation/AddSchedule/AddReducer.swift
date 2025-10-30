//
//  AddReducer.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/27.
//

import Foundation

struct AddReducer {
    let service: DinnerStatusService
    let groupId: UUID
    let userId: UUID
    var now: () -> Date = { Date() }
    
    init(
         service: DinnerStatusService,
         groupId: UUID,
         userId: UUID,
         now: @escaping () -> Date = { Date() }
    ) {
        self.service = service
        self.groupId = groupId
        self.userId = userId
        self.now = now
    }
    
    func reduce(state: inout AddState, action: AddAction) -> AddEffect? {
        switch action {
        case .tapDinnerYes:
            state.isDinner = true
            return .upsert(isYes: true)
            
        case .tapDinnerNo:
            state.isDinner = false
            return .upsert(isYes: false)
        }
    }
    
    func run(_ effect: AddEffect) async throws {
        switch effect {
        case let .upsert(isYes):
            try await service.upsertDinnerStatus(
                groupId: groupId,
                date: now(),
                userId: userId,
                isYes: isYes
            )
        }
    }
}
