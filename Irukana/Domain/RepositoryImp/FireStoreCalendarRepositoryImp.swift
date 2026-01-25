import Foundation
import FirebaseFirestore

struct FireStoreCalendarRepositoryImp: CalendarRepository {
    private let db = Firestore.firestore()
    private var col: CollectionReference { db.collection("calendarInfos") }
    
    func createCalendar(id: UUID, groupId: UUID, name: String) async throws -> CalendarInfo {
        let ref = col.document(id.uuidString)
        
        let calendarInfo = CalendarInfo(id: id, groupId: groupId, name: name)
        
        let docCalenarInfo = calendarInfo.toDoc()
        
        try ref.setData(from: docCalenarInfo)
        
        return calendarInfo
    }
    
    func fetchCalendar(id: String) async throws -> CalendarInfo? {
        let snap = try await col.document(id).getDocument()
        guard snap.exists else { return nil }
        
        let calendarInfo = try snap.data(as: CalendarInfoDoc.self)
        
        return calendarInfo.toDomain()
    }
    
    func fetchCalendarsByGroupId(groupId: UUID) async throws -> [CalendarInfo] {
        let response = try await col.whereField("groupId", isEqualTo: groupId.uuidString).getDocuments()
        
        return try response.documents.compactMap { try $0.data(as: CalendarInfoDoc.self).toDomain() }
    }
}
