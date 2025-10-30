//
//  NotificationView.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/30.
//

import SwiftUI

struct NotificationView: View {
    private var reducer: NotificationReducer
    @State private var state: NotificationState?
    
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
                    NotificationScheduleView()
                case .dinner:
                    NotificationDinnerView(state: state)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .task {
            if let effect = reducer.reduce(state: &state, action: .onAppear) {
                do {
                    if let dinnerStatus = try await reducer.run(effect) {
                        state = .loaded(dinnerStatus)
                    } else {
                        state = .failed("データがありません")
                    }
                } catch {
                    state = .failed (error.localizedDescription)
                }
            }
        }
    }
}

//#Preview {
//    NotificationView()
//}

private struct NotificationScheduleView: View {
    
    var body: some View {
        Text("予定")
    }
}

private struct NotificationDinnerView: View {
    let state: NotificationState?
    
    var body: some View {
        switch state {
        case .none:
            ProgressView("読み込み中")
        case .failed(let message):
            Text("取得に失敗: \(message)").foregroundStyle(.red)
        case .loaded(let dinnerStatus):
            VStack(alignment: .leading, spacing: 8) {
                ForEach(dinnerStatus.answers.keys.sorted(by: { $0.uuidString < $1.uuidString }), id: \.self) { uuid in
                    let answer = dinnerStatus.answers[uuid] ?? .unknown
                    HStack {
                        Text(uuid.uuidString.prefix(4))
                            .padding()
                        Spacer()
                        Text(label(for: answer))
                            .bold()
                            .padding()
                    }
                    .background(statusColor(for: answer))
                }
            }
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
