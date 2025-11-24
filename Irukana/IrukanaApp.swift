//
//  IrukanaApp.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/11.
//

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
        
        self.container = DIContainer(
            authService: AuthService(repository: authRepository),
            dinnerService: DinnerStatusService(repository: dinnerRepository)
        )
        
        #else
        FirebaseApp.configure()
        
        let authRepository = FirestoreAuthRepositoryImp()
        let dinnerRepository = FirestoreDinnerStatusRepositoryImp()
        
        self.container = DIContainer(
            authService: AuthService(repository: authRepository),
            dinnerService: DinnerStatusService(repository: dinnerRepository)
        )
        #endif
    }
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environment(\.injected, container)
        }
    }
}
