//
//  AddReducer.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/27.
//

import Foundation

struct AddReducer {
    let service: DinnerStatusService
    let scheduleService: ScheduleService
    let groupId: UUID
    let userId: UUID
    let calendarId: UUID
    var now: () -> Date = { Date() }
    
    init(
         service: DinnerStatusService,
         scheduleService: ScheduleService,
         groupId: UUID,
         userId: UUID,
         calendarId: UUID,
         now: @escaping () -> Date = { Date() }
    ) {
        self.service = service
        self.scheduleService = scheduleService
        self.groupId = groupId
        self.userId = userId
        self.calendarId = calendarId
        self.now = now
    }
    
    func reduce(state: inout AddState, action: AddAction) -> AddEffect? {
        switch action {
        case .tapDinnerYes:
            state.isDinner = true
            return .upsert(isYes: true)
            
        case .tapDinnerNo:
            state.isDinner = false
            return .upsert(isYes: false)
            
        case let .setTitle(title):
            state.scheduleForm.title = title
            return nil
        case let .setAllDay(isAllDay):
            state.scheduleForm.isAllDay = isAllDay
            return nil
        case let .setStartAt(startAt):
            state.scheduleForm.startAt = startAt
            return nil
        case let .setEndAt(endAt):
            state.scheduleForm.endAt = endAt
            return nil
        case let .setNotifyAt(notifyAt):
            state.scheduleForm.notifyAt = notifyAt
            return nil
        case let .setColor(color):
            state.scheduleForm.color = color
            return nil
        case .tapSave:
            return .saveSchedule(
                calendarId: calendarId,
                title: state.scheduleForm.title,
                startAt: state.scheduleForm.startAt,
                endAt: state.scheduleForm.endAt,
                notifyAt: state.scheduleForm.notifyAt,
                color: state.scheduleForm.color,
                isAllDay: state.scheduleForm.isAllDay
            )
        case let .saveResponse(result):
            switch result {
            case .success(let success):
                return nil
            case .failure(let error):
                return nil
            }
        }
    }
    
    func run(_ effect: AddEffect) async throws {
        switch effect {
        case let .upsert(isYes):
            try await service.upsertDinnerStatus(
                groupId: groupId,
                date: now(),
                userId: userId,
                isYes: isYes
            )
        case .saveSchedule(calendarId: let calendarId, title: let title, startAt: let startAt, endAt: let endAt, notifyAt: let notifyAt, color: let color, isAllDay: let isAllDay):
            _ = try await scheduleService.addSchedule(calendarId: calendarId, title: title, startAt: startAt, endAt: endAt, notifyAt: notifyAt, color: color, isAllDay: isAllDay)
        }
    }
}
