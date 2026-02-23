import Foundation

struct AuthRootState {
    var name: String = ""
    var birthday: Date = Date()
    var password: String = ""
    
    var user: User? = nil
    var isLoading: Bool = false
    
    var isSignUp: Bool = false
    var isLogin: Bool = false
    
    var loginSucceeded: Bool = false
    
    var alertContent: AlertContent? = nil
}

enum AuthRootRoute: Hashable {
    case root
}


