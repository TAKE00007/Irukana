//
//  DinnerStatus.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/11.
//

import Foundation

struct DinnerStatus: Identifiable, Codable {
    let id: String //groups/{groupId}/dinners/{yyyy-MM-dd}
    let groupId: UUID
    let date: String  //"yyyy-MM-dd"
    var answers: [UUID : String]
}
