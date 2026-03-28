//
//  ChannelCardView.swift
//  NicheCommunity
//
//  채널 카드 뷰
//

import SwiftUI

struct ChannelCardView: View {
    let channel: Channel
    let onToggleJoin: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                // 태그 아이콘
                Circle()
                    .fill(channel.tag.color.opacity(0.2))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: channel.tag.iconName)
                            .foregroundColor(channel.tag.color)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(channel.name)
                        .font(.headline)
                        .foregroundColor(AppColor.textPrimary)

                    Text(channel.tag.displayName)
                        .font(.caption)
                        .foregroundColor(channel.tag.color)
                }

                Spacer()

                // 참여 버튼
                Button(action: onToggleJoin) {
                    Text(channel.isJoined ? "참여중" : "참여")
                        .font(.caption.bold())
                        .foregroundColor(channel.isJoined ? AppColor.textSecondary : .white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(channel.isJoined ? AppColor.cardBackground : AppColor.primary)
                        )
                }
            }

            Text(channel.descriptionText)
                .font(.subheadline)
                .foregroundColor(AppColor.textSecondary)
                .lineLimit(2)

            HStack(spacing: 16) {
                Label("\(channel.memberCount)", systemImage: "person.2.fill")
                Label("\(channel.postCount)", systemImage: "text.bubble.fill")
            }
            .font(.caption)
            .foregroundColor(AppColor.textSecondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColor.cardBackground)
        )
    }
}
