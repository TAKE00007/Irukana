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

struct AddScheduleView: View {
    @State var selection: TopTab
    var tabs: [TopTab] = TopTab.allCases
    @Namespace private var ns
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                ForEach(tabs) { tab in
                    Button {
                        selection = tab
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

//#Preview {
//    AddScheduleView(selection: .constant(.schedule))
//}

struct AddSchedulePreviewWrapper: View {
    @State private var selection: TopTab = .schedule
    var body: some View {
        AddScheduleView(selection: selection)
            .padding()
    }
}

#Preview {
    AddSchedulePreviewWrapper()
}
