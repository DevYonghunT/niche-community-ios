//
//  GlowButtonStyle.swift
//  NicheCommunity
//
//  네온 글로우 버튼 스타일
//

import SwiftUI

struct GlowButtonStyle: ButtonStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(configuration.isPressed ? 0.3 : 0.2))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color, lineWidth: 1)
            )
            .shadow(color: color.opacity(0.4), radius: configuration.isPressed ? 2 : 8)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
