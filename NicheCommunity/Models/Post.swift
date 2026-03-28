import Foundation
import SwiftData

// MARK: - 게시글 모델
/// 커뮤니티 게시글 데이터 모델 (SwiftData)
@Model
final class Post {
    /// 고유 식별자
    var id: UUID
    /// 소속 채널 ID
    var channelId: UUID
    /// 작성자 이름
    var authorName: String
    /// 게시글 본문
    var content: String
    /// 이미지 URL (선택)
    var imageURL: String?
    /// 좋아요 수
    var likeCount: Int
    /// 댓글 수
    var commentCount: Int
    /// 작성 일시
    var createdAt: Date
    /// 현재 사용자의 좋아요 여부
    var isLiked: Bool
    /// 신고 여부
    var isReported: Bool

    /// 게시글에 속한 댓글 목록 (cascade 삭제)
    @Relationship(deleteRule: .cascade)
    var comments: [Comment] = []

    /// 소속 채널
    var channel: Channel?

    init(
        id: UUID = UUID(),
        channelId: UUID,
        authorName: String,
        content: String,
        imageURL: String? = nil,
        likeCount: Int = 0,
        commentCount: Int = 0,
        createdAt: Date = Date(),
        isLiked: Bool = false,
        isReported: Bool = false
    ) {
        self.id = id
        self.channelId = channelId
        self.authorName = authorName
        self.content = content
        self.imageURL = imageURL
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.createdAt = createdAt
        self.isLiked = isLiked
        self.isReported = isReported
    }
}
