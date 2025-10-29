//
//  DinnerStatus.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/10/11.
//

import Foundation
import FirebaseFirestore

enum DinnerAnswer: String, Codable { case unknown, need, noneed }

private struct DynamicKey: CodingKey {
    var stringValue: String
    init?(stringValue: String) { self.stringValue = stringValue }
    var intValue: Int? { nil }
    init?(intValue: Int) { return nil }
}


struct DinnerStatus: Identifiable, Codable {
    @DocumentID var id: String? //groups/{groupId}/dinners/{yyyy-MM-dd}
    let groupId: UUID
    let day: Date
    var answers: [UUID : DinnerAnswer]
    
    enum CodingKeys: String, CodingKey { case id, groupId, day, answers }
    
    init(id: String? = nil, groupId: UUID, day: Date, answers: [UUID: DinnerAnswer]) {
        self.id = id
        self.groupId = groupId
        self.day = day
        self.answers = answers
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try c.decodeIfPresent(String.self, forKey: .id)  // 存在しない時はnilを返す
        self.groupId = try c.decode(UUID.self, forKey: .groupId)
        self.day = try c.decode(Date.self, forKey: .day)
        
        let nested = try c.nestedContainer(keyedBy: DynamicKey.self, forKey: .answers)  // keyedByの値はCodingKeyプロトコルに準拠する必要がある
        var map: [UUID: DinnerAnswer] = [:]
        for key in nested.allKeys {
            guard let uid = UUID(uuidString: key.stringValue) else { continue }
            let raw = try nested.decode(String.self, forKey: key)
            if let ans = DinnerAnswer(rawValue: raw) { map[uid] = ans }
        }
        self.answers = map
    }
    
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encodeIfPresent(id, forKey: .id)
        try c.encode(groupId, forKey: .groupId)
        try c.encode(day, forKey: .day)
        
        var nested = c.nestedContainer(keyedBy: DynamicKey.self, forKey: .answers)
        for (k, v) in answers {
            let dk = DynamicKey(stringValue: k.uuidString)!
            try nested.encode(v.rawValue, forKey: dk)
        }
    }
}
