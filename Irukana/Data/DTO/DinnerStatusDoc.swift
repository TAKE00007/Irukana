//
//  DinnerStatusDoc.swift
//  Irukana
//
//  Created by 大竹駿 on 2025/11/02.
//

import FirebaseFirestore

struct DinnerStatusDoc: Codable {
    @DocumentID var id: String? // {groupId}_{yyyy-MM-dd}
    let groupId: String
    let day: Timestamp
    var answers: [String : String]
}

extension DinnerStatusDoc {
    func toDomain() -> DinnerStatus? {
        
        guard let gid = UUID(uuidString: groupId) else { return nil }
        
        let mappedAnswers: [UUID: DinnerAnswer] = Dictionary(
            uniqueKeysWithValues: answers.compactMap{ (key, value) in
                guard let uid = UUID(uuidString: key), let ans = DinnerAnswer(rawValue: value) else { return nil }
                return (uid, ans)
            }
        )
        return DinnerStatus(
            id: id,
            groupId: gid,
            day: day.dateValue(),
            answers: mappedAnswers
        )
    }
}

extension DinnerStatus {
    func toDoc(id: String?) -> DinnerStatusDoc {
        let gid = groupId.uuidString
        
        let mappedAnswers: [String: String] = Dictionary(
            uniqueKeysWithValues: answers.map { (key, value) in
                (key.uuidString, value.rawValue)
            }
        )
        
        return DinnerStatusDoc(
            id: id,
            groupId: gid,
            day: Timestamp(date: day),
            answers: mappedAnswers
        )
    }
}
