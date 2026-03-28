import Foundation
import SwiftUI

/// 설정 화면의 뷰모델
/// 프리미엄 상태 확인 및 앱 정보를 표시한다
@MainActor
final class SettingsViewModel: ObservableObject {

    // MARK: - 의존성

    /// 프리미엄 서비스 (구독 상태 확인용)
    let premiumService: PremiumService

    // MARK: - 계산 프로퍼티

    /// 앱 버전 문자열
    /// Info.plist에서 버전 정보를 가져온다
    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    // MARK: - 초기화

    /// SettingsViewModel 초기화
    /// - Parameter premiumService: 프리미엄 상태 확인 서비스
    init(premiumService: PremiumService) {
        self.premiumService = premiumService
    }
}
