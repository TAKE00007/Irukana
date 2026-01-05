enum RootState {
    case loading
    case loggedOut
    case loggedIn(User)
    case createCalendar(User)
}
