//
//  SettingsDataModel.swift
//  project1
//
//  Created by namir on 2025-11-06.
//  Purpose: Defines all structures and CRUD operations for the Settings screen.
//

import Foundation

// ======================================================
// MARK: - STRUCTURES & ENUMS (Phase 1)
// ======================================================

/// Top-level structure representing all app settings.
struct AppSettings: Codable, Equatable {
    var notifications: NotificationSettings
    var playback: PlaybackSettings
    var downloads: DownloadSettingsSection
    var privacy: PrivacySettings
    var accessibility: AccessibilitySettings
    var tabs: [TabSection]
    
    enum PlaybackSpeed: String, Codable, CaseIterable, Equatable {
        case half = "0.5x"
        case normal = "1x"
        case oneAndHalf = "1.5x"
        case double = "2x"
    }
    
    enum DownloadQuality: String, Codable, CaseIterable, Equatable {
        case low
        case medium
        case high
        var description: String {
            switch self {
            case .low: return "Low (64 kbps)"
            case .medium: return "Medium (128 kbps)"
            case .high: return "High (256 kbps)"
            }
        }
    }
    
    enum TabSection: String, Codable, CaseIterable, Equatable {
        case home = "Home"
        case search = "Search"
        case library = "Library"
        case profile = "Profile"
        var systemIcon: String {
            switch self {
            case .home: return "house"
            case .search: return "magnifyingglass"
            case .library: return "books.vertical"
            case .profile: return "person.crop.circle"
            }
        }
    }
    
    static func defaultSettings() -> AppSettings {
        return AppSettings(
            notifications: NotificationSettings(),
            playback: PlaybackSettings(),
            downloads: DownloadSettingsSection(),
            privacy: PrivacySettings(),
            accessibility: AccessibilitySettings(),
            tabs: [TabSection.home, TabSection.search, TabSection.library, TabSection.profile]
        )
    }
}

// MARK: - Notifications

struct NotificationSettings: Codable, Equatable {
    var appNotifications: Bool
    var emailUpdates: Bool
    var pushNotifications: Bool
    
    init(appNotifications: Bool = true,
         emailUpdates: Bool = true,
         pushNotifications: Bool = true) {
        self.appNotifications = appNotifications
        self.emailUpdates = emailUpdates
        self.pushNotifications = pushNotifications
    }
}

// MARK: - Playback

struct PlaybackSettings: Codable, Equatable {
    var autoPlayNext: Bool
    var skipSilence: Bool
    var defaultSpeed: AppSettings.PlaybackSpeed
    var sleepTimerEnabled: Bool
    
    init(autoPlayNext: Bool = true,
         skipSilence: Bool = false,
         defaultSpeed: AppSettings.PlaybackSpeed = .normal,
         sleepTimerEnabled: Bool = false) {
        self.autoPlayNext = autoPlayNext
        self.skipSilence = skipSilence
        self.defaultSpeed = defaultSpeed
        self.sleepTimerEnabled = sleepTimerEnabled
    }
}

// MARK: - Downloads

struct DownloadSettingsSection: Codable, Equatable {
    var autoDownload: Bool
    var wifiOnly: Bool
    var quality: AppSettings.DownloadQuality
    
    init(autoDownload: Bool = false,
         wifiOnly: Bool = true,
         quality: AppSettings.DownloadQuality = .high) {
        self.autoDownload = autoDownload
        self.wifiOnly = wifiOnly
        self.quality = quality
    }
}

// MARK: - Privacy

struct PrivacySettings: Codable, Equatable {
    var shareProgress: Bool
    var showActivity: Bool
    var allowDataCollection: Bool
    
    init(shareProgress: Bool = true,
         showActivity: Bool = true,
         allowDataCollection: Bool = true) {
        self.shareProgress = shareProgress
        self.showActivity = showActivity
        self.allowDataCollection = allowDataCollection
    }
}

// MARK: - Accessibility

struct AccessibilitySettings: Codable, Equatable {
    var largeText: Bool
    var highContrast: Bool
    var reducedMotion: Bool
    
    init(largeText: Bool = false,
         highContrast: Bool = false,
         reducedMotion: Bool = false) {
        self.largeText = largeText
        self.highContrast = highContrast
        self.reducedMotion = reducedMotion
    }
}

// ======================================================
// MARK: - DATA MANAGER (Phase 2)
// ======================================================

/// Handles CRUD operations and persistence for all app settings.
final class SettingsDataModel {
    
    // MARK: Singleton
    static let shared = SettingsDataModel()
    
    // MARK: File Path
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let settingsURL: URL
    
    // MARK: Stored Data
    private(set) var appSettings: AppSettings
    
    // MARK: Init
    private init() {
        settingsURL = documentsDirectory.appendingPathComponent("appSettings").appendingPathExtension("plist")
        appSettings = AppSettings.defaultSettings()
        loadSettings()
    }
    
    // ======================================================
    // MARK: - CRUD OPERATIONS
    // ======================================================

    // MARK: CREATE / RESET
    func resetToDefaults() {
        appSettings = AppSettings.defaultSettings()
        saveSettings()
    }

    // MARK: READ
    func getSettings() -> AppSettings {
        appSettings
    }
    
    // MARK: UPDATE
    func updateNotificationSettings(_ newSettings: NotificationSettings) {
        appSettings.notifications = newSettings
        saveSettings()
    }
    
    func updatePlaybackSettings(_ newSettings: PlaybackSettings) {
        appSettings.playback = newSettings
        saveSettings()
    }
    
    func updateDownloadSettings(_ newSettings: DownloadSettingsSection) {
        appSettings.downloads = newSettings
        saveSettings()
    }
    
    func updatePrivacySettings(_ newSettings: PrivacySettings) {
        appSettings.privacy = newSettings
        saveSettings()
    }
    
    func updateAccessibilitySettings(_ newSettings: AccessibilitySettings) {
        appSettings.accessibility = newSettings
        saveSettings()
    }

    // MARK: DELETE
    func clearAllSettings() {
        appSettings = AppSettings.defaultSettings()
        saveSettings()
    }

    // ======================================================
    // MARK: - PERSISTENCE
    // ======================================================

    private func saveSettings() {
        let encoder = PropertyListEncoder()
        if let data = try? encoder.encode(appSettings) {
            try? data.write(to: settingsURL, options: .atomic)
        }
    }

    private func loadSettings() {
        guard let data = try? Data(contentsOf: settingsURL) else { return }
        let decoder = PropertyListDecoder()
        if let decoded = try? decoder.decode(AppSettings.self, from: data) {
            appSettings = decoded
        }
    }
}
