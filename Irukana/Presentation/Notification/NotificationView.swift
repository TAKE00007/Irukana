import SwiftUI

struct NotificationView: View {
    private var reducer: NotificationReducer
    @State private var state: NotificationState = .init()
    
    init(reducer: NotificationReducer) {
        self.reducer = reducer
    }
    
    @State private var selection: TopTab = .dinner
    
    var body: some View {
        VStack(spacing: 16) {
            TopTabs(selection: $selection)
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                switch selection {
                case .schedule:
                    NotificationScheduleView(state: state)
                case .dinner:
                    NotificationDinnerView(state: state)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .task {
            if let effect = reducer.reduce(state: &state, action: .onAppear) {
                let response = await reducer.run(effect)
                _ = reducer.reduce(state: &state, action: response)
            }
        }
    }
}

//#Preview {
//    NotificationView()
//}

private struct NotificationScheduleView: View {
    let state: NotificationState
    var body: some View {
        if state.isLoading {
            ProgressView("読み込み中")
        } else if let message = state.scheduleErrorMessage {
            Text("取得に失敗: \(message)")
                .foregroundStyle(.red)
        } else {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(state.schedules, id: \.0.id) { (schedule, users) in
                    HStack {
                        Text(users.first?.name ?? "")
                            .padding()
                        Spacer()
                        Text(schedule.title)
                            .bold()
                            .padding()
                    }
                }
            }
        }
    }
}

private struct NotificationDinnerView: View {
    let state: NotificationState
    
    var body: some View {
        if state.isLoading {
            ProgressView("読み込み中")
        } else if let message = state.dinnerStatusErrorMessage {
            Text("取得に失敗: \(message)")
                .foregroundStyle(.red)
        } else if !state.answers.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(state.answers, id: \.0) { item in
                    HStack {
                        Text(item.name)
                            .padding()
                        Spacer()
                        Text(label(for: item.answer))
                            .bold()
                            .padding()
                    }
                    .background(statusColor(for: item.answer))
                }
            }
        } else {
            Text("まだ誰も入力してません")
        }
    }
    
    private func label(for answer: DinnerAnswer) -> String {
        switch answer {
        case .need: return "いる"
        case .noneed: return "いらない"
        case .unknown: return "未回答"
        }
    }
    
    private func statusColor(for answer: DinnerAnswer) -> Color {
        switch answer {
        case .need: return .green.opacity(0.2)
        case .noneed: return .red.opacity(0.2)
        case .unknown: return .gray.opacity(0.2)
        }
    }
}
