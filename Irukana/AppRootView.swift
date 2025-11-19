//
//  AppRootView.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/26.
//

import SwiftUI
import Combine
import SwiftData

enum AppTab: Hashable { case schedule, notification, setting, add }
enum DataStoreKind { case firestore, swiftData }

final class Session: ObservableObject {
    @Published var currentGroupId: UUID
    @Published var currentUserId: UUID
    
    init(currentGroupId: UUID, currentUserId: UUID) {
        self.currentGroupId = currentGroupId
        self.currentUserId = currentUserId
    }
}

struct AppDependencies {
    let dinnerRepository: DinnerStatusRepository
    let dinnerService: DinnerStatusService
    
    static func make(kind: DataStoreKind) -> AppDependencies {
        let container = try! ModelContainer(for: DinnerStatusSD.self)
        let repository: DinnerStatusRepository
        switch kind {
        case .firestore: repository = FirestoreDinnerStatusRepositoryImp()
        case .swiftData: repository = SwiftDataDinnerStatusRepositoryImp(context: ModelContext(container))
        }
        return .init(
            dinnerRepository: repository,
            dinnerService: .init(repository: repository)
        )
    }
}

struct AppRootView: View {
    #if DEBUG
    @State private var dependencies = AppDependencies.make(kind: .swiftData)
    #else
    @State private var dependencies = AppDependencies.make(kind: .firestore)
    #endif
    
    @State private var selected: AppTab = .schedule
    @State private var lastTab: AppTab = .schedule
    @State private var isPresented = false
    
    // テストようにUUIDをここで生成する
    @StateObject private var session = Session(
        currentGroupId: UUID(),
        currentUserId: UUID()
    )
    
    var body: some View {
        TabView(selection: $selected) {
            NavigationStack {
                CalendarView(reducer: CalendarReducer(
                    service: dependencies.dinnerService,
                    groupId: session.currentGroupId, now: { Date() }
                ))
            }
            .tabItem { Label("予定", systemImage: "calendar")}
            .tag(AppTab.schedule)
            
            NavigationStack {
                NotificationView(reducer: NotificationReducer(
                    service: dependencies.dinnerService,
                    groupId: session.currentGroupId)
                )
            }
            .tabItem { Label("新着", systemImage: "bell") }
            .tag(AppTab.notification)
            
            NavigationStack { Text("設定") }
                .tabItem { Label("設定", systemImage: "gear") }
                .tag(AppTab.setting)
            
            Color.clear
                .tabItem { Label("追加", systemImage: "plus") }
                .tag(AppTab.add)
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .onChange(of: selected) {
            if selected == .add {
                isPresented = true
                selected = lastTab
            } else {
                lastTab = selected
            }
        }

        .sheet(isPresented: $isPresented) {
            let reducer = AddReducer(
                service: dependencies.dinnerService,
                groupId: session.currentGroupId,
                userId: session.currentUserId,
                now: { Date() }
            )
            AddView(reducer: reducer) {
                isPresented = false
                selected = .schedule
            }
        }
    }
}

#Preview {
    AppRootView()
}
