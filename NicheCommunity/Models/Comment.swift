import Foundation
import SwiftData

// MARK: - 댓글 모델
/// 게시글 댓글 데이터 모델 (SwiftData)
@Model
final class Comment {
    /// 고유 식별자
    var id: UUID
    /// 소속 게시글 ID
    var postId: UUID
    /// 작성자 이름
    var authorName: String
    /// 댓글 내용
    var content: String
    /// 좋아요 수
    var likeCount: Int
    /// 작성 일시
    var createdAt: Date
    /// 신고 여부
    var isReported: Bool

    /// 소속 게시글
    var post: Post?

    init(
        id: UUID = UUID(),
        postId: UUID,
        authorName: String,
        content: String,
        likeCount: Int = 0,
        createdAt: Date = Date(),
        isReported: Bool = false
    ) {
        self.id = id
        self.postId = postId
        self.authorName = authorName
        self.content = content
        self.likeCount = likeCount
        self.createdAt = createdAt
        self.isReported = isReported
    }
}
