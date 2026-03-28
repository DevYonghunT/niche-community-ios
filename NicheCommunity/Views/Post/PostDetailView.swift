//
//  PostDetailView.swift
//  NicheCommunity
//
//  게시글 상세 화면 — 댓글 목록 + 댓글 작성
//

import SwiftUI
import SwiftData

struct PostDetailView: View {
    let post: Post
    @StateObject private var viewModel: PostDetailViewModel
    @Environment(\.modelContext) private var modelContext

    init(post: Post) {
        self.post = post
        _viewModel = StateObject(wrappedValue: PostDetailViewModel(post: post))
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // 게시글 본문
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Circle()
                                .fill(AppColor.secondary.opacity(0.3))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Text(String(viewModel.post.authorName.prefix(1)))
                                        .font(.caption.bold())
                                        .foregroundColor(AppColor.secondary)
                                )

                            VStack(alignment: .leading) {
                                Text(viewModel.post.authorName)
                                    .font(.headline)
                                    .foregroundColor(AppColor.textPrimary)
                                Text(viewModel.post.createdAt.timeAgoString)
                                    .font(.caption)
                                    .foregroundColor(AppColor.textSecondary)
                            }
                        }

                        Text(viewModel.post.content)
                            .font(.body)
                            .foregroundColor(AppColor.textPrimary)

                        // 좋아요 버튼
                        HStack(spacing: 20) {
                            Button { viewModel.likePost() } label: {
                                Label("\(viewModel.post.likeCount)",
                                      systemImage: viewModel.post.isLiked ? "heart.fill" : "heart")
                                    .foregroundColor(viewModel.post.isLiked ? AppColor.accent : AppColor.textSecondary)
                            }

                            Label("\(viewModel.comments.count)", systemImage: "bubble.right")
                                .foregroundColor(AppColor.textSecondary)
                        }
                        .font(.subheadline)
                    }
                    .padding()
                    .background(AppColor.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    // 댓글 헤더
                    Text("댓글 \(viewModel.comments.count)개")
                        .font(.headline)
                        .foregroundColor(AppColor.textPrimary)

                    // 댓글 목록
                    ForEach(viewModel.comments) { comment in
                        CommentRowView(comment: comment, onLike: {
                            viewModel.likeComment(comment)
                        }, onReport: {
                            viewModel.reportComment(comment)
                        })
                    }
                }
                .padding()
            }

            // 댓글 입력
            HStack(spacing: 12) {
                TextField("댓글을 입력하세요...", text: $viewModel.newCommentText)
                    .textFieldStyle(.plain)
                    .foregroundColor(AppColor.textPrimary)
                    .padding(10)
                    .background(AppColor.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Button {
                    viewModel.addComment()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(
                            viewModel.newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            ? AppColor.textSecondary : AppColor.primary
                        )
                }
                .disabled(viewModel.newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
            .background(AppColor.secondaryBackground)
        }
        .background(AppColor.background)
        .navigationTitle("게시글")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                // 게시글 신고 버튼
                Button(role: .destructive) {
                    viewModel.reportPost()
                } label: {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(AppColor.textSecondary)
                }
            }
        }
        .alert("신고 완료", isPresented: $viewModel.showReportAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text("신고가 접수되었습니다. 검토 후 조치하겠습니다.")
        }
        .onAppear {
            viewModel.setModelContext(modelContext)
            Task { await viewModel.loadComments() }
        }
    }
}
