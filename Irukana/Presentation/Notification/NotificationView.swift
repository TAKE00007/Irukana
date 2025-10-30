//
//  NotificationView.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/30.
//

import SwiftUI

struct NotificationView: View {
    
    @State private var selection: TopTab = .dinner
    
    var body: some View {
        VStack(spacing: 16) {
            TopTabs(selection: $selection)
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                switch selection {
                case .schedule:
                    NotificationScheduleView()
                case .dinner:
                    NotificationDinnerView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    NotificationView()
}

private struct NotificationScheduleView: View {
    var body: some View {
        Text("予定")
    }
}

private struct NotificationDinnerView: View {
    var body: some View {
        Text("ごはん")
    }
}
