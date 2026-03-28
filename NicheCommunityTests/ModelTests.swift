// ModelTests.swift
// InterestTag, PremiumStatus, UserProfile, Date+Extensions 테스트

import XCTest
@testable import NicheCommunity

final class ModelTests: XCTestCase {

    // MARK: - νₑ 정상 경로 — InterestTag

    func test_interestTag_allCases_hasTen() {
        XCTAssertEqual(InterestTag.allCases.count, 10)
    }

    func test_interestTag_displayNames_korean() {
        XCTAssertFalse(InterestTag.gaming.displayName.isEmpty)
        XCTAssertFalse(InterestTag.cooking.displayName.isEmpty)
        XCTAssertFalse(InterestTag.tech.displayName.isEmpty)
    }

    func test_interestTag_iconNames_notEmpty() {
        for tag in InterestTag.allCases {
            XCTAssertFalse(tag.iconName.isEmpty, "\(tag) 아이콘 비어있음")
        }
    }

    // MARK: - νₑ 정상 경로 — PremiumStatus

    func test_premiumStatus_canJoinMoreChannels_freeUnderLimit() {
        let status = PremiumStatus(isActive: false)
        XCTAssertTrue(status.canJoinMoreChannels(currentCount: 0))
        XCTAssertTrue(status.canJoinMoreChannels(currentCount: 2))
    }

    func test_premiumStatus_canJoinMoreChannels_freeAtLimit() {
        let status = PremiumStatus(isActive: false)
        XCTAssertFalse(status.canJoinMoreChannels(currentCount: 3))
    }

    func test_premiumStatus_canJoinMoreChannels_premiumAlways() {
        let status = PremiumStatus(isActive: true)
        XCTAssertTrue(status.canJoinMoreChannels(currentCount: 0))
        XCTAssertTrue(status.canJoinMoreChannels(currentCount: 100))
    }

    func test_premiumStatus_canRemoveAds() {
        XCTAssertTrue(PremiumStatus(isActive: true).canRemoveAds)
        XCTAssertFalse(PremiumStatus(isActive: false).canRemoveAds)
    }

    func test_premiumStatus_canAccessPremiumChannels() {
        XCTAssertTrue(PremiumStatus(isActive: true).canAccessPremiumChannels)
        XCTAssertFalse(PremiumStatus(isActive: false).canAccessPremiumChannels)
    }

    // MARK: - νₑ 정상 경로 — UserProfile

    func test_userProfile_saveAndLoad_roundTrip() {
        UserDefaults.standard.removeObject(forKey: "user_profile")

        var profile = UserProfile(displayName: "테스터", bio: "안녕", joinedChannelCount: 2, postCount: 5, interests: [.gaming, .tech])
        profile.save()

        let loaded = UserProfile.load()
        XCTAssertEqual(loaded.displayName, "테스터")
        XCTAssertEqual(loaded.bio, "안녕")
        XCTAssertEqual(loaded.interests.count, 2)

        UserDefaults.standard.removeObject(forKey: "user_profile")
    }

    // MARK: - νₑ 정상 경로 — AppConstants

    func test_appConstants_freeChannelLimit_isThree() {
        XCTAssertEqual(AppConstants.freeChannelLimit, 3)
    }

    func test_appConstants_premiumPrice_notEmpty() {
        XCTAssertFalse(AppConstants.premiumMonthlyPrice.isEmpty)
    }

    // MARK: - νμ 예외 경로

    func test_premiumStatus_canJoinMoreChannels_overLimit() {
        let status = PremiumStatus(isActive: false)
        XCTAssertFalse(status.canJoinMoreChannels(currentCount: 10))
    }

    // MARK: - ντ 경계 경로

    func test_premiumStatus_canJoinMoreChannels_exactBoundary() {
        let status = PremiumStatus(isActive: false)
        let limit = AppConstants.freeChannelLimit

        XCTAssertTrue(status.canJoinMoreChannels(currentCount: limit - 1))
        XCTAssertFalse(status.canJoinMoreChannels(currentCount: limit))
        XCTAssertFalse(status.canJoinMoreChannels(currentCount: limit + 1))
    }

    func test_interestTag_codable_roundTrip() throws {
        for tag in InterestTag.allCases {
            let data = try JSONEncoder().encode(tag)
            let decoded = try JSONDecoder().decode(InterestTag.self, from: data)
            XCTAssertEqual(decoded, tag)
        }
    }

    func test_date_timeAgoString_justNow() {
        XCTAssertEqual(Date().timeAgoString, "방금 전")
    }

    func test_date_timeAgoString_minutesAgo() {
        let fiveMinAgo = Date().addingTimeInterval(-300)
        XCTAssertEqual(fiveMinAgo.timeAgoString, "5분 전")
    }

    func test_date_dateString_koreanFormat() {
        let str = Date().dateString
        XCTAssertTrue(str.contains("월"))
        XCTAssertTrue(str.contains("일"))
    }
}
