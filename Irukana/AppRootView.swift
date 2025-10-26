//
//  AppRootView.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/26.
//

import SwiftUI

enum AppTab: Hashable { case schedule, notification, setting, add }

struct AppRootView: View {
    @State private var selected: AppTab = .schedule
    
    var body: some View {
        TabView(selection: $selected) {
            NavigationStack {
                CalendarView()
            }
            .tabItem { Label("予定", systemImage: "calendar")}
            .tag(AppTab.schedule)
            
            NavigationStack { Text("新着") }
                .tabItem { Label("新着", systemImage: "bell") }
                .tag(AppTab.notification)
            
            NavigationStack { Text("設定") }
                .tabItem { Label("設定", systemImage: "gear") }
                .tag(AppTab.setting)
            
            NavigationStack { Text("追加") }
                .tabItem { Label("追加", systemImage: "plus") }
                .tag(AppTab.add)
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

#Preview {
    AppRootView()
}
