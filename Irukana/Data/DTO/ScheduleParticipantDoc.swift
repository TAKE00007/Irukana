import FirebaseFirestore

struct ScheduleParticipantDoc: Codable {
    @DocumentID var id: String?
    var scheduleId: String
    var userId: String
}

extension ScheduleParticipantDoc {
    func toDomain() -> ScheduleParticipant? {
        guard let sId = UUID(uuidString: scheduleId) else { return nil }
        guard let uId = UUID(uuidString: userId) else { return nil }
        
        return ScheduleParticipant(scheduleId: sId, userId: uId)
    }
}

extension ScheduleParticipant {
    func toDoc() -> ScheduleParticipantDoc {
        let sId = scheduleId.uuidString
        let uId = userId.uuidString
        
        return ScheduleParticipantDoc(scheduleId: sId, userId: uId)
    }
}
