import Foundation

struct CreateCalendarReducer {
    let service: CalendarService
    let userId: UUID
    
    init(service: CalendarService, userId: UUID) {
        self.service = service
        self.userId = userId
    }
    
    func reduce(state: inout CreateCalendarState, action: CreateCalendarAction)  -> CreateCalendarEffect? {
        switch action {
        case .tapCreateCalendar:
            state.path.append(.createNew)
            return  nil
        case .tapJoinCalendar:
            state.path.append(.join)
            return nil
        case .setCalendarName(let calendarName):
            state.calendarName = calendarName
            return nil
        case .setCalendarId(let calendarId):
            state.calendarId =  calendarId
            return nil
        case .createCalendar:
            return .createCalendar(calendarName: state.calendarName)
        case .joinCalendar:
            return .joinCalendar(calendarId: state.calendarId)
        case .createCalendarResponse(let result):
            switch result {
            case .success(let calendarInfo):
                state.calendarInfo = calendarInfo
                return nil
            case .failure(let failure):
                return nil
            }
        case .joinCalendarResponse(let result):
            switch result {
            case .success(let calendarInfo):
                state.calendarInfo = calendarInfo
                return nil
            case .failure(let failure):
                return nil
            }
        }
    }
    
    func run(_ effect: CreateCalendarEffect) async -> CreateCalendarAction {
        switch effect {
        case .createCalendar(let calendarName):
            do {
                let calendarInfo = try await service.createCalendarInfo(userId: userId, name: calendarName)
                return .createCalendarResponse(.success(calendarInfo))
            } catch {
                return .createCalendarResponse(.failure(CalendarError.failCreateCalendar))
            }
        case .joinCalendar(let calendarId):
            do {
                guard let calendarInfo = try await service.loadCalendarInfo(id: calendarId)
                else { return .joinCalendarResponse(.failure(CalendarError.calendarNotFound)) }
                return .joinCalendarResponse(.success(calendarInfo))
            } catch {
                return .joinCalendarResponse(.failure(CalendarError.calendarNotFound))
            }
        }
    }
}
