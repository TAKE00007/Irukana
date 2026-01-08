import Foundation

struct ScheduleService {
    let scheduleRepository: ScheduleRepository
    let userRepository: UserRepository
    let scheduleParticipantRepository: ScheduleParticipantRepository
    
    func addSchedule(calendarId: UUID, title: String, startAt: Date, endAt: Date, notifyAt: ScheduleReminder?, color: ScheduleColor, isAllDay: Bool, userIds: [UUID]) async throws -> Schedule {
        
        let reminderDate = notifyAt?.reminderDate(startAt: startAt)
        
        let schedule = try await scheduleRepository.addSchedule(calendarId: calendarId, title: title, startAt: startAt, endAt: endAt, notifyAt: reminderDate, color: color, isAllDay: isAllDay)
        
        try await scheduleParticipantRepository.addScheduleParticipant(scheduleId: schedule.id, userIds: userIds)
        
        return schedule
    }
    
    func loadScheduleCreatedInLast24Hours(calendarId: UUID, now: Date) async throws -> [(Schedule, [User])] {
        
        guard let schedules = try await scheduleRepository.fetchRecentlyCreated(calendarId: calendarId, createdAt: now)
        else { return [] }
        
        var response: [(Schedule, [User])] = []
        
        for schedule in schedules {
            let userIds =  try await scheduleParticipantRepository.fetchBySchedule(scheduleId: schedule.id)
            let uniqueUserIds = Array(Set(userIds))
            
            let users: [User] = try await withThrowingTaskGroup(of: User.self) { group in
                for userId in uniqueUserIds {
                    group.addTask {
                        guard let user = try await userRepository.fetchUser(id: userId)
                        else { throw UserError.userNotFound }
                        return user
                    }
                }
                
                var fetchedUsers: [User] = []
                
                for try await user in group {
                    fetchedUsers.append(user)
                }
                
                return fetchedUsers
            }
            
            response.append((schedule, users))
        }
        
        return response
    }
    
    // TODO: 要検討キャッシュするなどしたい
    func loadScheduleMonth(calendarId: UUID, now: Date) async throws -> [(Schedule, [User])] {
        let schedules = try await scheduleRepository.fetchMonth(calendarId: calendarId, anyDayInMonth: now)
        
        guard !schedules.isEmpty else { return [] }
        
        var response: [(Schedule, [User])] = []
        
        for schedule in schedules {
            let userIds =  try await scheduleParticipantRepository.fetchBySchedule(scheduleId: schedule.id)
            let uniqueUserIds = Array(Set(userIds))
            
            let users: [User] = try await withThrowingTaskGroup(of: User.self) { group in
                for userId in uniqueUserIds {
                    group.addTask {
                        guard let user = try await userRepository.fetchUser(id: userId)
                        else { throw UserError.userNotFound }
                        return user
                    }
                }
                
                var fetchedUsers: [User] = []
                
                for try await user in group {
                    fetchedUsers.append(user)
                }
                
                return fetchedUsers
            }
            
            response.append((schedule, users))
        }
        
        return response
    }
}
