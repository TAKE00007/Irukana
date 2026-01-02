//
//  NotificationReducer.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/30.
//

import Foundation

struct NotificationReducer {
    let service: DinnerStatusService
    let groupId: UUID
    var now: () -> Date = { Date() }
    
    init(service: DinnerStatusService, groupId: UUID, now: @escaping () -> Date = { Date() }) {
        self.service = service
        self.groupId = groupId
        self.now = now
    }
    
    func reduce(state: inout NotificationState, action: NotificationAction) -> NotificationEffect? {
        switch action {
        case .onAppear:
            state.isLoading = true
            state.errorMessage = nil
            return .loadDinnerStatus
        case let .dinnerStatusResponse(result):
            state.isLoading = false
            switch result {
            case .success(let dinnerStatus):
                state.dinnerStatus = dinnerStatus
                state.errorMessage = nil
                return nil
            case .failure(let error):
                state.errorMessage = error.errorDescription
                return nil
            }
        }
    }
    
    func run(_ effect: NotificationEffect) async -> NotificationAction {
        switch effect {
        case .loadDinnerStatus:
            do {
                guard
                    let dinnerStatus = try await service.loadDinnerStatus(groupId: groupId, date: now())
                else
                    { return .dinnerStatusResponse(.failure(DinnerStatusError.faileLoadDinnerStatus)) }
                
                return .dinnerStatusResponse(.success(dinnerStatus))
            } catch {
                return .dinnerStatusResponse(.failure(DinnerStatusError.faileLoadDinnerStatus))
            }
        }
    }
    
    
}
