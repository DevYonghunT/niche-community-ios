import SwiftUI

// MARK: - 앱 전역 상수
enum AppConstants {
    /// 앱 이름
    static let appName: String = "Niche Community"
}

// MARK: - 앱 컬러 팔레트
enum AppColor {
    /// 주요 색상 (그린)
    static let primary = Color(hex: "#00B894")

    /// 보조 색상 (퍼플)
    static let secondary = Color(hex: "#6C5CE7")

    /// 강조 색상 (옐로우)
    static let accent = Color(hex: "#FDCB6E")

    /// 배경 색상 (다크)
    static let background = Color(hex: "#0A0A0A")

    /// 보조 배경 색상
    static let secondaryBackground = Color(hex: "#1A1A1A")

    /// 카드 배경 색상
    static let cardBackground = Color(hex: "#2D2D2D")

    /// 주요 텍스트 색상
    static let textPrimary = Color.white

    /// 보조 텍스트 색상
    static let textSecondary = Color(hex: "#A0A0A0")
}
