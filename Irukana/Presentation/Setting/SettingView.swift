import SwiftUI

struct SettingView: View {
    @State private var state = SettingState(notificationTime: Date())
    private var reducer: SettingReducer
    
    init(reducer: SettingReducer) {
        self.reducer = reducer
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
            
            Spacer()
            
            CalendarButton(
                title: "ログアウトする",
                variant: .outline,
                action: { print("") }
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }
    
    private func send(_ action: SettingAction) {
        reducer.reduce(state: &state, action: action)
    }
}

//#Preview {
//    SettingView()
//}
