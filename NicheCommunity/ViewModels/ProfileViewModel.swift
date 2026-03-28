import Foundation
import os
import SwiftUI

/// 프로필 화면의 뷰모델
/// 사용자 프로필 조회, 수정, 관심사 관리를 담당한다
@MainActor
final class ProfileViewModel: ObservableObject {

    // MARK: - Published 프로퍼티

    /// 사용자 프로필 정보
    @Published var profile: UserProfile

    /// 편집 모드 여부
    @Published var isEditing: Bool = false

    // MARK: - 상수

    /// UserDefaults 저장 키
    private let profileStorageKey = "userProfile"

    // MARK: - 초기화

    /// ProfileViewModel 초기화
    /// 기본 프로필로 시작한다
    init() {
        self.profile = UserProfile(
            displayName: "새 사용자",
            bio: "",
            joinedChannelCount: 0,
            postCount: 0,
            interests: []
        )
    }

    // MARK: - 메서드

    /// 저장된 프로필을 로드
    /// UserDefaults에서 프로필 데이터를 불러온다
    func loadProfile() {
        guard let data = UserDefaults.standard.data(forKey: profileStorageKey) else {
            return
        }

        do {
            let decoded = try JSONDecoder().decode(UserProfile.self, from: data)
            self.profile = decoded
        } catch {
            Logger(subsystem: "com.entangle.nichecommunity", category: "Profile").error(" 프로필 로드 실패: \(error.localizedDescription)")
        }
    }

    /// HTML 태그 제거
    private func stripHTMLTags(_ text: String) -> String {
        text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }

    /// 현재 프로필을 저장
    /// UserDefaults에 프로필 데이터를 저장한다
    func saveProfile() {
        // UGC 보호: displayName, bio에서 HTML 태그 제거
        profile.displayName = stripHTMLTags(profile.displayName.trimmingCharacters(in: .whitespacesAndNewlines))
        profile.bio = stripHTMLTags(profile.bio.trimmingCharacters(in: .whitespacesAndNewlines))

        do {
            let data = try JSONEncoder().encode(profile)
            UserDefaults.standard.set(data, forKey: profileStorageKey)
            isEditing = false
        } catch {
            Logger(subsystem: "com.entangle.nichecommunity", category: "Profile").error(" 프로필 저장 실패: \(error.localizedDescription)")
        }
    }

    /// 관심 태그 토글
    /// 이미 선택된 태그면 제거하고, 아니면 추가한다
    /// - Parameter tag: 토글할 관심 태그
    func toggleInterest(_ tag: InterestTag) {
        if let index = profile.interests.firstIndex(of: tag) {
            profile.interests.remove(at: index)
        } else {
            profile.interests.append(tag)
        }
    }
}
