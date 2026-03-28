//
//  ProfileView.swift
//  NicheCommunity
//
//  프로필 화면
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 프로필 헤더
                VStack(spacing: 12) {
                    Circle()
                        .fill(AppColor.primary.opacity(0.2))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Text(String(viewModel.profile.displayName.prefix(1)))
                                .font(.title.bold())
                                .foregroundColor(AppColor.primary)
                        )

                    if viewModel.isEditing {
                        TextField("닉네임", text: $viewModel.profile.displayName)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 200)
                    } else {
                        Text(viewModel.profile.displayName)
                            .font(.title2.bold())
                            .foregroundColor(AppColor.textPrimary)
                    }

                    if viewModel.isEditing {
                        TextField("자기소개", text: $viewModel.profile.bio, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(2...4)
                            .frame(maxWidth: 300)
                    } else {
                        Text(viewModel.profile.bio)
                            .font(.subheadline)
                            .foregroundColor(AppColor.textSecondary)
                    }

                    Button {
                        if viewModel.isEditing {
                            viewModel.saveProfile()
                        }
                        viewModel.isEditing.toggle()
                    } label: {
                        Text(viewModel.isEditing ? "저장" : "프로필 수정")
                            .font(.caption.bold())
                    }
                    .buttonStyle(GlowButtonStyle(color: AppColor.primary))
                }
                .padding(.top)

                // 활동 통계
                HStack(spacing: 32) {
                    VStack {
                        Text("\(viewModel.profile.joinedChannelCount)")
                            .font(.title2.bold())
                            .foregroundColor(AppColor.primary)
                        Text("참여 채널")
                            .font(.caption)
                            .foregroundColor(AppColor.textSecondary)
                    }

                    VStack {
                        Text("\(viewModel.profile.postCount)")
                            .font(.title2.bold())
                            .foregroundColor(AppColor.secondary)
                        Text("작성 글")
                            .font(.caption)
                            .foregroundColor(AppColor.textSecondary)
                    }
                }

                // 관심사 태그
                VStack(alignment: .leading, spacing: 12) {
                    Text("관심사")
                        .font(.headline)
                        .foregroundColor(AppColor.textPrimary)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 8) {
                        ForEach(InterestTag.allCases) { tag in
                            Button {
                                viewModel.toggleInterest(tag)
                            } label: {
                                TagBadgeView(
                                    tag: tag,
                                    isSelected: viewModel.profile.interests.contains(tag)
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(AppColor.background)
        .navigationTitle("프로필")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear { viewModel.loadProfile() }
    }
}
