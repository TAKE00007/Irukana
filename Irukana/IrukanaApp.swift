import SwiftUI
import FirebaseCore
import SwiftData

@main
struct IrukanaApp: App {
    
    let container: DIContainer
    
    init() {
        #if DEBUG
        let container = try! ModelContainer(for: DinnerStatusSD.self)
        let context = ModelContext(container)
        
        let authRepository = FirestoreAuthRepositoryImp()
        let dinnerRepository = SwiftDataDinnerStatusRepositoryImp(context: context)
        let scheduleRepository = FireStoreScheduleRepositoryImp()
        let userRepository = FirestoreUserRepositoryImp()
        let schedulePariticpantRepository = FireStoreScheduleParticipantRepositoryImp()
        let calendarRepository = FireStoreCalendarRepositoryImp()
        let groupRepository = FirestoreGroupRepositoryImp()
        let sessionRepository = SessionRepositoryImp()
        
        self.container = DIContainer(
            authService: AuthService(
                authRepository: authRepository,
                sessionRepository: sessionRepository,
                userRepository: userRepository,
                groupRepository: groupRepository,
                calendarRepository: calendarRepository
            ),
            dinnerService: DinnerStatusService(
                dinnerStatusRepository: dinnerRepository,
                userRepository: userRepository,
                groupRepository: groupRepository
            ),
            scheduleService: ScheduleService(
                scheduleRepository: scheduleRepository,
                userRepository: userRepository,
                scheduleParticipantRepository: schedulePariticpantRepository
            ),
            calendarService: CalendarService(
                calendarRepository: calendarRepository,
                groupRepository: groupRepository,
                userRepository: userRepository,
            )
        )
        
        #else
        FirebaseApp.configure()
        
        let authRepository = FirestoreAuthRepositoryImp()
        let dinnerRepository = FirestoreDinnerStatusRepositoryImp()
        let scheduleRepository = FireStoreScheduleRepositoryImp()
        let userRepository = FirestoreUserRepositoryImp()
        let schedulePariticpantRepository = FireStoreScheduleParticipantRepositoryImp()
        let calendarRepository = FireStoreCalendarRepositoryImp()
        let groupRepository = FirestoreGroupRepositoryImp()
        let sessionRepository = SessionRepositoryImp()
        
        self.container = DIContainer(
            authService: AuthService(
                authRepository: authRepository,
                sessionRepository: sessionRepository,
                userRepository: userRepository,
                groupRepository: groupRepository,
                calendarRepository: calendarRepository,
            ),
            dinnerService: DinnerStatusService(
                dinnerStatusRepository: dinnerRepository,
                userRepository: userRepository,
                groupRepository: groupRepository
            ),
            scheduleService: ScheduleService(
                scheduleRepository: scheduleRepository,
                userRepository: userRepository,
                scheduleParticipantRepository: schedulePariticpantRepository
            ),
            calendarService: CalendarService(
                calendarRepository: calendarRepository,
                groupRepository: groupRepository,
                userRepository: userRepository,
            )
        )
        #endif
    }
    var body: some Scene {
        WindowGroup {
            RootView(reducer: RootReducer(service: container.authService))
                .environment(\.injected, container)
        }
    }
}
