import SwiftUI

struct CreateCalendarView: View {
    @State private var state = CreateCalendarState()
    private var reducer: CreateCalendarReducer

    let onCalendarSuccess: (CalendarInfo) -> Void
    
    init(reducer: CreateCalendarReducer, onCalendarSuccess: @escaping (CalendarInfo) -> Void) {
        self.reducer = reducer
        self.onCalendarSuccess = onCalendarSuccess
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
                    VStack {
                        Text("カレンダーの名前を入力してください")
                        TextField(
                            text: Binding(
                                get: { state.calendarName },
                                set: { send(.setCalendarName($0)) }
                            ),
                            prompt: Text("タイトル").font(.title2).foregroundStyle(.secondary)) {
                            EmptyView()
                        }
                        .padding(10)
                        .background(Color(.textField))
                        .frame(maxWidth: .infinity, minHeight:  20)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.textField), lineWidth: 1.0)
                        )
                        .padding(.bottom, 5)
                        
                        CalendarButton(title: "新しいカレンダーを作成する", variant: .primary) {
                            if let effect = reducer.reduce(state: &state, action: .createCalendar) {
                                Task {
                                    let response = await reducer.run(effect)
                                    _ = reducer.reduce(state: &state, action: response)
                                }
                            }
                        }
                    }
                case .join:
                    VStack {
                        Text("IDを入力してください")
                        TextField(
                            text: Binding(
                                get: { state.calendarId },
                                set: { send(.setCalendarId($0)) }
                            ),
                            prompt: Text("ID").font(.title2).foregroundStyle(.secondary)) {
                            EmptyView()
                        }
                        .padding(10)
                        .background(Color(.textField))
                        .frame(maxWidth: .infinity, minHeight:  20)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.textField), lineWidth: 1.0)
                        )
                        .padding(.bottom, 5)
                        
                        CalendarButton(title: "招待されたカレンダーに参加する", variant: .outline) {
                            if let effect = reducer.reduce(state: &state, action: .joinCalendar) {
                                Task {
                                    let response = await reducer.run(effect)
                                    _ = reducer.reduce(state: &state, action: response)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: state.calendarInfo) { newValue in
            guard let calendrInfo = newValue else { return }
            
            onCalendarSuccess(calendrInfo)
            
            state.calendarInfo = nil
        }
    }
    
    private func send(_ action: CreateCalendarAction) {
        _ = reducer.reduce(state: &state, action: action)
    }
}

//#Preview {
//    CreateCalendarView(reducer: .init(service: <#CalendarService#>, userId: <#UUID#>))
//}
