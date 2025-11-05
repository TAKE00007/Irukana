//
//  DinnerStatusSD.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/11/03.
//

import Foundation
import SwiftData

@Model
final class DinnerStatusSD {
    @Attribute(.unique) var compositeId: String  // {groupId}_{yyyy-MM-dd}
    var groupId: String
    var date: Date
    var answerData: Data // [UUID: DinnerAnswer]
    
    init(compositeId: String, groupId: String, date: Date, answerData: Data) {
        self.compositeId = compositeId
        self.groupId = groupId
        self.date = date
        self.answerData = answerData
    }
}

enum AnswerCodec {
    static func encode(_ dict: [UUID: DinnerAnswer]) -> Data {
        let mapped = dict.mapKeys(\.uuidString).mapValues(\.rawValue)
        let encoder = JSONEncoder()
        return (try? encoder.encode(mapped)) ?? Data()
    }
    
    static func decode(_ data: Data) -> [UUID: DinnerAnswer] {
        let decoder = JSONDecoder()
        guard let mapped = try? decoder.decode([String: String].self, from: data) else {
            return [:]
        }
        
        return Dictionary(uniqueKeysWithValues: mapped.compactMap { (key, value) in
            guard let uid = UUID(uuidString: key), let ans = DinnerAnswer(rawValue: value) else { return nil }
            return (uid, ans)
        })
    }
}

extension DinnerStatusSD {
    func toDomain() -> DinnerStatus? {
        guard let gid = UUID(uuidString: groupId) else { return nil }
        let answers = AnswerCodec.decode(answerData)
        
        return DinnerStatus(
            id: compositeId,
            groupId: gid,
            day: date,
            answers: answers
        )
    }
}

extension DinnerStatus {
    func toSwiftData(id: String? = nil) -> DinnerStatusSD {
        let encoded = AnswerCodec.encode(answers)
        let compositeId = id ?? "\(groupId.uuidString)_\(FormatterStore.startOfDay(day).formatted(FormatterStore.yyyyMMddDashStyle))"
        let dinnerStatusSD = DinnerStatusSD(compositeId: compositeId, groupId: groupId.uuidString, date: day, answerData: encoded)

        return dinnerStatusSD
    }
}

extension Dictionary {
    func mapKeys<T>(_ transform: (Key) -> T) -> [T: Value] {
        Dictionary<T, Value>(uniqueKeysWithValues: self.map { (transform($0.key), $0.value) })
    }
}
