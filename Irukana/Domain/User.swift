//
//  User.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/11.
//

import Foundation

struct User {
    let id: UUID
    var name: String
    var photoURL: String?
    var birthday: Date?
    var authProviderUID: String
    
    init(id: UUID, name: String, photoURL: String? = nil, birthday: Date? = nil, authProviderUID: String) {
        self.id = id
        self.name = name
        self.photoURL = photoURL
        self.birthday = birthday
        self.authProviderUID = authProviderUID
    }
}
