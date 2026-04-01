//
//  MainTabView.swift
//  NicheCommunity
//
//  메인 탭 네비게이션
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                CommunityFeedView()
            }
            .tabItem {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                Text("커뮤니티")
            }

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("프로필")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gearshape.fill")
                Text("설정")
            }
        }
        .tint(AppColor.primary)
    }
}
