//
//  AuthorDashboardDataModel.swift
//  project1
//
//  Created by namir on 2025-11-06.
//  Purpose: Defines all structures and CRUD operations for the Author Dashboard screen.
//

import Foundation

// ======================================================
// MARK: - STRUCTURES & ENUMS (Phase 1)
// ======================================================

/// Represents the entire Author Dashboard screen.
struct AuthorDashboard: Codable, Equatable {
    var summary: AuthorSummary
    var actions: [DashboardAction]
    var activities: [ActivityLog]
    var workInProgress: [WorkInProgress]
    var tabs: [DashboardTab]
    
    static func sample() -> AuthorDashboard {
        AuthorDashboard(
            summary: AuthorSummary(
                name: "Sarah Johnson",
                genre: "Fantasy & Romance Author",
                rating: 4.8,
                totalBooks: 12
            ),
            actions: [.newBook, .recordVoice, .drafts(3), .myBooks],
            activities: [
                ActivityLog(title: "Book recording completed", subtitle: "The Midnight Library", timeAgo: "2 hours ago"),
                ActivityLog(title: "New 5-star review received", subtitle: "Becoming", timeAgo: "5 hours ago"),
                ActivityLog(title: "147 new followers this week", subtitle: "Profile", timeAgo: "1 day ago")
            ],
            workInProgress: [
                WorkInProgress(title: "The Midnight Library", chapter: "Chapter 12", phase: .recording, completion: 75),
                WorkInProgress(title: "Becoming", chapter: "Chapter 8", phase: .draftReview, completion: 45),
                WorkInProgress(title: "Dune Chronicles", chapter: "Chapter 3", phase: .planning, completion: 15)
            ],
            tabs: [.home, .draft, .profile, .analytics]
        )
    }
}

/// Represents the top section with author stats.
struct AuthorSummary: Codable, Equatable {
    var name: String
    var genre: String
    var rating: Double
    var totalBooks: Int
}

/// Represents the action cards (New Book, Record, Drafts, My Books).
enum DashboardAction: Codable, Equatable {
    case newBook
    case recordVoice
    case drafts(Int)
    case myBooks
    
    enum CodingKeys: String, CodingKey {
        case type, count
    }
    
    enum ActionType: String, Codable {
        case newBook, recordVoice, drafts, myBooks
    }
    
    var title: String {
        switch self {
        case .newBook: return "New Book"
        case .recordVoice: return "Record"
        case .drafts: return "Drafts"
        case .myBooks: return "My Books"
        }
    }
    
    var subtitle: String {
        switch self {
        case .newBook: return "Start writing"
        case .recordVoice: return "Voice session"
        case .drafts(let count): return "\(count) in progress"
        case .myBooks: return "View insights"
        }
    }
    
    var iconName: String {
        switch self {
        case .newBook: return "book.closed"
        case .recordVoice: return "mic.fill"
        case .drafts: return "doc.text"
        case .myBooks: return "books.vertical"
        }
    }
    
    // Codable conformance
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .newBook:
            try container.encode(ActionType.newBook, forKey: .type)
        case .recordVoice:
            try container.encode(ActionType.recordVoice, forKey: .type)
        case .drafts(let count):
            try container.encode(ActionType.drafts, forKey: .type)
            try container.encode(count, forKey: .count)
        case .myBooks:
            try container.encode(ActionType.myBooks, forKey: .type)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ActionType.self, forKey: .type)
        switch type {
        case .newBook: self = .newBook
        case .recordVoice: self = .recordVoice
        case .drafts: self = .drafts((try? container.decode(Int.self, forKey: .count)) ?? 0)
        case .myBooks: self = .myBooks
        }
    }
}

/// Represents a single activity log entry.
struct ActivityLog: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var subtitle: String
    var timeAgo: String
    
    init(id: UUID = UUID(), title: String, subtitle: String, timeAgo: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.timeAgo = timeAgo
    }
}

