//
//  TagBadgeView.swift
//  NicheCommunity
//
//  관심사 태그 뱃지 뷰
//

import SwiftUI

/// 관심사 태그 뱃지
struct TagBadgeView: View {
    let tag: InterestTag
    var isSelected: Bool = false

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: tag.iconName)
                .font(.caption2)
            Text(tag.displayName)
                .font(.caption)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(isSelected ? tag.color.opacity(0.3) : AppColor.cardBackground)
        )
        .overlay(
            Capsule()
                .stroke(isSelected ? tag.color : Color.clear, lineWidth: 1)
        )
        .foregroundColor(isSelected ? tag.color : AppColor.textSecondary)
    }
}
