import Foundation

protocol ScheduleParticipantRepository {
    func addScheduleParticipant(scheduleId: UUID, userId: UUID) async throws
    func fetchBySchedule(scheduleId: UUID) async throws -> [UUID]
    func fetchByUser(userId: UUID) async throws -> [UUID]
}
