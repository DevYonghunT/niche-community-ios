//
//  ChannelDetailView.swift
//  NicheCommunity
//
//  채널 상세 화면 — 게시글 목록 + 새 글 작성
//

import SwiftUI
import SwiftData

struct ChannelDetailView: View {
    let channel: Channel
    @StateObject private var viewModel: ChannelDetailViewModel
    @Environment(\.modelContext) private var modelContext

    init(channel: Channel) {
        self.channel = channel
        _viewModel = StateObject(wrappedValue: ChannelDetailViewModel(channel: channel))
    }

    var body: some View {
        VStack(spacing: 0) {
            // 채널 헤더
            channelHeader

            // 게시글 목록
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.posts) { post in
                        NavigationLink(destination: PostDetailView(post: post)) {
                            PostCardView(post: post, onLike: {
                                viewModel.likePost(post)
                            }, onReport: {
                                viewModel.reportPost(post)
                            })
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }

            // 새 글 입력
            newPostBar
        }
        .background(AppColor.background)
        .navigationTitle(channel.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            viewModel.setModelContext(modelContext)
            Task { await viewModel.loadPosts() }
        }
    }

    /// 채널 헤더
    private var channelHeader: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: channel.tag.iconName)
                    .foregroundColor(channel.tag.color)
                Text(channel.descriptionText)
                    .font(.subheadline)
                    .foregroundColor(AppColor.textSecondary)
            }

            HStack(spacing: 16) {
                Label("\(channel.memberCount)명", systemImage: "person.2")
                Label("\(channel.postCount)개 글", systemImage: "text.bubble")
            }
            .font(.caption)
            .foregroundColor(AppColor.textSecondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(AppColor.secondaryBackground)
    }

    /// 새 글 입력 바
    private var newPostBar: some View {
        HStack(spacing: 12) {
            TextField("글을 작성하세요...", text: $viewModel.newPostText, axis: .vertical)
                .textFieldStyle(.plain)
                .foregroundColor(AppColor.textPrimary)
                .padding(10)
                .background(AppColor.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .lineLimit(1...3)

            Button {
                viewModel.createPost()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(
                        viewModel.newPostText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        ? AppColor.textSecondary : AppColor.primary
                    )
            }
            .disabled(viewModel.newPostText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
        .background(AppColor.secondaryBackground)
    }
}
