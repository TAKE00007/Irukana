import Foundation
import FirebaseFirestore

final class FireStoreScheduleParticipantRepositoryImp: ScheduleParticipantRepository {
    private let db = Firestore.firestore()
    private var col: CollectionReference { db.collection("scheduleParticipants") }
    
    func addScheduleParticipant(scheduleId: UUID, userId: UUID) async throws {
        let scheduleParticipant = ScheduleParticipant(scheduleId: scheduleId, userId: userId)
        let scheduleParticipantDoc = scheduleParticipant.toDoc()
        
        let docId = "\(scheduleId.uuidString)_\(userId.uuidString)"
        let ref = col.document(docId)
        
        try ref.setData(from: scheduleParticipantDoc)
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
