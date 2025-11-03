//
//  Data_Model_1.swift
//  Resonance_Trail
//
//  Created by Student on 31/10/25.
//

import Foundation

// MARK: - Author Model
struct Author: Equatable, Codable {
    let id: UUID
    var name: String
    var email: String
    var bio: String?
    var profileImageURL: String?
    var books: [UUID] // store book IDs instead of full objects to avoid circular dependency
    
    init(name: String, email: String, bio: String? = nil, profileImageURL: String? = nil) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.bio = bio
        self.profileImageURL = profileImageURL
        self.books = []
    }
    
    static func ==(lhs: Author, rhs: Author) -> Bool { lhs.id == rhs.id }
}

// MARK: - Book Status
enum BookStatus: String, Codable {
    case draft, processing, published
}

// MARK: - Genre & Category Models
struct Genre: Codable, Equatable {
    let id: UUID
    var name: String
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}

struct Category: Codable, Equatable {
    let id: UUID
    var name: String
    var description: String?
    
    init(name: String, description: String? = nil) {
        self.id = UUID()
        self.name = name
        self.description = description
    }
}

// MARK: - Chapter Model
struct Chapter: Codable, Equatable {
    let id: UUID
    var title: String
    var duration: TimeInterval
    var audioURL: String
    var order: Int
    
    init(title: String, duration: TimeInterval, audioURL: String, order: Int) {
        self.id = UUID()
        self.title = title
        self.duration = duration
        self.audioURL = audioURL
        self.order = order
    }
}

// MARK: - Book Model
struct Book: Equatable, Codable {
    let id: UUID
    var title: String
    var description: String
    var coverImageURL: String?
    var pdfURL: String
    var chapters: [Chapter]
    var totalDuration: TimeInterval {
        chapters.reduce(0) { $0 + $1.duration }
    }
    var authorID: UUID
    var genre: String?
    var language: String
    var uploadDate: Date
    var status: BookStatus
    var listeners: [UUID]
    var rating: Double?
    
    init(
        title: String,
        description: String,
        pdfURL: String,
        authorID: UUID,
        genre: String?,
        language: String,
        coverImageURL: String? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.pdfURL = pdfURL
        self.chapters = []
        self.authorID = authorID
        self.genre = genre
        self.language = language
        self.coverImageURL = coverImageURL
        self.uploadDate = Date()
        self.status = .draft
        self.listeners = []
        self.rating = nil
    }
    
    static func == (lhs: Book, rhs: Book) -> Bool { lhs.id == rhs.id }
}

// MARK: - Listener Model
struct Listener: Equatable, Codable {
    let id: UUID
    var name: String
    var email: String
    var profileImageURL: String?
    var favorites: [UUID] // Book IDs
    var listeningHistory: [ListeningRecord]
    var playlists: [Playlist]
    
    init(name: String, email: String, profileImageURL: String? = nil) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.profileImageURL = profileImageURL
        self.favorites = []
        self.listeningHistory = []
        self.playlists = []
    }
    
    mutating func addFavorite(_ bookID: UUID) {
        if !favorites.contains(bookID) {
            favorites.append(bookID)
        }
    }
    
    mutating func removeFavorite(_ bookID: UUID) {
        favorites.removeAll { $0 == bookID }
    }
    
    mutating func updateProgress(for bookID: UUID, position: TimeInterval) {
        if let index = listeningHistory.firstIndex(where: { $0.bookID == bookID }) {
            listeningHistory[index].lastPlayedPosition = position
            listeningHistory[index].lastPlayedDate = Date()
        } else {
            listeningHistory.append(ListeningRecord(bookID: bookID, lastPlayedPosition: position))
        }
    }
    
    static func ==(lhs: Listener, rhs: Listener) -> Bool { lhs.id == rhs.id }
}

// MARK: - Listening Record
struct ListeningRecord: Equatable, Codable {
    let bookID: UUID
    var lastPlayedPosition: TimeInterval
    var lastPlayedDate: Date
    
