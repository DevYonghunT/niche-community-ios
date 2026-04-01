import Foundation
import SwiftUI

/// 설정 화면의 뷰모델
@MainActor
final class SettingsViewModel: ObservableObject {

    // MARK: - 계산 프로퍼티

    /// 앱 버전 문자열
    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    init() {}
}
