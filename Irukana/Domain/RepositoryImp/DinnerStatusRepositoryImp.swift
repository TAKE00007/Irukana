//
//  DinnerStatusRepositoryImp.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/29.
//

import Foundation
import FirebaseFirestore

final class DinnerStatusRepositoryImp: DinnerStatusRepository {
    private let db = Firestore.firestore()
    private var col: CollectionReference { db.collection("dinnerStatuses") }
    
    
    func upsertAnswer(groupId: UUID, date: Date, userId: UUID, answer: DinnerAnswer) async throws {
        let id = makeIdentifier(groupId: groupId, date: date)
        let ref = col.document(id)
        
        let status = DinnerStatus(
            id: id,
            groupId: groupId,
            day: FormatterStore.startOfDay(date),
            answers: [userId: answer]
        )
        
        try ref.setData(from: status, merge: true)
    }
    
    func fetch(groupId: UUID, date: Date) async throws -> DinnerStatus? {
        let id = makeIdentifier(groupId: groupId, date: date)
        let snap = try await col.document(id).getDocument()
        guard snap.exists else { return nil }

        let status = try snap.data(as: DinnerStatus.self)
        return status
    }
    
    func fetchMonth(groupId: UUID, anyDayInMonth: Date) async throws -> [DinnerStatus] {
        let (start, end) = FormatterStore.monthRange(for: anyDayInMonth)
        
        let reponse = try await col
            .whereField("groupId", isEqualTo: groupId.uuidString)
            .whereField("day", isGreaterThanOrEqualTo: start)
            .whereField("day", isLessThan: end)
            .order(by: "day", descending: false)
            .getDocuments()
        
        return try reponse.documents.compactMap { try $0.data(as: DinnerStatus.self) }
    }
    
    func makeIdentifier(groupId: UUID, date: Date) -> String {
        let dateKey = date.formatted(FormatterStore.yyyyMMddDashStyle)
        let id = "\(groupId.uuidString)_\(dateKey)"
        return id
    }
}
