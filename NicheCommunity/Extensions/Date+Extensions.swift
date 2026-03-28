import Foundation

// MARK: - Date 유틸리티 확장
extension Date {
    /// 현재 시각 기준 상대 시간 문자열 반환 ("방금 전", "3분 전", "2시간 전" 등)
    var timeAgoString: String {
        let now = Date()
        let interval = now.timeIntervalSince(self)

        // 미래 시간인 경우
        if interval < 0 {
            return "방금 전"
        }

        let seconds = Int(interval)
        let minutes = seconds / 60
        let hours = minutes / 60
        let days = hours / 24
        let weeks = days / 7
        let months = days / 30
        let years = days / 365

        if seconds < 60 {
            return "방금 전"
        } else if minutes < 60 {
            return "\(minutes)분 전"
        } else if hours < 24 {
            return "\(hours)시간 전"
        } else if days < 7 {
            return "\(days)일 전"
        } else if weeks < 4 {
            return "\(weeks)주 전"
        } else if months < 12 {
            return "\(months)개월 전"
        } else {
            return "\(years)년 전"
        }
    }

    /// 간단한 날짜 문자열 (예: "3월 25일")
    var dateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        return formatter.string(from: self)
    }

    /// 전체 날짜 문자열 (예: "2026년 3월 25일")
    var fullDateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: self)
    }
}
