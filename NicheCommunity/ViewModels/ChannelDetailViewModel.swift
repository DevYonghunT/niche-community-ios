import Foundation
import os
import SwiftUI
import SwiftData

/// 채널 상세 화면의 뷰모델
/// 채널 내 게시글 목록 로드, 게시글 작성, 좋아요 기능을 관리한다
@MainActor
final class ChannelDetailViewModel: ObservableObject {

    // MARK: - Published 프로퍼티

    /// 현재 채널 정보
    @Published var channel: Channel

    /// 채널 내 게시글 목록
    @Published var posts: [Post] = []

    /// 새 게시글 작성 텍스트
    @Published var newPostText: String = ""

    // MARK: - 의존성

    /// SwiftData 모델 컨텍스트
    var modelContext: ModelContext?

    // MARK: - 초기화

    /// ChannelDetailViewModel 초기화
    /// - Parameter channel: 표시할 채널
    init(channel: Channel) {
        self.channel = channel
    }

    // MARK: - 메서드

    /// 모델 컨텍스트 설정
    /// - Parameter context: SwiftData 모델 컨텍스트
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }

    /// 채널의 게시글 목록을 비동기로 로드
    func loadPosts() async {
        let service = MockCommunityService()
        do {
            let loadedPosts = try await service.loadPosts(for: channel.id)
            self.posts = loadedPosts
        } catch {
            Logger(subsystem: "com.entangle.nichecommunity", category: "ChannelDetail").error(" 게시글 로드 실패: \(error.localizedDescription)")
        }
    }

    /// 새 게시글 작성
    /// 입력 텍스트가 비어있으면 무시한다
    /// HTML 태그 제거
    private func stripHTMLTags(_ text: String) -> String {
        text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }

    func createPost() {
        let trimmed = stripHTMLTags(newPostText.trimmingCharacters(in: .whitespacesAndNewlines))
        guard !trimmed.isEmpty else { return }
        guard trimmed.count <= 1000 else {
            Logger(subsystem: "com.entangle.nichecommunity", category: "ChannelDetail").error(" 게시글은 1000자 이내로 작성해주세요")
            return
        }

        let post = Post(
            channelId: channel.id,
            authorName: "나",
            content: trimmed
        )

        posts.insert(post, at: 0)
        channel.postCount += 1
        newPostText = ""

        // SwiftData 저장
        if let context = modelContext {
            context.insert(post)
            do {
                try context.save()
            } catch {
                Logger(subsystem: "com.entangle.nichecommunity", category: "ChannelDetail").error(" 게시글 저장 실패: \(error.localizedDescription)")
            }
        }
    }

    /// 게시글 신고
    /// - Parameter post: 신고할 게시글
    func reportPost(_ post: Post) {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else {
            return
        }

        posts[index].isReported = true

        // SwiftData 저장
        if let context = modelContext {
            do {
                try context.save()
            } catch {
                Logger(subsystem: "com.entangle.nichecommunity", category: "ChannelDetail").error(" 게시글 신고 저장 실패: \(error.localizedDescription)")
            }
        }
    }

    /// 게시글 좋아요 토글
    /// - Parameter post: 좋아요를 토글할 게시글
    func likePost(_ post: Post) {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else {
            return
        }

        if posts[index].isLiked {
            posts[index].isLiked = false
            posts[index].likeCount -= 1
        } else {
            posts[index].isLiked = true
            posts[index].likeCount += 1
        }
    }
}
