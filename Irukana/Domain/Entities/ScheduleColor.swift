import SwiftUI

enum ScheduleColor: String, CaseIterable,Identifiable, Codable {
    case green
    case blue
    case brown
    case red
    case orange
    
    public var id: String { rawValue }
    
    public var name: String {
        switch self {
        case .green:
            return "グリーン"
        case .blue:
            return "ブルー"
        case .brown:
            return "ブラウン"
        case .red:
            return "レッド"
        case .orange:
            return "オレンジ"
        }
    }
}
