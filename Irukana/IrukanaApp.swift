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
        
        self.container = DIContainer(
            authService: AuthService(repository: authRepository),
            dinnerService: DinnerStatusService(
                dinnerStatusRepository: dinnerRepository,
                userRepository: userRepository),
            scheduleService: ScheduleService(
                scheduleRepository: scheduleRepository,
                userRepository: userRepository,
                scheduleParticipantRepository: schedulePariticpantRepository
            )
        )
        
        #else
        FirebaseApp.configure()
        
        let authRepository = FirestoreAuthRepositoryImp()
        let dinnerRepository = FirestoreDinnerStatusRepositoryImp()
        let scheduleRepository = FireStoreScheduleRepositoryImp()
        let userRepository = FirestoreUserRepositoryImp()
        let schedulePariticpantRepository = FireStoreScheduleParticipantRepositoryImp()
        
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
