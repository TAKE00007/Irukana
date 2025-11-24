//
//  AppDependencies.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/11/24.
//

import Foundation
import SwiftData

struct AppDependencies {
    let dinnerService: DinnerStatusService
    let authService: AuthService
    
    static func make(kind: DataStoreKind) -> AppDependencies {
        let repository: DinnerStatusRepository
        switch kind {
        case .firestore:
            repository = FirestoreDinnerStatusRepositoryImp()
        case .swiftData:
            let container = try! ModelContainer(for: DinnerStatusSD.self)
            repository = SwiftDataDinnerStatusRepositoryImp(context: ModelContext(container)
            )
        }
        
        let dinnerService = DinnerStatusService(repository: repository)
        
        let authRepository = FirestoreAuthRepositoryImp()
        let authService = AuthService(repository: authRepository)
        
        return .init(
            dinnerService: dinnerService,
            authService: authService
        )
    }
}
