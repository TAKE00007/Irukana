//
//  LoginView.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/11/24.
//

import SwiftUI

struct LoginView: View {
    @State private var isPresented = false
    var body: some View {
        NavigationStack {
            VStack {
                Image("Icon")
                    .resizable()
                    .scaledToFit()
                CalendarButton(title: "はじめる", variant: .outline) {
                    isPresented = true
                }
                    .padding(.bottom, 10)
                CalendarButton(title: "ログイン", variant: .primary, action: {print("")}
                )
            }
            .sheet(isPresented: $isPresented) {
                SignUpView() {
                    isPresented = false
                }
            }
        }
    }
}

struct SignUpView: View {
    let onClose: () -> Void
    
    @State private var name = ""
    @State private var birthday = Date()
    @State private var password = ""
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
                TextField("必須", text: $name)
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
                    selection: $birthday,
                    displayedComponents: .date
                )
                .padding(.bottom, 5)
                
                Text("パスワード")
                SecureField("必須", text: $password)
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
                    onClose()
                }
            }
            .padding(.horizontal, 16)
            .navigationTitle("プロフィール編集")
            .padding()
        }
    }
}

#Preview {
    LoginView()
}
