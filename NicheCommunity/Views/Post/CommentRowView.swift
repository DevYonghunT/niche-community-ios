//
//  CommentRowView.swift
//  NicheCommunity
//
//  댓글 행 뷰
//

import SwiftUI

struct CommentRowView: View {
    let comment: Comment
    let onLike: () -> Void
    /// 신고 콜백
    var onReport: () -> Void = {}

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            // 아바타
            Circle()
                .fill(AppColor.primary.opacity(0.2))
                .frame(width: 28, height: 28)
                .overlay(
                    Text(String(comment.authorName.prefix(1)))
                        .font(.caption2.bold())
                        .foregroundColor(AppColor.primary)
                )

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(comment.authorName)
                        .font(.caption.bold())
                        .foregroundColor(AppColor.textPrimary)

                    Text(comment.createdAt.timeAgoString)
                        .font(.caption2)
                        .foregroundColor(AppColor.textSecondary)
                }

                Text(comment.content)
                    .font(.subheadline)
                    .foregroundColor(AppColor.textPrimary)

                Button(action: onLike) {
                    Label("\(comment.likeCount)", systemImage: "heart")
                        .font(.caption2)
                        .foregroundColor(AppColor.textSecondary)
                }
            }

            Spacer()
        }
        .padding(.vertical, 6)
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
