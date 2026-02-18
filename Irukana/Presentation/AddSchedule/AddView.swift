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
                    ScheduleView(state: state, send: send) {
                        if let effect = reducer.reduce(state: &state, action: .tapSave) {
                            Task {
                                let response = await reducer.run(effect)
                                _ = reducer.reduce(state: &state, action: response)
                                onFinish()
                            }
                        }
                    }
                    .onAppear {
                        if let effect = reducer.reduce(state: &state, action: .onAppear) {
                            Task {
                                let response = await reducer.run(effect)
                                _ = reducer.reduce(state: &state, action: response)
                            }
                        }
                    }
                case .dinner:
                    DinnerView {
                        if let effect = reducer.reduce(state: &state, action: .tapDinnerYes) {
                            Task {
                                let response = await reducer.run(effect)
                                _ = reducer.reduce(state: &state, action: response)
                                onFinish()
                            }
                        }
                    } onNo: {
                        if let effect = reducer.reduce(state: &state, action: .tapDinnerNo) {
                            Task {
                                let response = await reducer.run(effect)
                                _ = reducer.reduce(state: &state, action: response)
                                onFinish()
                            }
                        }
                    }

                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
    
    private func send(_ action: AddAction) {
        _ = reducer.reduce(state: &state, action: action)
    }
}

//#Preview {
//    AddView {
//        print("")
//    }
//}

private struct ScheduleView: View {
    let state: AddState
    @State private var isShowColor = false
    @State private var isShowParticipant = false
    @State private var isShowAlarm = false
    let send: (AddAction) -> Void
    let action: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            TextField(text: Binding(get: { state.scheduleForm.title }, set: { send(.setTitle($0)) }),
                      prompt: Text("タイトル").font(.title2).foregroundStyle(.secondary)) {
                EmptyView()
            }
            .textFieldStyle(.plain)
            .padding(.vertical, 8)
            
            Divider()
            
            HStack {
                Toggle(isOn: Binding(
                    get: { state.scheduleForm.isAllDay },
                    set: { send(.setAllDay($0)) }
                )) {
                    Text("終日")
                }
            }
            
            HStack {
                DatePicker(
                    "開始",
                    selection: Binding(
                        get: { state.scheduleForm.startAt },
                        set: { send(.setStartAt($0)) }
                    ),
                    displayedComponents: [.date, .hourAndMinute]
                )
            }
            
            HStack {
                DatePicker(
                    "終了",
                    selection: Binding(
                        get: { state.scheduleForm.endAt },
                        set: { send(.setEndAt($0)) }
                    ),
                    displayedComponents: [.date, .hourAndMinute]
                )
            }
            
            Divider()
            
            Button(action: { isShowColor.toggle() }) {
                HStack {
                    Image(systemName: "tag")
                        .foregroundStyle(state.scheduleForm.color.color)
                    Text(state.scheduleForm.color.name)
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
                        let isSelected = (state.scheduleForm.color == color)
                        HStack(spacing: 8) {
                            Rectangle()
                                .fill(color.color)
                                .frame(width: 5)
                                .frame(maxHeight: .infinity)
                            Text(color.name)
                            Spacer()
                            
                            Button {
                                send(.setColor(color))
                                isShowColor = false
                            } label: {
                                Image(systemName: isSelected ? "dot.circle" : "circle")
                            }
                            .foregroundStyle(Color.black)

                        }
                        .padding(.horizontal, 12)
                        .background(isSelected ? Color.gray.opacity(0.2) : Color.clear)
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
                ScrollView {
                    VStack {
                        HStack {
                            Text("参加者:")
                            ForEach(
                                Array(state.users
                                    .filter { state.selectedUserIds.contains($0.id) }
                                )
                            ) { user in
                                Text(user.name )
                            }
                        }
                        .padding(.top, 12)
                        .padding(.bottom, 28)
                        ForEach(state.users) { user in
                            let isSelected = state.selectedUserIds.contains(user.id)
                            HStack {
                                Text(user.name.prefix(1))
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
                                    Text(user.name)
                                        .font(.title3)
                                        .bold()
                                    Text(user.birthday?.formatted(FormatterStore.yyyyMMddStyle) ?? "")
                                        .font(.caption)
                                }
                                
                                Spacer()
                                
                                Image(systemName: isSelected ? "checkmark.square": "square")
                                
                            }
                            .onTapGesture {
                                send(.toggleUserSelection(user))
                            }
                            .padding()
                            .background(isSelected ? Color.green.opacity(0.2) : Color.clear)
                        }
                        
                        Spacer()
                    }
                    .presentationDetents([.medium])
                }
            }
            
            Divider()
            
            Button(action: { isShowAlarm.toggle() }) {
                HStack {
                    Image(systemName: "alarm")
                        .foregroundStyle(Color.orange)
                    Text(state.scheduleForm.notifyAt?.name ?? "")
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
                        Text(state.scheduleForm.notifyAt?.description ?? "" )
                        Spacer()
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 20)
                    
                    HStack {
                        Text("予定のリマインド通知")
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    
                    ForEach(ScheduleReminder.allCases, id: \.self) { reminder in
                        let isSelected = (state.scheduleForm.notifyAt == reminder)
                        HStack {
                            Text(reminder.name)
                            Spacer()
                            Button {
                                send(.setNotifyAt(reminder))
                                isShowAlarm = false
                            } label: {
                                Image(systemName: isSelected ? "dot.circle" : "circle")
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(isSelected ? Color.green.opacity(0.2) : Color.clear)
                    }
                    
                    Spacer()
                }
                .presentationDetents([.medium])
            }
            
            Divider()
            
            CalendarButton(
                title: "保存",
                variant: .primary,
                action: action
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

extension ScheduleColor {
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


