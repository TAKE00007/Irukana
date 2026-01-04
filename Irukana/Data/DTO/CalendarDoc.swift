import Foundation
import FirebaseFirestore

struct CalendarInfoDoc: Codable {
    @DocumentID var id: String?
    let groupId: String
    let name: String
}

extension CalendarInfoDoc {
    func toDomain() -> CalendarInfo? {
        guard let id, let id = UUID(uuidString: id) else { return nil }
        
        guard let gId = UUID(uuidString: groupId) else { return nil }
        
        return CalendarInfo(id: id, groupId: gId, name: name)
    }
}

extension CalendarInfo {
    func toDoc() -> CalendarInfoDoc {
        let uId = id.uuidString
        let gId = groupId.uuidString
        
        return CalendarInfoDoc(id: uId, groupId: gId, name: name)
    }
}
