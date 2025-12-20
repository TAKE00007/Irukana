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
                            .bold()
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(selection == tab ? Color.white : Color.orange)
                    .background(
                        ZStack {
                            if selection == tab {
                                Capsule()
                                    .fill(Color(.orange))
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

struct AddView: View {
    @State private var state = AddState(isDinner: true)
    private var reducer: AddReducer
    
    let onFinish: () -> Void
    
    init(reducer: AddReducer, onFinish: @escaping () -> Void) {
        self.reducer = reducer
        self.onFinish = onFinish
    }
    
    
    @State private var selection: TopTab = .dinner
    
    var body: some View {
        VStack(spacing: 16) {
            TopTabs(selection: $selection)
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                switch selection {
                case .schedule:
                    ScheduleView()
                case .dinner:
                    DinnerView {
                        if let effect = reducer.reduce(state: &state, action: .tapDinnerYes) {
                            Task {
                                do {
                                    try await reducer.run(effect)
                                    onFinish()
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    } onNo: {
                        if let effect = reducer.reduce(state: &state, action: .tapDinnerNo) {
                            Task {
                                do {
                                    try await reducer.run(effect)
                                    onFinish()
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    }

                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}

//#Preview {
//    AddView {
//        print("")
//    }
//}

private struct ScheduleView: View {
    @State private var title = ""
    @State private var isFullDay = false
    @State private var startDay = Date()
    @State private var endtDay = Date()
    var body: some View {
        VStack(spacing: 10) {
            TextField(text: $title, prompt: Text("タイトル").font(.title2).foregroundStyle(.secondary)) {
                EmptyView()
            }
            .textFieldStyle(.plain)
            .padding(.vertical, 8)
            
            Divider()
            
            HStack {
                Toggle(isOn: $isFullDay) {
                    Text("終日")
                }
            }
            
            HStack {
                DatePicker(
                    "開始",
                    selection: $startDay,
                    displayedComponents: [.date, .hourAndMinute]
                )
            }
            
            HStack {
                DatePicker(
                    "終了",
                    selection: $endtDay,
                    displayedComponents: [.date, .hourAndMinute]
                )
            }
            
            Divider()
            
            Button(action: { print("") }) {
                HStack {
                    Image(systemName: "tag")
                        .foregroundStyle(Color.orange)
                    Text("エメラルド・グリーン")
                        .foregroundStyle(Color.black)
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .foregroundStyle(Color.gray)
                }
            }
            
            Divider()
            
            Button(action: { print("") }) {
                HStack {
                    Image(systemName: "person")
                        .foregroundStyle(Color.orange)
                    Text("参加者")
                        .foregroundStyle(Color.black)
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .foregroundStyle(Color.gray)
                }
            }
            
            Divider()
            
            Button(action: { print("") }) {
                HStack {
                    Image(systemName: "alarm")
                        .foregroundStyle(Color.orange)
                    Text("10分前")
                        .foregroundStyle(Color.black)
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .foregroundStyle(Color.gray)
                }
            }
            
            Divider()
            
            CalendarButton(
                title: "保存",
                variant: .primary,
                action: { print("") }
            )
            .padding()
        }
        .padding(.horizontal, 16)
    }
}

private struct DinnerView: View {
    let onYes: () -> Void
    let onNo: () -> Void
    
    var body: some View {
        VStack {
            Text("本日のご飯")
                .bold()
                .padding()
            
            Image("Dinner")
                .resizable()
                .scaledToFit()
            
            CalendarButton(
                title: "いる",
                variant: .primary,
                action: onYes
            )
            .padding()
            
            
            CalendarButton(
                title: "いらない",
                variant: .outline,
                action: onNo
            )
            .padding()

        }
        .font(.largeTitle)
    }
}

