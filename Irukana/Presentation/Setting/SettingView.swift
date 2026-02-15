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
                Button {
                    print("")
                } label: {
                    HStack {
                        Text("T")
                            .padding(3)
                            .background(
                                Circle()
                                    .fill(Color(.systemBackground))
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.orange, lineWidth: 1)
                            )
                        Text("H")
                            .padding(3)
                            .background(
                                Circle()
                                    .fill(Color(.systemBackground))
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.orange, lineWidth: 1)
                            )
                        Spacer()
                        Image(systemName: "chevron.forward")
                    }
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
    }
    
    private func send(_ action: SettingAction) {
        let effect = reducer.reduce(state: &state, action: action)
        
        guard let effect else { return }
        Task {
            let action = await reducer.run(effect)
            reducer.reduce(state: &state, action: action)
        }
    }
}

//#Preview {
//    SettingView()
//}
