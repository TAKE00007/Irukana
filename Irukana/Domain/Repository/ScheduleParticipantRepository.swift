import Foundation

protocol ScheduleParticipantRepository {
    func addScheduleParticipant(scheduleId: UUID, userIds: [UUID]) async throws
    func updateScheduleParticipant(scheduleId: UUID, userIds: [UUID]) async throws
    func fetchBySchedule(scheduleId: UUID) async throws -> [UUID]
    func fetchByUser(userId: UUID) async throws -> [UUID]
    func deleteScheduleParticipants(scheduleId: UUID) async throws
}
