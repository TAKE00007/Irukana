import SwiftUI

struct RootView: View {
    @Environment(\.injected) private var container
    @State private var state: RootState = .loggedOut
    private var reducer: RootReducer
    
    init(reducer: RootReducer) {
        self.reducer = reducer
    }
    
    var body: some View {
        VStack {
            switch state {
            case .loading:
                ProgressView()
            case .loggedOut:
                AuthRootView() { user in
                    state = .createCalendar(user)
                }
            case .loggedIn(let user, let calendarInfo):
                AppRootView(
                    user: user,
                    calendarInfo: calendarInfo,
                    onLogout: {
                        state = .loggedOut
                    }
                )
            case .createCalendar(let user):
                CreateCalendarView(
                    reducer: CreateCalendarReducer(
                        service: container.calendarService,
                        userId: user.id
                    )
                ) { calendarInfo in
                    state = .loggedIn(user, calendarInfo)
                }
            }
        }
        .task {
            print("")
            if let effect = reducer.reduce(state: &state, action: .onAppear) {
                Task {
                    let response = await reducer.run(effect)
                    _ = reducer.reduce(state: &state, action: response)
                }
            }
        }
    }
}
