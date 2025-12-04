//
//  RootView.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/12/04.
//

import SwiftUI

struct RootView: View {
    @Environment(\.injected) private var container
    @State private var state: RootState = .loggedOut
    
    // userを仮で作る
//    let user = User(id: UUID(uuidString: "8DFFC7EA-A842-48CF-963B-96714E3E9935")!, name: "Take", passwordHash: "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08", photoURL: nil, birthday: nil)
    
    var body: some View {
        VStack {
            switch state {
            case .loading:
                ProgressView()
            case .loggedOut:
                AuthRootView() { user in
                    state = .loggedIn(user)
                }
            case .loggedIn(let user):
                AppRootView() // 将来的にuserを注入するようにする
            }
        }
        .task {
            print("")
            // TODO: ユーザー情報を取得する処理を記述
        }
    }
}
