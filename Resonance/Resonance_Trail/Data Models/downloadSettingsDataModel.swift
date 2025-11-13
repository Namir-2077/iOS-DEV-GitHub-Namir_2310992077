//
//  DownloadSettingsDataModel.swift
//  project1
//
//  Created by namir on 2025-11-06.
//  Purpose: Defines all structures and CRUD operations for the Download Settings screen.
//

import Foundation

// ======================================================
// MARK: - STRUCTURES & ENUMS (Phase 1)
// ======================================================

/// Represents the entire Download Settings screen configuration.
struct DownloadSettings: Codable, Equatable {
    var autoDownload: Bool
    var wifiOnly: Bool
    var quality: Quality
    var maxStorage: StorageLimit
    var autoDelete: Bool
    var tabs: [TabSection]
    
    enum Quality: String, Codable, CaseIterable, Equatable {
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
        var estimatedSizePerHour: String {
            switch self {
            case .low: return "~30 MB/hour"
            case .medium: return "~60 MB/hour"
            case .high: return "~120 MB/hour"
            }
        }
    }
    
    enum StorageLimit: String, Codable, CaseIterable, Equatable {
        case oneGB = "1 GB"
        case tenGB = "10 GB"
        case twentyGB = "20 GB"
        var bytesValue: Int {
            switch self {
            case .oneGB: return 1_000_000_000
            case .tenGB: return 10_000_000_000
            case .twentyGB: return 20_000_000_000
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
    
    private enum CodingKeys: String, CodingKey {
        case autoDownload
        case wifiOnly
        case quality
        case maxStorage
        case autoDelete
        case tabs
    }
    
    static func defaultSettings() -> DownloadSettings {
        return DownloadSettings(
            autoDownload: false,
            wifiOnly: true,
            quality: Quality.medium,
            maxStorage: StorageLimit.tenGB,
            autoDelete: false,
            tabs: [TabSection.home, TabSection.search, TabSection.library, TabSection.profile]
        )
    }
}

// ======================================================
// MARK: - DATA MANAGER (Phase 2)
// ======================================================

/// Manages persistent data for the Download Settings screen.
final class DownloadSettingsDataModel {
    
    // MARK: Singleton
    static let shared = DownloadSettingsDataModel()
    
    // MARK: File Path
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let settingsURL: URL
    
    // MARK: Stored Data
    private(set) var settings: DownloadSettings
    
    // MARK: Init
    private init() {
        settingsURL = documentsDirectory.appendingPathComponent("downloadSettings").appendingPathExtension("plist")
        settings = DownloadSettings.defaultSettings()
        loadSettings()
    }
    
    // ======================================================
    // MARK: - CRUD OPERATIONS
    // ======================================================
    
    // MARK: CREATE / RESET
    func resetToDefaults() {
        settings = DownloadSettings.defaultSettings()
        saveSettings()
    }
    
    // MARK: READ
    func getSettings() -> DownloadSettings {
        return settings
    }
    
    // MARK: UPDATE
    func updateAutoDownload(_ value: Bool) {
        settings.autoDownload = value
        saveSettings()
    }
    
    func updateWiFiOnly(_ value: Bool) {
        settings.wifiOnly = value
        saveSettings()
    }
    
    func updateQuality(_ quality: DownloadSettings.Quality) {
        settings.quality = quality
        saveSettings()
    }
    
    func updateMaxStorage(_ limit: DownloadSettings.StorageLimit) {
        settings.maxStorage = limit
        saveSettings()
    }
    
    func updateAutoDelete(_ value: Bool) {
        settings.autoDelete = value
        saveSettings()
    }
    
    // MARK: DELETE
    func clearAllSettings() {
        settings = DownloadSettings.defaultSettings()
        saveSettings()
    }
    
    // ======================================================
    // MARK: - PERSISTENCE
    // ======================================================
    
    private func saveSettings() {
        let encoder = PropertyListEncoder()
        if let data = try? encoder.encode(settings) {
            try? data.write(to: settingsURL, options: .atomic)
        }
    }
    
    private func loadSettings() {
        guard let data = try? Data(contentsOf: settingsURL) else { return }
        let decoder = PropertyListDecoder()
        if let decoded = try? decoder.decode(DownloadSettings.self, from: data) {
            settings = decoded
        }
    }
}

