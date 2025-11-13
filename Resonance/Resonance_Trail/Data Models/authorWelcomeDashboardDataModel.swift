//
//  AuthorWelcomeDataModel.swift
//  project1
//
//  Created by namir on 2025-11-06.
//  Purpose: Defines all structures and CRUD operations for the Author Welcome Dashboard screen.
//

import Foundation

// ======================================================
// MARK: - STRUCTURES & ENUMS (Phase 1)
// ======================================================

/// Represents the entire Author Welcome screen.
struct AuthorWelcomeDashboard: Codable, Equatable {
    var message: WelcomeMessage
    var actions: [QuickAction]
    var journeySteps: [JourneyStep]
    var tabs: [AuthorDashboardTab]

    static func sample() -> AuthorWelcomeDashboard {
        AuthorWelcomeDashboard(
            message: WelcomeMessage(
                title: "Welcome, Author!",
                subtitle: "Your journey to becoming a published audiobook author starts here. Let's create something amazing together.",
                ctaText: "Get Started"
            ),
            actions: [
                QuickAction(
                    title: "Create Your First Book",
                    subtitle: "Start with a title, genre, and your story outline",
                    iconName: "book.closed"
                ),
                QuickAction(
                    title: "Record Voice Sample",
                    subtitle: "Test your setup and capture your unique voice",
                    iconName: "mic.fill"
                )
            ],
            journeySteps: [
                JourneyStep(
                    stepNumber: 1,
                    title: "Create & Write",
                    description: "Develop your stories and characters",
                    iconName: "pencil.and.outline"
                ),
                JourneyStep(
                    stepNumber: 2,
                    title: "Record & Edit",
                    description: "Bring your stories to life with voice",
                    iconName: "waveform.circle.fill"
                ),
                JourneyStep(
                    stepNumber: 3,
                    title: "Publish & Share",
                    description: "Distribute your audiobook to listeners",
                    iconName: "paperplane.fill"
                )
            ],
            tabs: [
                AuthorDashboardTab.overview,
                AuthorDashboardTab.projects,
                AuthorDashboardTab.learning,
                AuthorDashboardTab.account
            ]
        )
    }
}

/// The hero welcome message at the top of the dashboard.
struct WelcomeMessage: Codable, Equatable {
    var title: String
    var subtitle: String
    var ctaText: String
}

/// A quick action tile the user can tap to jump into common flows.
struct QuickAction: Codable, Equatable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var subtitle: String
    var iconName: String
}

/// A single step in the author's journey roadmap.
struct JourneyStep: Codable, Equatable, Identifiable {
    var id: UUID = UUID()
    var stepNumber: Int
    var title: String
    var description: String
    var iconName: String
}

/// Tabs available on the dashboard screen.
enum AuthorDashboardTab: String, Codable, Equatable, CaseIterable {
    case overview
    case projects
    case learning
    case account
}
