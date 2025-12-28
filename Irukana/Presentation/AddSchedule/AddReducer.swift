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
        case .onAppear:
            guard state.didInitScheduleForm == false else { return nil }
            state.didInitScheduleForm = true
            state.scheduleForm.startAt = Date()
            state.scheduleForm.endAt = state.calendar.date(byAdding: .hour, value: 1, to: state.scheduleForm.startAt) ?? state.scheduleForm.startAt.addingTimeInterval(3600)
            return nil
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
            if !state.isEdited {
                state.scheduleForm.endAt = state.calendar.date(byAdding: .hour, value: 1, to: state.scheduleForm.startAt) ?? startAt.addingTimeInterval(3600)
            }
            return nil
        case let .setEndAt(endAt):
            state.scheduleForm.endAt = endAt
            state.isEdited = true
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
                state.alert = AlertState(title: "予定の登録に失敗", message: "\(error)")
                return nil
            }
        case let .dinnerStatusResponse(result):
            switch result {
            case .success(let success):
                return nil
            case .failure(let error):
                state.alert = AlertState(title: "ご飯の追加に失敗", message: "\(error)")
                return nil
            }
        }
    }
    
    func run(_ effect: AddEffect) async -> AddAction {
        switch effect {
        case let .upsert(isYes):
            do {
                try await service.upsertDinnerStatus(
                    groupId: groupId,
                    date: now(),
                    userId: userId,
                    isYes: isYes
                )
                return .dinnerStatusResponse(.success(true)) // TODO: trueを入れている意味はないので直す
            } catch {
                return .dinnerStatusResponse(.failure(.failDinnerStatus))
            }
        case .saveSchedule(calendarId: let calendarId, title: let title, startAt: let startAt, endAt: let endAt, notifyAt: let notifyAt, color: let color, isAllDay: let isAllDay):
            do {
                let schedule = try await scheduleService.addSchedule(calendarId: calendarId, title: title, startAt: startAt, endAt: endAt, notifyAt: notifyAt, color: color, isAllDay: isAllDay)
                
                return .saveResponse(.success(schedule))
            } catch {
                return .saveResponse(.failure(.failAddSchedule))
            }
        }
    }
}
