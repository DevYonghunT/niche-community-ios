//
//  PostCardView.swift
//  NicheCommunity
//
//  게시글 카드 뷰
//

import SwiftUI

struct PostCardView: View {
    let post: Post
    let onLike: () -> Void
    /// 신고 콜백
    var onReport: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 작성자 + 시간
            HStack {
                Circle()
                    .fill(AppColor.secondary.opacity(0.3))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Text(String(post.authorName.prefix(1)))
                            .font(.caption.bold())
                            .foregroundColor(AppColor.secondary)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(post.authorName)
                        .font(.subheadline.bold())
                        .foregroundColor(AppColor.textPrimary)

                    Text(post.createdAt.timeAgoString)
                        .font(.caption2)
                        .foregroundColor(AppColor.textSecondary)
                }

                Spacer()
            }

            // 내용
            Text(post.content)
                .font(.body)
                .foregroundColor(AppColor.textPrimary)
                .lineLimit(4)

            // 액션 바
            HStack(spacing: 20) {
                Button(action: onLike) {
                    Label("\(post.likeCount)", systemImage: post.isLiked ? "heart.fill" : "heart")
                        .foregroundColor(post.isLiked ? AppColor.accent : AppColor.textSecondary)
                }

                Label("\(post.commentCount)", systemImage: "bubble.right")
                    .foregroundColor(AppColor.textSecondary)

                Spacer()
            }
            .font(.caption)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(AppColor.cardBackground)
        )
        .contextMenu {
            // 신고 메뉴
            Button(role: .destructive) {
                onReport()
            } label: {
                Label("신고", systemImage: "exclamationmark.triangle")
            }
        }
    }
}
