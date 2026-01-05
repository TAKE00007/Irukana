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
        
        self.container = DIContainer(
            authService: AuthService(repository: authRepository),
            dinnerService: DinnerStatusService(
                dinnerStatusRepository: dinnerRepository,
                userRepository: userRepository),
            scheduleService: ScheduleService(
                scheduleRepository: scheduleRepository,
                userRepository: userRepository,
                scheduleParticipantRepository: schedulePariticpantRepository
            ),
            calendarService: CalendarService(
                calendarRepository: calendarRepository,
                groupRepository: groupRepository
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
        
        self.container = DIContainer(
            authService: AuthService(repository: authRepository),
            dinnerService: DinnerStatusService(
                dinnerStatusRepository: dinnerRepository,
                userRepository: userRepository
            ),
            scheduleService: ScheduleService(
                scheduleRepository: scheduleRepository,
                userRepository: userRepository,
                scheduleParticipantRepository: schedulePariticpantRepository
            ),
            calendarService: CalendarService(
                calendarRepository: calendarRepository,
                groupRepository: groupRepository
            )
        )
        #endif
    }
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.injected, container)
        }
    }
}
