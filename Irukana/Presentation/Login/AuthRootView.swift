//
//  LoginView.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/11/24.
//

import SwiftUI

struct AuthRootView: View {
    @Environment(\.injected) private var container
//    private let reducer: LoginReducer
    @State private var state = AuthRootState()
    private var reducer: AuthRootReducer { AuthRootReducer(service: container.authService) }
//    init(reducer: LoginReducer) {
//        self.reducer = reducer
//    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("Icon")
                    .resizable()
                    .scaledToFit()
                CalendarButton(title: "はじめる", variant: .outline) {
                    _ = reducer.reduce(state: &state, action: .tapSignUpButton)
                }
                    .padding(.bottom, 10)
                CalendarButton(title: "ログイン", variant: .primary) {
                    _ = reducer.reduce(state: &state, action: .tapLoginButton)
                }
            }
            .sheet(isPresented: $state.isSignUp) {
                SignUpView(reducer: reducer, state: $state) {
                    _ = reducer.reduce(state: &state, action: .dismissSignUp)
                }
            }
            .sheet(isPresented: $state.isLogin) {
                LoginView(reducer: reducer, state: $state) {
                    _ = reducer.reduce(state: &state, action: .dismissLoginButton)
                }
            }
        }
    }
}

struct LoginView: View {
    let reducer: AuthRootReducer
    @Binding var state: AuthRootState
    let onClose: () -> Void
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("名前")
                TextField("必須", text: $state.name)
                    .padding(10)
                    .background(Color(.textField))
                    .frame(maxWidth: .infinity, minHeight:  20)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.textField), lineWidth: 1.0)
                    )
                    .padding(.bottom, 5)
                
                Text("パスワード")
                SecureField("必須", text: $state.password)
                    .padding(10)
                    .background(Color(.textField))
                    .frame(maxWidth: .infinity, minHeight:  20)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.textField), lineWidth: 1.0)
                    )
                    .padding(.bottom, 5)
                
                CalendarButton(title: "ログイン", variant: .primary) {
                    Task {
                        if let effect = reducer.reduce(state: &state, action: .tapLogin) {
                            let responseAction = await reducer.run(effect)
                            _ = reducer.reduce(state: &state, action: responseAction)
                        }
                        onClose()
                    }
                }
                
            }
            .padding()
            .navigationTitle("ログイン")
        }
    }
}

struct SignUpView: View {
    let reducer: AuthRootReducer
    @Binding var state: AuthRootState
    let onClose: () -> Void

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                
               Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.white)
                    .frame(width: 80, height: 80)
                    .padding(40)
                    .background(Circle().fill(Color.gray.opacity(0.2)))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 30)
                
                Text("名前")
                TextField("必須", text: $state.name)
                    .padding(10)
                    .background(Color(.textField))
                    .frame(maxWidth: .infinity, minHeight:  20)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.textField), lineWidth: 1.0)
                    )
                    .padding(.bottom, 5)
                
                
                Text("生年月日")
                DatePicker(
                    "日付を選択(任意)",
                    selection: $state.birthday,
                    displayedComponents: .date
                )
                .padding(.bottom, 5)
                
                Text("パスワード")
                SecureField("必須", text: $state.password)
                    .padding(10)
                    .background(Color(.textField))
                    .frame(maxWidth: .infinity, minHeight:  20)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.textField), lineWidth: 1.0)
                    )
                    .padding(.bottom, 5)
                
                Spacer()
                
                CalendarButton(title: "保存", variant: .primary) {
                    Task {
                        if let effect = reducer.reduce(state: &state, action: .tapSignUp) {
                            let responseAction = await reducer.run(effect)
                            _ = reducer.reduce(state: &state, action: responseAction)
                        }
                        onClose()
                    }
                }
            }
            .padding(.horizontal, 16)
            .navigationTitle("プロフィール編集")
            .padding()
        }
    }
}