    init(bookID: UUID, lastPlayedPosition: TimeInterval) {
        self.bookID = bookID
        self.lastPlayedPosition = lastPlayedPosition
        self.lastPlayedDate = Date()
    }
    
    static func ==(lhs: ListeningRecord, rhs: ListeningRecord) -> Bool { lhs.bookID == rhs.bookID }
}

// MARK: - Playlist Model
struct Playlist: Equatable, Codable {
    let id: UUID
    var name: String
    var bookIDs: [UUID]
    
    init(name: String, bookIDs: [UUID] = []) {
        self.id = UUID()
        self.name = name
        self.bookIDs = bookIDs
    }
    
    mutating func addBook(_ bookID: UUID) {
        if !bookIDs.contains(bookID) {
            bookIDs.append(bookID)
        }
    }
    
    mutating func removeBook(_ bookID: UUID) {
        bookIDs.removeAll { $0 == bookID }
    }
    
    static func == (lhs: Playlist, rhs: Playlist) -> Bool { lhs.id == rhs.id }
}

// MARK: - Book Data Model (Persistence)
class BookDataModel {
    
    static let shared = BookDataModel()
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let archiveURL: URL
    
    private var books: [Book] = []
    
    private init() {
        archiveURL = documentsDirectory.appendingPathComponent("books").appendingPathExtension("plist")
        loadBooks()
    }
    
    func getAllBooks() -> [Book] { books }
    
    func addBook(_ book: Book) {
        books.append(book)
        saveBooks()
    }
    
    func updateBook(_ book: Book) {
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books[index] = book
            saveBooks()
        }
    }
    
    func deleteBook(at index: Int) {
        books.remove(at: index)
        saveBooks()
    }
    
    func getBooks(for authorID: UUID) -> [Book] {
        books.filter { $0.authorID == authorID }
    }
    
    func getPublishedBooks() -> [Book] {
        books.filter { $0.status == .published }
    }
    
    // MARK: - Persistence
    private func loadBooks() {
        if let savedBooks = loadBooksFromDisk() {
            books = savedBooks
        } else {
            books = []
        }
    }
    
    private func loadBooksFromDisk() -> [Book]? {
        guard let codedBooks = try? Data(contentsOf: archiveURL) else { return nil }
        let decoder = PropertyListDecoder()
        return try? decoder.decode([Book].self, from: codedBooks)
    }
    
    private func saveBooks() {
        let encoder = PropertyListEncoder()
        let codedBooks = try? encoder.encode(books)
        try? codedBooks?.write(to: archiveURL, options: .noFileProtection)
    }
}

// MARK: - Global App Data Model
class AppDataModel {
    static let shared = AppDataModel()
    
    private(set) var authors: [Author] = []
    private(set) var listeners: [Listener] = []
    
    private init() {}
    
    func addAuthor(_ author: Author) {
        authors.append(author)
    }
    
    func addListener(_ listener: Listener) {
        listeners.append(listener)
    }
    
    func getListener(by id: UUID) -> Listener? {
        listeners.first { $0.id == id }
    }
    
    func updateListener(_ listener: Listener) {
        if let index = listeners.firstIndex(where: { $0.id == listener.id }) {
            listeners[index] = listener
        }
    }
}

// MARK: - Mock Data (For Testing)
extension Book {
    static func sampleBooks() -> [Book] {
        let author = Author(name: "Matt Haig", email: "matt@example.com")
        return [
            Book(
                title: "The Midnight Library",
                description: "A beautiful novel about regret and second chances.",
                pdfURL: "midnightlibrary.pdf",
                authorID: author.id,
                genre: "Fiction",
                language: "English",
                coverImageURL: "midnightlibrary.jpg"
            ),
            Book(
                title: "Atomic Habits",
                description: "An easy and proven way to build good habits and break bad ones.",
                pdfURL: "atomichabits.pdf",
                authorID: author.id,
                genre: "Self-Help",
                language: "English",
                coverImageURL: "atomichabits.jpg"
            )
        ]
    }
}
