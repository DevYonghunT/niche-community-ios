//
//  PremiumView.swift
//  NicheCommunity
//
//  프리미엄 구독 화면
//

import SwiftUI

struct PremiumView: View {
    @EnvironmentObject var premiumService: PremiumService
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                AppColor.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 32) {
                        // 헤더
                        VStack(spacing: 12) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [AppColor.accent, AppColor.primary],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )

                            Text("Community Pro")
                                .font(.title.bold())
                                .foregroundColor(AppColor.textPrimary)
                        }
                        .padding(.top, 32)

                        // 혜택
                        VStack(alignment: .leading, spacing: 16) {
                            benefitRow(icon: "nosign", text: "광고 완전 제거", color: AppColor.primary)
                            benefitRow(icon: "star.fill", text: "프리미엄 채널 접근", color: AppColor.secondary)
                            benefitRow(icon: "infinity", text: "무제한 채널 참여", color: AppColor.accent)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(AppColor.cardBackground))
                        .padding(.horizontal)

                        // 가격
                        VStack(spacing: 4) {
                            Text(AppConstants.premiumMonthlyPrice)
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(AppColor.textPrimary)
                            Text("/ 월")
                                .foregroundColor(AppColor.textSecondary)
                        }

                        // 구매 버튼
                        Button {
                            Task {
                                guard let product = premiumService.products.first else { return }
                                await premiumService.purchase(product)
                            }
                        } label: {
                            Text("프리미엄 시작하기")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        colors: [AppColor.primary, AppColor.secondary],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .padding(.horizontal, 32)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("닫기") { dismiss() }
                        .foregroundColor(AppColor.primary)
                }
            }
        }
    }

    private func benefitRow(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 32)
            Text(text)
                .foregroundColor(AppColor.textPrimary)
        }
    }
}
