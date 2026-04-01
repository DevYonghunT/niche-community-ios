//
//  SettingsView.swift
//  NicheCommunity
//
//  설정 화면
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()

            List {
                // 정보 섹션
                Section {
                    HStack {
                        Text("앱 버전")
                            .foregroundColor(AppColor.textPrimary)
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                            .foregroundColor(AppColor.textSecondary)
                    }
                    HStack {
                        Text("제작")
                            .foregroundColor(AppColor.textPrimary)
                        Spacer()
                        Text("Team Entangle")
                            .foregroundColor(AppColor.textSecondary)
                    }
                } header: {
                    Text("정보")
                        .foregroundColor(AppColor.textSecondary)
                }
                .listRowBackground(AppColor.cardBackground)
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("설정")
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
