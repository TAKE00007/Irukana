//
//  CalendarReducer.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/11/05.
//

import Foundation

struct CalendarReducer {
    let service: DinnerStatusService
    let groupId: UUID
    var now: () -> Date = { Date() }
    
    init(service: DinnerStatusService, groupId: UUID, now: @escaping () -> Date) {
        self.service = service
        self.groupId = groupId
        self.now = now
    }
    
    func reduce(state: inout CalendarState, action: CalendarAction) -> CalendarEffect? {
        switch action {
        case .onAppear:
            state.isLoading = true
            state.visibleMonthStart = state.baseMonthStart
            let monthStart = state.visibleMonthStart ?? Date()
            return .load(visibleMonthStart: monthStart)
        case let .dinnerStatusResponse(.success(dinnerStatusList)):
            state.isLoading = false
            state.dinnerStatusList = dinnerStatusList
            state.dinnerStatusByDay = Dictionary(uniqueKeysWithValues: dinnerStatusList.map { ($0.day, $0) })
            state.errorMessage = nil
            return nil
        case let .dinnerStatusResponse(.failure(error)):
            state.isLoading = false
            state.errorMessage = error.localizedDescription
            return nil
        }
    }
    
    func run(_ effect: CalendarEffect) async throws -> [DinnerStatus]? {
        switch effect {
        case .load(let visibleMonthStart):
            // baseMonthStatrに基づいて1ヶ月分ロードする
            // 別でonChangeでカレンダーの月が変わった時に1ヶ月分ロードするようにする
            let dinnerStatusList = try await service.loadDinnerStatusMonth(groupId: groupId, date:visibleMonthStart)
            return dinnerStatusList
        }
    }
}
