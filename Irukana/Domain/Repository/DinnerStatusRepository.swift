//
//  DinnerStatusRepository.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/29.
//

import Foundation

protocol DinnerStatusRepository {
    func upsertAnswer(groupId: UUID, date: Date, userId: UUID, answer: DinnerAnswer) async throws
    func fetch(groupId: UUID, date: Date) async throws -> DinnerStatus?
    func fetchMonth(groupId: UUID, anyDayInMonth: Date) async throws -> [DinnerStatus]
}
