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
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: [Channel.self, Post.self, Comment.self])
    }
}
