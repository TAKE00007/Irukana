import Foundation

struct CalendarInfo: Identifiable, Codable, Equatable {
    let id: UUID
    let groupId: UUID
    var name: String
}
