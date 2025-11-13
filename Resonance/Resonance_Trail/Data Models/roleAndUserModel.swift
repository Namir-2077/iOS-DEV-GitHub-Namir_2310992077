//
//  RoleAndUserModel.swift
//  project1
//
//  Created by namir on 2025-11-06.
//  Purpose: Shared user / role models used across per-screen data model files.
//

import Foundation

/// RoleType distinguishes the two user roles shown across your screens:
/// - Author: creates / publishes content (episodes, posts, sessions)
/// - Listener: consumes content and can interact (likes, follows, comments)
enum RoleType: String, Codable, CaseIterable {
    case author
    case listener

    /// Human-readable title
    var displayName: String {
        switch self {
        case .author: return "Author"
        case .listener: return "Listener"
        }
    }
}

/// Primary representation of a user across screens.
/// - Conforms to `Identifiable` so it plugs into SwiftUI lists easily.
/// - `Codable` for persistence (plist/JSON) and networking.
/// - `Equatable` uses `id` equality by default to represent identity equivalence.
struct User: Identifiable, Codable, Equatable {
    let id: UUID

    // Basic identity
    var username: String            // unique short handle (e.g., "@namir")
    var displayName: String?        // human name shown on cards
    var role: RoleType              // author or listener
    var avatarURL: URL?             // remote avatar, if any
    var avatarSystemName: String?   // fallback SF Symbol (e.g., "person.crop.circle")

    // Profile metadata
    var bio: String?
    var location: String?
    var isVerified: Bool
    var joinedAt: Date?
    var lastActiveAt: Date?         // for presence indicators

    // Social / engagement counts (kept as ints for quick UI badges)
    var followersCount: Int
    var followingCount: Int
    var postsCount: Int

    // Preferences & settings snapshot relevant to UI screens
    var preferredLanguage: String?
    var isMuted: Bool?              // app-level mute state
    var hasPushNotificationsEnabled: Bool?

    // App-specific flags and small arrays
    var badges: [String]?           // e.g. ["pro", "early-adopter"]
    var pinnedEpisodeIDs: [UUID]?   // quick links to authored content
    var metadata: [String: String]? // extensible key/value bag (themes, promo codes)

    // Convenience computed property
    var isOnline: Bool {
        guard let last = lastActiveAt else { return false }
        return abs(last.timeIntervalSinceNow) < 60 * 5
    }

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        username: String,
        displayName: String? = nil,
        role: RoleType = .listener,
        avatarURL: URL? = nil,
        avatarSystemName: String? = nil,
        bio: String? = nil,
        location: String? = nil,
        isVerified: Bool = false,
        joinedAt: Date? = nil,
        lastActiveAt: Date? = nil,
        followersCount: Int = 0,
        followingCount: Int = 0,
        postsCount: Int = 0,
        preferredLanguage: String? = nil,
        isMuted: Bool? = nil,
        hasPushNotificationsEnabled: Bool? = nil,
        badges: [String]? = nil,
        pinnedEpisodeIDs: [UUID]? = nil,
        metadata: [String: String]? = nil
    ) {
        self.id = id
        self.username = username
        self.displayName = displayName
        self.role = role
        self.avatarURL = avatarURL
        self.avatarSystemName = avatarSystemName
        self.bio = bio
        self.location = location
        self.isVerified = isVerified
        self.joinedAt = joinedAt
        self.lastActiveAt = lastActiveAt
        self.followersCount = followersCount
        self.followingCount = followingCount
        self.postsCount = postsCount
        self.preferredLanguage = preferredLanguage
        self.isMuted = isMuted
        self.hasPushNotificationsEnabled = hasPushNotificationsEnabled
        self.badges = badges
        self.pinnedEpisodeIDs = pinnedEpisodeIDs
        self.metadata = metadata
    }

    // Identity-based equality (two User structs represent same entity if ids equal)
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
