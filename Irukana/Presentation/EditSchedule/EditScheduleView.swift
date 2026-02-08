import SwiftUI

struct EditScheduleView: View {
    @State private var state: EditScheduleState
    private var reducer: EditScheduleReducer

    @State private var isShowColor = false
    @State private var isShowParticipant = false
    @State private var isShowAlarm = false
    
    let onFinish: () -> Void
    
    init(
        reducer: EditScheduleReducer,
        state: EditScheduleState,
        onFinish: @escaping () -> Void
    ) {
        self.reducer = reducer
        self.state = state
        self.onFinish = onFinish
    }

    var body: some View {
        VStack(spacing: 10) {
            TextField(text: Binding(get: { state.title }, set: { send(.setTitle($0)) }),
                      prompt: Text("タイトル").font(.title2).foregroundStyle(.secondary)) {
                EmptyView()
            }
            .textFieldStyle(.plain)
            .padding(.vertical, 8)
            
            Divider()
            
            HStack {
                Toggle(isOn: Binding(
                    get: { state.isAllDay },
                    set: { send(.setAllDay($0)) }
                )) {
                    Text("終日")
                }
            }
            
            HStack {
                DatePicker(
                    "開始",
                    selection: Binding(
                        get: { state.startAt },
                        set: { send(.setStartAt($0)) }
                    ),
                    displayedComponents: [.date, .hourAndMinute]
                )
            }
            
            HStack {
                DatePicker(
                    "終了",
                    selection: Binding(
                        get: { state.endAt },
                        set: { send(.setEndAt($0)) }
                    ),
                    displayedComponents: [.date, .hourAndMinute]
                )
            }
            
            Divider()
            
            Button(action: { isShowColor.toggle() }) {
                HStack {
                    Image(systemName: "tag")
                        .foregroundStyle(state.color.color)
                    Text(state.color.name)
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
                        let isSelected = (state.color == color)
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
                                if isSelected {
                                    Image(systemName: "dot.circle")
                                } else {
                                    Image(systemName: "circle")
                                }
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
                        Text("参加者:Take")
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
                                send(.toggleUserSelection(user.id))
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
                    Text(state.notifyAt?.name ?? "")
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
                        Text(state.notifyAt?.description ?? "" )
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
                        let isSelected = (state.notifyAt == reminder)
                        HStack {
                            Text(reminder.name)
                            Spacer()
                            Button {
                                send(.setNotifyAt(reminder))
                                isShowAlarm = false
                            } label: {
                                if isSelected {
                                    Image(systemName: "checkmark.square")
                                } else {
                                    Image(systemName: "square")
                                }
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
            ) {
                if let effect = reducer.reduce(state: &state, action: .tapSave) {
                    Task {
                        let response = await reducer.run(effect)
                        _ = reducer.reduce(state: &state, action: response)
                    }
                }
                onFinish()
            }
            .padding()
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    private func send( _ action: EditScheduleAction) {
        _ = reducer.reduce(state: &state, action: action)
    }
}
