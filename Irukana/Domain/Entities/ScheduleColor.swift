import SwiftUI

enum ScheduleColor: String, CaseIterable,Identifiable {
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
    
    public var color: Color {
        switch self {
        case .green:
            return Color.green
        case .blue:
            return Color.blue
        case .brown:
            return Color.brown
        case .red:
            return Color.red
        case .orange:
            return Color.orange
        }
    }
}
