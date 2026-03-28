import Foundation
import SwiftData

// MARK: - 채널 모델
/// 커뮤니티 채널 데이터 모델 (SwiftData)
@Model
final class Channel {
    /// 고유 식별자
    var id: UUID
    /// 채널 이름
    var name: String
    /// 채널 설명
    var descriptionText: String
    /// 관심사 태그 원시값 (InterestTag.rawValue)
    var tagRawValue: String
    /// 멤버 수
    var memberCount: Int
    /// 게시글 수
    var postCount: Int
    /// 생성 일시
    var createdAt: Date
    /// 현재 사용자의 참여 여부
    var isJoined: Bool

    /// 채널에 속한 게시글 목록 (cascade 삭제)
    @Relationship(deleteRule: .cascade)
    var posts: [Post] = []

    /// 관심사 태그 (tagRawValue 기반 계산 프로퍼티)
    var tag: InterestTag {
        get { InterestTag(rawValue: tagRawValue) ?? .tech }
        set { tagRawValue = newValue.rawValue }
    }

    init(
        id: UUID = UUID(),
        name: String,
        descriptionText: String,
        tag: InterestTag,
        memberCount: Int = 0,
        postCount: Int = 0,
        createdAt: Date = Date(),
        isJoined: Bool = false
    ) {
        self.id = id
        self.name = name
        self.descriptionText = descriptionText
        self.tagRawValue = tag.rawValue
        self.memberCount = memberCount
        self.postCount = postCount
        self.createdAt = createdAt
        self.isJoined = isJoined
    }
}
