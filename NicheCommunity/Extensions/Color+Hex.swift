import SwiftUI

// MARK: - Color 헥스 코드 확장
extension Color {
    /// 헥스 문자열로 Color 생성
    /// - Parameter hex: "#RRGGBB" 또는 "RRGGBB" 형식의 헥스 문자열
    init(hex: String) {
        let cleanedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")

        var rgbValue: UInt64 = 0
        Scanner(string: cleanedHex).scanHexInt64(&rgbValue)

        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}
