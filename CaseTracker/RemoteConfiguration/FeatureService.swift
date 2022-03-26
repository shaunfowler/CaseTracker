//
//  FeatureService.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 3/24/22.
//

import Foundation
import Combine
import Firebase
import CocoaLumberjack

enum Feature: String {
    case history = "featureHistory"
}

protocol FeatureServiceProtocol {
    func isEnabled(feature: Feature) -> Bool
}

class FeatureService: FeatureServiceProtocol {

    private var cancellables = Set<AnyCancellable>()
    private let remoteConfig = RemoteConfig.remoteConfig()
    private let settings = RemoteConfigSettings()

    static let shared: FeatureServiceProtocol = FeatureService()

    private init() {
#if DEBUG
        settings.minimumFetchInterval = 30 // 30-sec
#else
        settings.minimumFetchInterval = 3600 // 1-hour
#endif
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")

        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification, object: nil)
            .sink { _ in
                self.fetchAndActivate()
            }
            .store(in: &cancellables)
    }

    private func fetchAndActivate() {
        DDLogInfo("Fetching and activating remote configuration...")
        remoteConfig.fetchAndActivate { status, error in
            switch status {
            case .error:
                DDLogInfo("Fetched config error: \(error.debugDescription)")
            case .successFetchedFromRemote:
                DDLogInfo("Fetched config from remote.")
            case .successUsingPreFetchedData:
                DDLogInfo("Fetched config from prefetched data.")
            @unknown default:
                DDLogWarn("Unknown status while fetching remote config: \(status.rawValue).")
            }
        }
    }

    func isEnabled(feature: Feature) -> Bool {
        let value = remoteConfig.configValue(forKey: feature.rawValue).boolValue
        DDLogDebug("Feature \(feature), isEnabled = \(value).")
        return value
    }
}
