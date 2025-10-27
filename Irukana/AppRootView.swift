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
    @State private var lastTab: AppTab = .schedule
    @State private var isPresented = false
    
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
            AddView {
                isPresented = false
                selected = .schedule
            }
        }
    }
}

#Preview {
    AppRootView()
}
