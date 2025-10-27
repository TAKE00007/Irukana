//
//  AddScheduleView.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/27.
//

import SwiftUI

enum TopTab: String, Identifiable, Hashable, CaseIterable {
    case schedule = "予定"
    case dinner = "ご飯"
    
    var id: String { rawValue }
}

struct TopTabs: View {
    @Binding var selection: TopTab
    var tabs: [TopTab] = TopTab.allCases
    @Namespace private var ns
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                ForEach(tabs) { tab in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                                selection = tab
                        }
                    } label: {
                        Text(tab.rawValue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(selection == tab ? Color.white : Color.primary)
                    .background(
                        ZStack {
                            if selection == tab {
                                Capsule()
                                    .fill(Color(.blue))
                                    .matchedGeometryEffect(id: "TAB", in: ns)
                            }
                        }
                    )
                    .contentShape(Rectangle())
                }
            }
            .background(Color(.systemGray6))
            .clipShape(Capsule())
            .padding(6)
        }
    }
}

struct AddScheduleView: View {
    @State private var selection: TopTab = .schedule
    
    var body: some View {
        VStack(spacing: 16) {
            TopTabs(selection: $selection)
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                switch selection {
                case .schedule:
                    ScheduleView()
                case .dinner:
                    DinnerView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    AddScheduleView()
}

private struct ScheduleView: View {
    var body: some View {
        Text("予定追加画面")
    }
}

private struct DinnerView: View {
    var body: some View {
        Text("ご飯入力画面")
    }
}
