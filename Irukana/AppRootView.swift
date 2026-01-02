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
    @Published var calendarId: UUID
    
    init(currentGroupId: UUID, currentUserId: UUID, calendarId: UUID) {
        self.currentGroupId = currentGroupId
        self.currentUserId = currentUserId
        self.calendarId = calendarId
    }
}

struct AppRootView: View {
    @Environment(\.injected) private var container
    
    @State private var selected: AppTab = .schedule
    @State private var lastTab: AppTab = .schedule
    @State private var isPresented = false
    
    // テストようにUUIDをここで生成する
    @StateObject private var session = Session(
        currentGroupId: UUID(),
        currentUserId: UUID(),
        calendarId: UUID()
    )
    
    var body: some View {
        TabView(selection: $selected) {
            NavigationStack {
                CalendarView(reducer: CalendarReducer(
                    service: container.dinnerService,
                    groupId: session.currentGroupId, now: { Date() }
                ))
            }
            .tabItem { Label("予定", systemImage: "calendar")}
            .tag(AppTab.schedule)
            
            NavigationStack {
                NotificationView(reducer: NotificationReducer(
                    dinnerStatusService: container.dinnerService,
                    scheduleService: container.scheduleService,
                    calendarId: session.calendarId,
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
                service: container.dinnerService,
                scheduleService: container.scheduleService,
                groupId: session.currentGroupId,
                userId: session.currentUserId,
                calendarId: session.calendarId,
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
