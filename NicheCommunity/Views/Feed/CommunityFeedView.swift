//
//  CommunityFeedView.swift
//  NicheCommunity
//
//  커뮤니티 피드 메인 화면
//

import SwiftUI
import SwiftData

struct CommunityFeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 검색 바
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppColor.textSecondary)
                    TextField("채널 검색...", text: $viewModel.searchText)
                        .foregroundColor(AppColor.textPrimary)
                }
                .padding(12)
                .background(AppColor.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)

                // 태그 필터
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        Button {
                            viewModel.selectedTag = nil
                        } label: {
                            TagBadgeView(
                                tag: .gaming,
                                isSelected: viewModel.selectedTag == nil
                            )
                            .overlay(
                                Text("전체")
                                    .font(.caption)
                                    .foregroundColor(viewModel.selectedTag == nil ? AppColor.primary : AppColor.textSecondary)
                            )
                        }

                        ForEach(InterestTag.allCases) { tag in
                            Button {
                                viewModel.selectedTag = (viewModel.selectedTag == tag) ? nil : tag
                            } label: {
                                TagBadgeView(tag: tag, isSelected: viewModel.selectedTag == tag)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // 채널 목록
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.filteredChannels) { channel in
                        NavigationLink(destination: ChannelDetailView(channel: channel)) {
                            ChannelCardView(channel: channel) {
                                viewModel.toggleJoinChannel(channel)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(AppColor.background)
        .navigationTitle("커뮤니티")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            viewModel.setModelContext(modelContext)
            Task { await viewModel.loadChannels() }
        }
    }
}
