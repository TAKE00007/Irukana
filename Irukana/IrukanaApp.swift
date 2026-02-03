import SwiftUI
import FirebaseCore
import SwiftData

@main
struct IrukanaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
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
        let localNotificationRepository = LocalNotificationRepositoryImp()
        
        self.container = DIContainer(
            authService: AuthService(
                authRepository: authRepository,
                sessionRepository: sessionRepository,
                userRepository: userRepository,
                groupRepository: groupRepository,
                calendarRepository: calendarRepository,
                localNotificationRepository: localNotificationRepository,
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
            ),
            localNotificationService: LocalNotificationService(
                localNotificationRepository: localNotificationRepository,
                sessionRepository: sessionRepository,
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
        let localNotificationRepository = LocalNotificationRepositoryImp()
        
        self.container = DIContainer(
            authService: AuthService(
                authRepository: authRepository,
                sessionRepository: sessionRepository,
                userRepository: userRepository,
                groupRepository: groupRepository,
                calendarRepository: calendarRepository,
                localNotificationRepository: localNotificationRepository,
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
            ),
            localNotificationService: LocalNotificationService(
                localNotificationRepository: localNotificationRepository,
                sessionRepository: sessionRepository,
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
