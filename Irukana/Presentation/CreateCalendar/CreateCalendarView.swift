//
//  CreateCalendarView.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/15.
//

import SwiftUI

struct CreateCalendarView: View {
    @State private var state = CreateCalendarState()
    private var reducer: CreateCalendarReducer
    
    init(reducer: CreateCalendarReducer = .init()) {
        self.reducer = reducer
    }
    
    var body: some View {
        NavigationStack(path: $state.path) {
            VStack {
                Image("CreateCalendar")
                    .resizable()
                    .scaledToFit()
                Text("Irukana にようこそ")
                    .font(.largeTitle)
                    .bold()
                    .padding(20)
                
                CalendarButton(title: "新しいカレンダーを作成する", variant: .primary) {
                    reducer.reduce(state: &state, action: .tapCreateCalendar)
                }
                CalendarButton(title: "招待されたカレンダーに参加する", variant: .outline) {
                    reducer.reduce(state: &state, action: .tapJoinCalendar)
                }
            }
            .navigationDestination(for: CreateCalendarRoute.self) { route in
                switch route {
                case .createNew:
                    Text("新規カレンダー作成画面")
                case .join:
                    Text("共有カレンダー参加画面")
                }
            }
        }
    }
}

#Preview {
    CreateCalendarView(reducer: .init())
}
