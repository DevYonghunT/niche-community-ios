import Foundation
import os
import SwiftUI
import SwiftData

/// 게시글 상세 화면의 뷰모델
/// 댓글 로드, 작성, 좋아요 기능을 관리한다
@MainActor
final class PostDetailViewModel: ObservableObject {

    // MARK: - Published 프로퍼티

    /// 현재 게시글 정보
    @Published var post: Post

    /// 댓글 목록
    @Published var comments: [Comment] = []

    /// 새 댓글 작성 텍스트
    @Published var newCommentText: String = ""

    /// 신고 알림 표시 여부
    @Published var showReportAlert: Bool = false

    // MARK: - 의존성

    /// SwiftData 모델 컨텍스트
    var modelContext: ModelContext?

    // MARK: - 초기화

    /// PostDetailViewModel 초기화
    /// - Parameter post: 표시할 게시글
    init(post: Post) {
        self.post = post
    }

    // MARK: - 메서드

    /// 모델 컨텍스트 설정
    /// - Parameter context: SwiftData 모델 컨텍스트
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }

    /// 댓글 목록을 비동기로 로드
    func loadComments() async {
        let service = MockCommunityService()
        do {
            let loadedComments = try await service.loadComments(for: post.id)
            self.comments = loadedComments
        } catch {
            Logger(subsystem: "com.entangle.nichecommunity", category: "PostDetail").error(" 댓글 로드 실패: \(error.localizedDescription)")
        }
    }

    /// 새 댓글 추가
    /// 입력 텍스트가 비어있으면 무시한다
    /// HTML 태그 제거
    private func stripHTMLTags(_ text: String) -> String {
        text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }

    func addComment() {
        let trimmed = stripHTMLTags(newCommentText.trimmingCharacters(in: .whitespacesAndNewlines))
        guard !trimmed.isEmpty else { return }
        guard trimmed.count <= 1000 else {
            Logger(subsystem: "com.entangle.nichecommunity", category: "PostDetail").error(" 댓글은 1000자 이내로 작성해주세요")
            return
        }

        let comment = Comment(
            postId: post.id,
            authorName: "나",
            content: trimmed
        )

        comments.append(comment)
        post.commentCount += 1
        newCommentText = ""

        // SwiftData 저장
        if let context = modelContext {
            context.insert(comment)
            do {
                try context.save()
            } catch {
                Logger(subsystem: "com.entangle.nichecommunity", category: "PostDetail").error(" 댓글 저장 실패: \(error.localizedDescription)")
            }
        }
    }

    /// 게시글 좋아요 토글
    func likePost() {
        if post.isLiked {
            post.isLiked = false
            post.likeCount -= 1
        } else {
            post.isLiked = true
            post.likeCount += 1
        }
    }

    /// 게시글 신고
    func reportPost() {
        post.isReported = true
        showReportAlert = true

        // SwiftData 저장
        if let context = modelContext {
            do {
                try context.save()
            } catch {
                Logger(subsystem: "com.entangle.nichecommunity", category: "PostDetail").error(" 게시글 신고 저장 실패: \(error.localizedDescription)")
            }
        }
    }

    /// 댓글 신고
    /// - Parameter comment: 신고할 댓글
    func reportComment(_ comment: Comment) {
        guard let index = comments.firstIndex(where: { $0.id == comment.id }) else {
            return
        }

        comments[index].isReported = true
        showReportAlert = true

        // SwiftData 저장
        if let context = modelContext {
            do {
                try context.save()
            } catch {
                Logger(subsystem: "com.entangle.nichecommunity", category: "PostDetail").error(" 댓글 신고 저장 실패: \(error.localizedDescription)")
            }
        }
    }

    /// 댓글 좋아요 토글
    /// - Parameter comment: 좋아요를 토글할 댓글
    func likeComment(_ comment: Comment) {
        guard let index = comments.firstIndex(where: { $0.id == comment.id }) else {
            return
        }

        comments[index].likeCount += 1
    }
}
