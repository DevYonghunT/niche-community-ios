import SwiftUI

// MARK: - 관심사 태그 열거형
/// 커뮤니티 채널의 관심사 분류 태그
enum InterestTag: String, CaseIterable, Identifiable, Codable, Hashable {
    case gaming
    case cooking
    case photography
    case fitness
    case music
    case reading
    case travel
    case pets
    case art
    case tech

    var id: String { rawValue }

    /// 한국어 표시 이름
    var displayName: String {
        switch self {
        case .gaming: return "게임"
        case .cooking: return "요리"
        case .photography: return "사진"
        case .fitness: return "피트니스"
        case .music: return "음악"
        case .reading: return "독서"
        case .travel: return "여행"
        case .pets: return "반려동물"
        case .art: return "예술"
        case .tech: return "테크"
        }
    }

    /// SF Symbol 아이콘 이름
    var iconName: String {
        switch self {
        case .gaming: return "gamecontroller.fill"
        case .cooking: return "fork.knife"
        case .photography: return "camera.fill"
        case .fitness: return "figure.run"
        case .music: return "music.note"
        case .reading: return "book.fill"
        case .travel: return "airplane"
        case .pets: return "pawprint.fill"
        case .art: return "paintpalette.fill"
        case .tech: return "desktopcomputer"
        }
    }

    /// 태그별 고유 색상
    var color: Color {
        switch self {
        case .gaming: return Color(hex: "#6C5CE7")
        case .cooking: return Color(hex: "#E17055")
        case .photography: return Color(hex: "#00B894")
        case .fitness: return Color(hex: "#FF6B6B")
        case .music: return Color(hex: "#A29BFE")
        case .reading: return Color(hex: "#FDCB6E")
        case .travel: return Color(hex: "#00CEC9")
        case .pets: return Color(hex: "#F8A5C2")
        case .art: return Color(hex: "#FD79A8")
        case .tech: return Color(hex: "#0984E3")
        }
    }
}
