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
    @State private var isShowColor = false
    @State private var isShowParticipant = false
    @State private var isShowAlarm = false
    
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
            
            Button(action: { isShowColor.toggle() }) {
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
            .sheet(isPresented: $isShowColor) {
                VStack {
                    HStack {
                        Spacer()
                        Text("「家族」のラベルリスト")
                        Spacer()
                    }
                    ForEach(ScheduleColor.allCases) { color in
                        HStack(spacing: 8) {
                            Rectangle()
                                .fill(color.color)
                                .frame(width: 5)
                                .frame(maxHeight: .infinity)
                            Text(color.name)
                            Spacer()
                        }
                        .padding(.leading, 12)
                    }
                }
                .padding(.vertical, 12)
                .presentationDetents([.medium])
            }
            
            Divider()
            
            Button(action: { isShowParticipant.toggle() }) {
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
            .sheet(isPresented: $isShowParticipant) {
                VStack {
                    Text("参加者:Take")
                        .padding(.top, 12)
                        .padding(.bottom, 28)

                    HStack {
                        Text("T")
                            .padding(5)
                            .background(
                                Circle()
                                    .fill(Color(.systemBackground)) //色は仮
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.secondary, lineWidth: 1)
                            )
                        VStack(alignment: .leading) {
                            Text("Take")
                                .font(.title3)
                                .bold()
                            Text("2002年7月28日")
                                .font(.caption)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "checkmark.circle.fill")
                        
                    }
                    .padding()
                    .background(Color.green.opacity(0.2))
                    
                    Spacer()
                }
                .presentationDetents([.medium])
            }
            
            Divider()
            
            Button(action: { isShowAlarm.toggle() }) {
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
            .sheet(isPresented: $isShowAlarm) {
                VStack {
                    HStack {
                        Spacer()
                        Text("開始時に通知が届きます。")
                        Spacer()
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 20)
                    
                    HStack {
                        Text("予定のリマインド通知")
                        Spacer()
                    }
                    
                    ForEach(ScheduleReminder.allCases) { reminder in
                        HStack {
                            Text(reminder.name)
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                        }
                        .padding(.bottom, 12)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .presentationDetents([.medium])
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

public enum ScheduleColor: String, CaseIterable,Identifiable {
    case green
    case blue
    case brown
    case red
    case orange
    
    public var id: String { rawValue }
    
    public var name: String {
        switch self {
        case .green:
            return "グリーン"
        case .blue:
            return "ブルー"
        case .brown:
            return "ブラウン"
        case .red:
            return "レッド"
        case .orange:
            return "オレンジ"
        }
    }
    
    public var color: Color {
        switch self {
        case .green:
            return Color.green
        case .blue:
            return Color.blue
        case .brown:
            return Color.brown
        case .red:
            return Color.red
        case .orange:
            return Color.orange
        }
    }
}

public enum ScheduleReminder: String, CaseIterable, Identifiable {
    case start
    case beforeTenMinute
    case beforeHour
    
    public var id: String { rawValue }
    
    public var name: String {
        switch self {
        case .start:
            return "開始時"
        case .beforeTenMinute:
            return "10分前"
        case .beforeHour:
            return "1時間前"
        }
    }
    
    public var description: String {
        switch self {
        case .start:
            return "開始時に通知が届きます。"
        case .beforeTenMinute:
            return "10分前に通知が届きます。"
        case .beforeHour:
            return "1時間前に通知が届きます。"
        }
    }
}
