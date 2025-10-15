//
//  CreateCalendarView.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/15.
//

import SwiftUI

struct CreateCalendarView: View {
    var body: some View {
        VStack {
            Image("CreateCalendar")
                .resizable()
                .scaledToFit()
            Text("Irukana にようこそ")
                .font(.largeTitle)
                .bold()
                .padding(20)
            CalendarButton(title: "新しいカレンダーを作成する", variant: .primary) {
                print("新しいカレンダーを作成するが押されました")
            }
            CalendarButton(title: "招待されたカレンダーに参加する", variant: .outline) {
                print("招待されたカレンダーに参加するが押されました")
            }
        }
    }
}

#Preview {
    CreateCalendarView()
}
