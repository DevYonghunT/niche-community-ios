//
//  NicheCommunityApp.swift
//  NicheCommunity
//
//  메인 앱 진입점
//

import SwiftUI
import SwiftData

@main
struct NicheCommunityApp: App {
    @StateObject private var premiumService = PremiumService()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(premiumService)
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: [Channel.self, Post.self, Comment.self])
    }
}
