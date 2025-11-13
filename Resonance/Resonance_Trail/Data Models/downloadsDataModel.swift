//
//  DownloadsDataModel.swift
//  project1
//
//  Created by namir on 2025-11-06.
//  Purpose: Defines all structures and CRUD operations for the Downloads screen.
//

import Foundation

// ======================================================
// MARK: - STRUCTURES & ENUMS (Phase 1)
// ======================================================

/// Represents a single downloaded audiobook.
struct DownloadedBook: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var author: String
    var duration: String           // e.g., "8h 32m"
    var fileSizeMB: Int            // e.g., 245
    var dateDownloaded: Date
    var progressPercent: Double    // e.g., 65%
    
    init(id: UUID = UUID(),
         title: String,
         author: String,
         duration: String,
         fileSizeMB: Int,
         dateDownloaded: Date,
         progressPercent: Double) {
        self.id = id
        self.title = title
        self.author = author
        self.duration = duration
        self.fileSizeMB = fileSizeMB
        self.dateDownloaded = dateDownloaded
        self.progressPercent = progressPercent
    }
}

/// Represents the overall storage summary shown above the downloads list.
struct DownloadSummary: Codable, Equatable {
    var storageUsedMB: Int
    var totalBooks: Int
    var storageAvailableGB: Double
    
    static func empty() -> DownloadSummary {
        DownloadSummary(storageUsedMB: 0, totalBooks: 0, storageAvailableGB: 0)
    }
}

/// Represents the entire Downloads screen data.
struct DownloadsScreen: Codable, Equatable {
    var summary: DownloadSummary
    var downloadedBooks: [DownloadedBook]
    var actions: [DownloadsAction]
    var tabs: [DownloadsTabSection]
    
    static func sample() -> DownloadsScreen {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        
        return DownloadsScreen(
            summary: DownloadSummary(storageUsedMB: 1609, totalBooks: 5, storageAvailableGB: 2),
            downloadedBooks: [
                DownloadedBook(title: "The Midnight Library", author: "Matt Haig", duration: "8h 32m", fileSizeMB: 245, dateDownloaded: formatter.date(from: "Jan 15, 2024")!, progressPercent: 65),
                DownloadedBook(title: "Atomic Habits", author: "James Clear", duration: "5h 35m", fileSizeMB: 189, dateDownloaded: formatter.date(from: "Jan 12, 2024")!, progressPercent: 100),
                DownloadedBook(title: "Educated", author: "Tara Westover", duration: "12h 45m", fileSizeMB: 421, dateDownloaded: formatter.date(from: "Jan 8, 2024")!, progressPercent: 78),
                DownloadedBook(title: "Where the Crawdads Sing", author: "Delia Owens", duration: "11h 5m", fileSizeMB: 356, dateDownloaded: formatter.date(from: "Jan 5, 2024")!, progressPercent: 12),
                DownloadedBook(title: "The Seven Husbands", author: "Taylor Jenkins Reid", duration: "12h 10m", fileSizeMB: 398, dateDownloaded: formatter.date(from: "Jan 10, 2024")!, progressPercent: 45)
            ],
            actions: [DownloadsAction.clearAll, DownloadsAction.openSettings],
            tabs: [DownloadsTabSection.home, DownloadsTabSection.search, DownloadsTabSection.library, DownloadsTabSection.profile]
        )
    }
}

/// Represents available actions in the Downloads screen.
enum DownloadsAction: String, Codable, CaseIterable {
    case clearAll = "Clear All Downloads"
    case openSettings = "Download Settings"
    
    var systemIcon: String {
        switch self {
        case .clearAll: return "trash"
        case .openSettings: return "gearshape"
        }
    }
}

/// Represents bottom navigation tabs visible in the app.
enum DownloadsTabSection: String, Codable, CaseIterable {
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

// ======================================================
// MARK: - DATA MANAGER (Phase 2)
// ======================================================

/// Manages CRUD operations and persistence for the Downloads screen.
final class DownloadsDataModel {
    
    // MARK: Singleton
    static let shared = DownloadsDataModel()
    
    // MARK: File Paths
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let downloadsURL: URL
    
    // MARK: Stored Data
    private(set) var downloadsScreen: DownloadsScreen
    
    // MARK: Init
    private init() {
        downloadsURL = documentsDirectory.appendingPathComponent("downloads").appendingPathExtension("plist")
        downloadsScreen = DownloadsScreen.sample()
        loadDownloads()
    }
    
    // ======================================================
    // MARK: - CRUD OPERATIONS
    // ======================================================
    
    // MARK: CREATE
    func addDownloadedBook(_ book: DownloadedBook) {
        downloadsScreen.downloadedBooks.append(book)
        recalculateSummary()
        saveDownloads()
    }
    
    // MARK: READ
    func getAllDownloads() -> [DownloadedBook] {
        downloadsScreen.downloadedBooks
    }
    
    func getSummary() -> DownloadSummary {
        downloadsScreen.summary
    }
    
    // MARK: UPDATE
    func updateProgress(for id: UUID, to newProgress: Double) {
        if let index = downloadsScreen.downloadedBooks.firstIndex(where: { $0.id == id }) {
            downloadsScreen.downloadedBooks[index].progressPercent = newProgress
            saveDownloads()
        }
    }
    
    // MARK: DELETE
    func deleteDownloadedBook(at index: Int) {
        guard downloadsScreen.downloadedBooks.indices.contains(index) else { return }
        downloadsScreen.downloadedBooks.remove(at: index)
        recalculateSummary()
        saveDownloads()
    }
    
    func clearAllDownloads() {
        downloadsScreen.downloadedBooks.removeAll()
        recalculateSummary()
        saveDownloads()
    }
    
    // MARK: - Helpers
    
    private func recalculateSummary() {
        let totalMB = downloadsScreen.downloadedBooks.reduce(0) { $0 + $1.fileSizeMB }
        downloadsScreen.summary = DownloadSummary(
            storageUsedMB: totalMB,
            totalBooks: downloadsScreen.downloadedBooks.count,
            storageAvailableGB: 2 // placeholder; could calculate dynamically
        )
    }
    
    // ======================================================
    // MARK: - PERSISTENCE
    // ======================================================
    
    private func saveDownloads() {
        let encoder = PropertyListEncoder()
        if let data = try? encoder.encode(downloadsScreen) {
            try? data.write(to: downloadsURL, options: .atomic)
        }
    }
    
    private func loadDownloads() {
        guard let data = try? Data(contentsOf: downloadsURL) else { return }
        let decoder = PropertyListDecoder()
        if let decoded = try? decoder.decode(DownloadsScreen.self, from: data) {
            downloadsScreen = decoded
        }
    }
}

