//
//  AddReducer.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/27.
//

import Foundation

struct AddReducer {
    
    func reduce(state: inout AddState, action: AddAction) {
        switch action {
        case .tapDinnerYes:
            state.isDinner = true
        case .tapDinnerNo:
            state.isDinner = false
        }
    }
}
