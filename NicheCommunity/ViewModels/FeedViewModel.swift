import Foundation
import os
import SwiftUI
import SwiftData

/// 피드 화면의 뷰모델
/// 채널 목록 로드, 필터링, 가입/탈퇴 기능을 관리한다
@MainActor
final class FeedViewModel: ObservableObject {

    // MARK: - Published 프로퍼티

    /// 전체 채널 목록
    @Published var channels: [Channel] = []

    /// 선택된 관심 태그 필터
    @Published var selectedTag: InterestTag?

    /// 검색 텍스트
    @Published var searchText: String = ""

    // MARK: - 의존성

    /// 프리미엄 서비스 (가입 제한 확인용)
    var premiumService: PremiumService?

    /// SwiftData 모델 컨텍스트
    var modelContext: ModelContext?

    // MARK: - 계산 프로퍼티

    /// 가입한 채널만 필터링
    var joinedChannels: [Channel] {
        channels.filter { $0.isJoined }
    }

    /// 태그 및 검색어로 필터링된 채널 목록
    var filteredChannels: [Channel] {
        var result = channels

        // 태그 필터 적용
        if let tag = selectedTag {
            result = result.filter { $0.tag == tag }
        }

        // 검색어 필터 적용
        if !searchText.isEmpty {
            let query = searchText.lowercased()
            result = result.filter {
                $0.name.lowercased().contains(query) ||
                $0.descriptionText.lowercased().contains(query)
            }
        }

        return result
    }

    // MARK: - 초기화

    /// FeedViewModel 초기화
    /// - Parameter premiumService: 프리미엄 상태 확인 서비스
    init() {}

    // MARK: - 메서드

    /// 모델 컨텍스트 설정
    /// - Parameter context: SwiftData 모델 컨텍스트
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }

    /// 채널 목록을 비동기로 로드
    func loadChannels() async {
        let service = MockCommunityService()
        do {
            let loadedChannels = try await service.loadChannels()
            self.channels = loadedChannels
        } catch {
            // 로드 실패 시 빈 배열 유지
            Logger(subsystem: "com.entangle.nichecommunity", category: "Feed").error(" 채널 로드 실패: \(error.localizedDescription)")
        }
    }

    /// 채널 가입/탈퇴 토글
    /// 무료 사용자는 가입 채널 수 제한이 있다
    /// - Parameter channel: 토글할 채널
    func toggleJoinChannel(_ channel: Channel) {
        guard let index = channels.firstIndex(where: { $0.id == channel.id }) else {
            return
        }

        // 이미 가입된 채널이면 탈퇴 처리
        if channels[index].isJoined {
            channels[index].isJoined = false
            return
        }

        // 가입 시 프리미엄 상태에 따른 채널 수 제한 확인
        let currentJoinedCount = joinedChannels.count
        let status = premiumService?.premiumStatus ?? PremiumStatus(isActive: false)
        guard status.canJoinMoreChannels(currentCount: currentJoinedCount) else {
            // 무료 사용자 채널 가입 제한 초과
            Logger(subsystem: "com.entangle.nichecommunity", category: "Feed").error(" 채널 가입 제한 초과 (현재: \(currentJoinedCount)개)")
            return
        }

        channels[index].isJoined = true
    }
}
