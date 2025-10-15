//
//  CalendarButton.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/15.
//

import SwiftUI

struct CalendarButton: View {
    enum Variant { case primary, outline }
    
    let title: String
    let variant: Variant
    let action: () -> Void
    
    init(title: String, variant: Variant, action: @escaping () -> Void) {
        self.title = title
        self.variant = variant
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, minHeight:  48)
                .foregroundStyle(variant == .primary ? .white : .orange)
                .background(variant == .primary ? .orange : .clear)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.orange), lineWidth: 1.0)
                )
        }
        .padding(.horizontal, 30)
    }
}
