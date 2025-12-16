//
//  UpsertDinnerStatutsService.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/29.
//

import Foundation

struct DinnerStatusService {
    let repository: DinnerStatusRepository
    
    func upsertDinnerStatus(groupId: UUID, date: Date, userId: UUID, isYes: Bool) async throws {
        let answer: DinnerAnswer = isYes ? .need : .noneed
        try await repository.upsertAnswer(groupId: groupId, date: date, userId: userId, answer: answer)
    }
    
    func loadDinnerStatus(groupId: UUID, date: Date) async throws -> DinnerStatus? {
        return try await repository.fetch(groupId: groupId, date: date)
    }
    
    func loadDinnerStatusMonth(groupId: UUID, date: Date) async throws -> [DinnerStatus]? {
        return try await repository.fetchMonth(groupId: groupId, anyDayInMonth: date)
    }
}