/// Represents an ongoing writing or recording project.
struct WorkInProgress: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var chapter: String
    var phase: WorkPhase
    var completion: Double
    
    init(id: UUID = UUID(), title: String, chapter: String, phase: WorkPhase, completion: Double) {
        self.id = id
        self.title = title
        self.chapter = chapter
        self.phase = phase
        self.completion = completion
    }
}

/// Represents the progress phase for works in progress.
enum WorkPhase: String, Codable, CaseIterable {
    case planning = "Planning phase"
    case draftReview = "Draft review"
    case recording = "Recording in progress"
}

/// Represents bottom navigation tabs.
enum DashboardTab: String, Codable, CaseIterable {
    case home = "Home"
    case draft = "Draft"
    case profile = "Profile"
    case analytics = "Analytics"
    
    var systemIcon: String {
        switch self {
        case .home: return "house"
        case .draft: return "doc.text"
        case .profile: return "person.crop.circle"
        case .analytics: return "chart.bar"
        }
    }
}

// ======================================================
// MARK: - DATA MANAGER (Phase 2)
// ======================================================

/// Manages CRUD operations and persistence for the Author Dashboard.
final class AuthorDashboardDataModel {
    
    // MARK: Singleton
    static let shared = AuthorDashboardDataModel()
    
    // MARK: File Path
    private let documentsDirectory: URL = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? URL(fileURLWithPath: NSTemporaryDirectory())
    }()
    private let dashboardURL: URL
    
    // MARK: Stored Data
    private(set) var dashboard: AuthorDashboard
    
    // MARK: Init
    private init() {
        dashboardURL = documentsDirectory.appendingPathComponent("author_dashboard_data").appendingPathExtension("plist")
        dashboard = AuthorDashboard.sample()
        loadDashboard()
    }
    
    // ======================================================
    // MARK: - CRUD OPERATIONS
    // ======================================================
    
    // MARK: CREATE
    func addActivity(_ log: ActivityLog) {
        dashboard.activities.insert(log, at: 0)
        saveDashboard()
    }
    
    func addWork(_ work: WorkInProgress) {
        dashboard.workInProgress.append(work)
        saveDashboard()
    }
    
    // MARK: READ
    func getDashboard() -> AuthorDashboard {
        dashboard
    }
    
    func getActivities() -> [ActivityLog] {
        dashboard.activities
    }
    
    func getWorkInProgress() -> [WorkInProgress] {
        dashboard.workInProgress
    }
    
    // MARK: UPDATE
    func updateWorkProgress(for id: UUID, to completion: Double) {
        if let index = dashboard.workInProgress.firstIndex(where: { $0.id == id }) {
            dashboard.workInProgress[index].completion = completion
            saveDashboard()
        }
    }
    
    func updateRating(_ newRating: Double) {
        dashboard.summary.rating = newRating
        saveDashboard()
    }
    
    // MARK: DELETE
    func deleteActivity(at index: Int) {
        guard dashboard.activities.indices.contains(index) else { return }
        dashboard.activities.remove(at: index)
        saveDashboard()
    }
    
    func clearAllData() {
        dashboard = AuthorDashboard.sample()
        saveDashboard()
    }
    
    // ======================================================
    // MARK: - PERSISTENCE
    // ======================================================
    
    private func saveDashboard() {
        do {
            let data = try PropertyListEncoder().encode(dashboard)
            try data.write(to: dashboardURL, options: .atomic)
        } catch {
            print("❌ Failed to save Author Dashboard:", error)
        }
    }
    
    private func loadDashboard() {
        do {
            let data = try Data(contentsOf: dashboardURL)
            dashboard = try PropertyListDecoder().decode(AuthorDashboard.self, from: data)
        } catch {
            print("ℹ️ No saved dashboard data found. Using defaults.")
            dashboard = AuthorDashboard.sample()
        }
    }
}
