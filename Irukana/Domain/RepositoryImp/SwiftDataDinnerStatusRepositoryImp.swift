//
//  SwiftDataDinnerStatusRepositoryImp.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/11/02.
//

import Foundation
import SwiftData

final class SwiftDataDinnerStatusRepositoryImp: DinnerStatusRepository {
    private let context: ModelContext
    init(context: ModelContext) { self.context = context }
    
    func upsertAnswer(groupId: UUID, date: Date, userId: UUID, answer: DinnerAnswer) async throws {
        let id = makeIdentifier(groupId: groupId, date: date)
        
        let dinnerStatusSD = try fetchAsSD(by: id) ?? DinnerStatus(id: id, groupId: groupId, day: FormatterStore.startOfDay(date), answers: [userId: answer]).toSwiftData()
        
        var answers = AnswerCodec.decode(dinnerStatusSD.answerData)
        answers[userId] = answer
        dinnerStatusSD.answerData = AnswerCodec.encode(answers)
        
        try context.save()
    }
    
    func fetch(groupId: UUID, date: Date) async throws -> DinnerStatus? {
        let id = makeIdentifier(groupId: groupId, date: date)
        let dinnerStatusSD = try fetchAsSD(by: id)
        return dinnerStatusSD?.toDomain()
    }
    
    func fetchMonth(groupId: UUID, anyDayInMonth: Date) async throws -> [DinnerStatus] {
        return []
    }
    
    // SwiftData用にfetchする
    private func fetchAsSD(by compositeId: String) throws -> DinnerStatusSD? {
        let desc = FetchDescriptor<DinnerStatusSD>(predicate: #Predicate { $0.compositeId == compositeId })
        return try context.fetch(desc).first
    }
    
    func makeIdentifier(groupId: UUID, date: Date) -> String {
        let dateKey = date.formatted(FormatterStore.yyyyMMddDashStyle)
        let id = "\(groupId.uuidString)_\(dateKey)"
        return id
    }
}
