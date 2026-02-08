import Foundation
import FirebaseFirestore

final class FireStoreScheduleParticipantRepositoryImp: ScheduleParticipantRepository {
    private let db = Firestore.firestore()
    private var col: CollectionReference { db.collection("scheduleParticipants") }
    
    func addScheduleParticipant(scheduleId: UUID, userIds: [UUID]) async throws {
        let uniqueUserIds = Array(Set(userIds))
        guard !uniqueUserIds.isEmpty else { return }
        
        let batch = db.batch()
        
        for userId in uniqueUserIds {
            let scheduleParticipant = ScheduleParticipant(scheduleId: scheduleId, userId: userId)
            let scheduleParticipantDoc = scheduleParticipant.toDoc()
            let docId = "\(scheduleId.uuidString)_\(userId.uuidString)"
            let ref = col.document(docId)
            try batch.setData(from: scheduleParticipantDoc, forDocument: ref)
        }
        
        try await batch.commit()
    }
    
    func updateScheduleParticipant(scheduleId: UUID, userIds: [UUID]) async throws {
        let uniqueUserIds = Array(Set(userIds))
        guard !uniqueUserIds.isEmpty else { return }
        
        let snap = try await col
            .whereField("scheduleId", isEqualTo: scheduleId.uuidString)
            .getDocuments()
        
        let batch = db.batch()
        
        for doc in snap.documents {
            batch.deleteDocument(doc.reference)
        }
        
        for userId in uniqueUserIds {
            let scheduleParticipant = ScheduleParticipant(scheduleId: scheduleId, userId: userId)
            let scheduleParticipantDoc = scheduleParticipant.toDoc()
            let docId = "\(scheduleId.uuidString)_\(userId.uuidString)"
            let ref = col.document(docId)
            try batch.setData(from: scheduleParticipantDoc, forDocument: ref)
        }
        
        try await batch.commit()
    }
    
    func fetchBySchedule(scheduleId: UUID) async throws -> [UUID] {
        let snap = try await col
            .whereField("scheduleId", isEqualTo: scheduleId.uuidString)
            .getDocuments()
        
        return snap.documents.compactMap { doc in
            guard let data = try? doc.data(as: ScheduleParticipantDoc.self) else { return nil }
            return UUID(uuidString: data.userId)
        }
    }
    
    func fetchByUser(userId: UUID) async throws -> [UUID] {
        let snap = try await col
            .whereField("userId", isEqualTo: userId.uuidString)
            .getDocuments()
        
        return snap.documents.compactMap { doc in
            guard let data = try? doc.data(as: ScheduleParticipantDoc.self) else { return nil }
            return UUID(uuidString: data.scheduleId)
        }
    }
    
    
}
