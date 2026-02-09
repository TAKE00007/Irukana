import SwiftUI
import Combine
import SwiftData

enum AppTab: Hashable { case schedule, notification, setting, add }
enum DataStoreKind { case firestore, swiftData }

final class Session: ObservableObject {
    @Published var currentGroupId: UUID
    @Published var calendarId: UUID
    
    init(currentGroupId: UUID, calendarId: UUID) {
        self.currentGroupId = currentGroupId
        self.calendarId = calendarId
    }
}

struct AppRootView: View {
    @Environment(\.injected) private var container
    let user: User
    let calendarInfo: CalendarInfo
    let onLogout: () -> Void
    
    @State private var selected: AppTab = .schedule
    @State private var lastTab: AppTab = .schedule
    @State private var isPresented = false
    
    // テストようにUUIDをここで生成する
    @StateObject private var session = Session(
        currentGroupId: UUID(),
        calendarId: UUID()
    )
    
    var body: some View {
        TabView(selection: $selected) {
            NavigationStack {
                CalendarView(
                    reducer: CalendarReducer(
                        dinnerStatusService: container.dinnerService,
                        scheduleService: container.scheduleService,
                        user: user,
                        calendarId: calendarInfo.id,
                        groupId: calendarInfo.groupId,
                        now: { Date() }
                    ),
                    user: user,
                    groupId: calendarInfo.groupId
                )
            }
            .tabItem { Label("予定", systemImage: "calendar")}
            .tag(AppTab.schedule)
            
            NavigationStack {
                NotificationView(reducer: NotificationReducer(
                    dinnerStatusService: container.dinnerService,
                    scheduleService: container.scheduleService,
                    calendarId: calendarInfo.id,
                    groupId: calendarInfo.groupId)
                )
            }
            .tabItem { Label("新着", systemImage: "bell") }
            .tag(AppTab.notification)
            
            NavigationStack {
                SettingView(
                    reducer: SettingReducer(
                        service: container.authService,
                        localNotificationService: container.localNotificationService),
                    onLogout: onLogout
                )
            }
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
                calendarService: container.calendarService,
                groupId: calendarInfo.groupId,
                userId: user.id,
                calendarId: calendarInfo.id,
                now: { Date() }
            )
            AddView(reducer: reducer) {
                isPresented = false
                selected = .schedule
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: AppDelegate.didOpenNotification)) { note in
            guard let route = note.userInfo?["route"] as? String else { return }
            if route == "dinner" {
                isPresented = true
                selected = lastTab
            } else if route == "calendar" {
                isPresented = false
                selected = .schedule
            }
        }
    }
}

//#Preview {
//    AppRootView(user: User(id: UUID(), name: "Take", passwordHash: "test"))
//}
