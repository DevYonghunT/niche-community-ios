//
//  SettingsView.swift
//  NicheCommunity
//
//  설정 화면
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var premiumService: PremiumService
    @State private var showPremium = false

    var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()

            List {
                // 프리미엄 섹션
                Section {
                    Button { showPremium = true } label: {
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundColor(AppColor.accent)
                            VStack(alignment: .leading) {
                                Text(premiumService.premiumStatus.isActive ? "프리미엄 활성화됨" : "프리미엄 업그레이드")
                                    .foregroundColor(AppColor.textPrimary)
                                Text("광고 제거 + 프리미엄 채널 접근")
                                    .font(.caption)
                                    .foregroundColor(AppColor.textSecondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(AppColor.textSecondary)
                        }
                    }
                } header: {
                    Text("구독")
                        .foregroundColor(AppColor.textSecondary)
                }
                .listRowBackground(AppColor.cardBackground)

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
        .sheet(isPresented: $showPremium) {
            PremiumView()
        }
    }
}
