//
//  AuthorProfileDataModel.swift
//  project1
//
//  Created by namir on 2025-11-06.
//  Purpose: Defines all structures and CRUD operations for the Author Profile screen.
//

import Foundation

// ======================================================
// MARK: - STRUCTURES & ENUMS (Phase 1)
// ======================================================

/// Represents the overall Author Profile screen.
struct AuthorProfile: Codable, Equatable {
    var user: User
    var stats: AuthorStats
    var milestones: [AuthorMilestone]
    var actions: [ProfileAction]
    var tabMenu: [ProfileTab]
    
    static func sample() -> AuthorProfile {
        let sampleUser = User(
            username: "sarahjohnson",
            displayName: "Sarah Johnson",
            role: .author,
            bio: "Author since March 2023",
            isVerified: true
        )
        
        return AuthorProfile(
            user: sampleUser,
            stats: AuthorStats(booksPublished: 5, totalListeners: 2400, averageRating: 4.8),
            milestones: [
                AuthorMilestone(title: "First Published", achieved: true),
                AuthorMilestone(title: "1K Listeners", achieved: true),
                AuthorMilestone(title: "Series Creator", achieved: true),
                AuthorMilestone(title: "10K Listeners", achieved: false),
                AuthorMilestone(title: "Prolific Writer", achieved: false)
            ],
            actions: [.settings, .myBooks, .audienceInsights, .signOut],
            tabMenu: [.home, .analytics, .draft, .profile]
        )
    }
}

/// Represents an author's statistical summary shown at the top of the profile.
struct AuthorStats: Codable, Equatable {
    var booksPublished: Int
    var totalListeners: Int
    var averageRating: Double
}

/// Represents a single author milestone (achievement badge).
struct AuthorMilestone: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var achieved: Bool
    var dateAchieved: Date?
    
    init(id: UUID = UUID(), title: String, achieved: Bool, dateAchieved: Date? = nil) {
        self.id = id
        self.title = title
        self.achieved = achieved
        self.dateAchieved = dateAchieved
    }
}

/// Represents user-tappable actions in the profile menu.
enum ProfileAction: String, Codable, CaseIterable {
    case settings = "Settings"
    case myBooks = "My Books"
    case audienceInsights = "Audience Insights"
    case signOut = "Sign Out"
    
    var iconName: String {
        switch self {
        case .settings: return "gearshape"
        case .myBooks: return "book.closed"
        case .audienceInsights: return "chart.bar"
        case .signOut: return "rectangle.portrait.and.arrow.right"
        }
    }
}

/// Represents the bottom navigation tabs visible at the bottom of the screen.
enum ProfileTab: String, Codable, CaseIterable {
    case home = "Home"
    case analytics = "Analytics"
    case draft = "Draft"
    case profile = "Profile"
    
    var systemIcon: String {
        switch self {
        case .home: return "house"
        case .analytics: return "chart.bar.doc.horizontal"
        case .draft: return "doc.text"
        case .profile: return "person.crop.circle"
        }
    }
}

// ======================================================
// MARK: - DATA MANAGER (Phase 2)
// ======================================================

/// Manages persistent data for the Author Profile screen.
/// Handles AuthorProfile, AuthorStats, and AuthorMilestone operations.
final class AuthorProfileDataModel {
    
    // MARK: Singleton
    static let shared = AuthorProfileDataModel()
    
    // MARK: File Paths
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let profileURL: URL
    private let milestonesURL: URL
    
    // MARK: Stored Data
    private(set) var authorProfile: AuthorProfile?
    private(set) var milestones: [AuthorMilestone] = []
    
    // MARK: Init
    private init() {
        profileURL = documentsDirectory.appendingPathComponent("authorProfile").appendingPathExtension("plist")
        milestonesURL = documentsDirectory.appendingPathComponent("authorMilestones").appendingPathExtension("plist")
        loadData()
    }
    
    // ======================================================
    // MARK: - CRUD OPERATIONS
    // ======================================================
    
    // MARK: CREATE
    func createProfile(for user: User, stats: AuthorStats) {
        authorProfile = AuthorProfile(
            user: user,
            stats: stats,
            milestones: [],
            actions: [.settings, .myBooks, .audienceInsights, .signOut],
            tabMenu: [.home, .analytics, .draft, .profile]
        )
        saveProfile()
    }
    
    func addMilestone(_ milestone: AuthorMilestone) {
        milestones.append(milestone)
        authorProfile?.milestones = milestones
        saveMilestones()
        saveProfile()
    }
    
    // MARK: READ
    func getProfile() -> AuthorProfile? {
        authorProfile
    }
    
    func getMilestones() -> [AuthorMilestone] {
        milestones
    }
    
    // MARK: UPDATE
    func updateStats(_ newStats: AuthorStats) {
        guard var profile = authorProfile else { return }
        profile.stats = newStats
        authorProfile = profile
        saveProfile()
    }
    
    func updateMilestone(_ updated: AuthorMilestone) {
        if let index = milestones.firstIndex(where: { $0.id == updated.id }) {
            milestones[index] = updated
            authorProfile?.milestones = milestones
            saveMilestones()
            saveProfile()
        }
    }
    
    func updateUser(_ updatedUser: User) {
        guard var profile = authorProfile else { return }
        profile.user = updatedUser
        authorProfile = profile
        saveProfile()
    }
    
    // MARK: DELETE
    func deleteMilestone(at index: Int) {
        guard milestones.indices.contains(index) else { return }
        milestones.remove(at: index)
        authorProfile?.milestones = milestones
        saveMilestones()
        saveProfile()
    }
    
    func clearProfile() {
        authorProfile = nil
        milestones.removeAll()
        saveProfile()
        saveMilestones()
    }
    
    // ======================================================
    // MARK: - PERSISTENCE
    // ======================================================
    
    private func loadData() {
        loadProfile()
        loadMilestones()
        
        if authorProfile == nil {
            authorProfile = AuthorProfile.sample()
            milestones = authorProfile?.milestones ?? []
            saveProfile()
            saveMilestones()
        }
    }
    
    private func loadProfile() {
        guard let data = try? Data(contentsOf: profileURL) else { return }
        let decoder = PropertyListDecoder()
        authorProfile = try? decoder.decode(AuthorProfile.self, from: data)
    }
    
    private func loadMilestones() {
        guard let data = try? Data(contentsOf: milestonesURL) else { return }
        let decoder = PropertyListDecoder()
        milestones = (try? decoder.decode([AuthorMilestone].self, from: data)) ?? []
    }
    
    private func saveProfile() {
        guard let profile = authorProfile else { return }
        let encoder = PropertyListEncoder()
        if let data = try? encoder.encode(profile) {
            try? data.write(to: profileURL, options: .atomic)
        }
    }
    
    private func saveMilestones() {
        let encoder = PropertyListEncoder()
        if let data = try? encoder.encode(milestones) {
            try? data.write(to: milestonesURL, options: .atomic)
        }
    }
}
