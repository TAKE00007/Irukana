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
    
    func fetchCalendar(id: UUID) async throws -> CalendarInfo? {
        let uId = id.uuidString
        let snap = try await col.document(uId).getDocument()
        guard snap.exists else { return nil }
        
        let calendarInfo = try snap.data(as: CalendarInfoDoc.self)
        
        return calendarInfo.toDomain()
    }
}
