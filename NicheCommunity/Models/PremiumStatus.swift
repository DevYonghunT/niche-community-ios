import Foundation

// MARK: - 프리미엄 상태 모델
/// 사용자의 프리미엄 구독 상태 정보
struct PremiumStatus {
    /// 프리미엄 활성화 여부
    var isActive: Bool

    /// 추가 채널 참여 가능 여부 확인
    /// - Parameter currentCount: 현재 참여 중인 채널 수
    /// - Returns: 참여 가능하면 true
    func canJoinMoreChannels(currentCount: Int) -> Bool {
        if isActive {
            return true
        }
        return currentCount < AppConstants.freeChannelLimit
    }

    /// 광고 제거 가능 여부
    var canRemoveAds: Bool {
        return isActive
    }

    /// 프리미엄 전용 채널 접근 가능 여부
    var canAccessPremiumChannels: Bool {
        return isActive
    }
}
