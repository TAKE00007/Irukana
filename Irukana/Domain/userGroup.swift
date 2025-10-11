//
//  usersGroups.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/11.
//

import Foundation

struct userGroup {
    let groupId: UUID
    let userId: UUID
    
    init(groupId: UUID, userId: UUID) {
        self.groupId = groupId
        self.userId = userId
    }
}
