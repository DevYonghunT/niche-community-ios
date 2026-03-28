import Foundation

// MARK: - 사용자 프로필 모델
/// UserDefaults에 저장되는 사용자 프로필 정보
struct UserProfile: Codable {
    /// 표시 이름
    var displayName: String
    /// 자기소개
    var bio: String
    /// 참여 중인 채널 수
    var joinedChannelCount: Int
    /// 작성한 게시글 수
    var postCount: Int
    /// 관심사 목록
    var interests: [InterestTag]

    /// UserDefaults 저장 키
    private static let storageKey = "userProfile"

    /// UserDefaults에서 프로필 로드
    /// - Returns: 저장된 프로필 또는 기본값
    static func load() -> UserProfile {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let profile = try? JSONDecoder().decode(UserProfile.self, from: data) else {
            // 기본 프로필 반환
            return UserProfile(
                displayName: "새 사용자",
                bio: "",
                joinedChannelCount: 0,
                postCount: 0,
                interests: []
            )
        }
        return profile
    }

    /// 현재 프로필을 UserDefaults에 저장
    func save() {
        guard let data = try? JSONEncoder().encode(self) else { return }
        UserDefaults.standard.set(data, forKey: UserProfile.storageKey)
    }
}
