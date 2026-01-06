import SwiftUI

struct RootView: View {
    @Environment(\.injected) private var container
    @State private var state: RootState = .loggedOut
    
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
                AppRootView(user: user, calendarInfo: calendarInfo)
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
            // TODO: ユーザー情報を取得する処理を記述
        }
    }
}
