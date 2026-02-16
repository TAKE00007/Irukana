import SwiftUI

struct SettingView: View {
    @State private var state = SettingState(notificationTime: Date())
    private var reducer: SettingReducer
    private let onLogout: () -> Void
    
    init(reducer: SettingReducer, onLogout: @escaping () -> Void) {
        self.reducer = reducer
        self.onLogout = onLogout
    }
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading) {
                Text("通知設定")
                    .font(.title2)
                    .bold()
                Divider()
                HStack {
                    Toggle(isOn: Binding(
                        get: { state.isNotification },
                        set: { send(.setIsNotification($0)) }
                    )) {
                        Text("アプリの通知")
                    }
                }
                Divider()
                HStack {
                    DatePicker(
                        "通知の時間",
                        selection: Binding(
                            get: { state.notificationTime },
                            set: { send(.setNotificationTime($0)) }
                        ),
                        displayedComponents: [.hourAndMinute]
                    )
                }
            }
            
            VStack(alignment: .leading) {
                Text("メンバー設定")
                    .font(.title2)
                    .bold()
                Divider()
                NavigationLink {
                    MemberSettingView(users: state.users)
                    { user in
                        send(.deleteUser(user))
                    }
                } label: {
                    HStack {
                        ForEach(state.users) { user in
                            ZStack {
                                Circle()
                                    .fill(Color(.systemBackground))
                                    .frame(width: 32, height: 32)
                                Text(user.name.prefix(1))
                            }
                            .overlay(
                                Circle()
                                    .stroke(Color.orange, lineWidth: 1)
                                    .frame(width: 32, height: 32)
                            )
                        }
                        Spacer()
                        Image(systemName: "chevron.forward")
                    }
                    .padding(.top, 12)
                    .foregroundStyle(.gray)
                }
            }
            
            Spacer()
            
            CalendarButton(
                title: "ログアウトする",
                variant: .outline,
                action: { send(.tapLogout) }
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .onChange(of: state.isLogOut) { _, newValue in
            if newValue {
                onLogout()
            }
        }
        .onAppear {
            send(.onAppear)
        }
    }
    
    private func send(_ action: SettingAction) {
        Task {
            var nextAction: SettingAction? = action
            
            while let currentAction = nextAction {
                let effect =  reducer.reduce(state: &state, action: currentAction)
                
                guard let effect else {
                    nextAction = nil
                    continue
                }
                
                let producedAction = await reducer.run(effect)
                nextAction = producedAction
            }
        }
    }
}

struct MemberSettingView: View {
    let users: [User]
    let delete: (User) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            List(users) { user in
                Button {
                    print("")
                } label: {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color(.systemBackground))
                                .frame(width: 32, height: 32)
                            Text(user.name.prefix(1))
                        }
                        .overlay(
                            Circle()
                                .stroke(Color.orange, lineWidth: 1)
                                .frame(width: 32, height: 32)
                        )
                        
                        Text(user.name)
                            .bold()
                    }
                    .foregroundStyle(Color.black)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        delete(user)
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
            .listStyle(.insetGrouped)
            
            Spacer()
        }
        .navigationTitle("メンバーリスト")
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

//#Preview {
//    SettingView()
//}
