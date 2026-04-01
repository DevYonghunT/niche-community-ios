import Foundation

// MARK: - 프리미엄 상태 모델 — 모든 기능 무료 해제
struct PremiumStatus {
    /// 프리미엄 활성화 여부 (항상 true)
    var isActive: Bool = true

    /// 추가 채널 참여 가능 여부 — 항상 허용
    func canJoinMoreChannels(currentCount: Int) -> Bool {
        return true
    }

    /// 광고 제거 가능 여부 — 항상 허용
    var canRemoveAds: Bool {
        return true
    }

    /// 프리미엄 전용 채널 접근 가능 여부 — 항상 허용
    var canAccessPremiumChannels: Bool {
        return true
    }
}
