//
//  ToDo.swift
//  ToDoList
//
//  Created by student on 01/09/25.
//


import Foundation

struct ToDo: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?

    init(id: UUID = UUID(), title: String, isComplete: Bool = false, dueDate: Date = Date(), notes: String? = nil) {
        self.id = id
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
    }
}

final class ToDoDataModel {
    static let shared = ToDoDataModel()
    private var todos: [ToDo]

    private init() {
        todos = [
            ToDo(title: "ToDo One", isComplete: false, dueDate: Date(), notes: "Notes 1"),
            ToDo(title: "ToDo Two", isComplete: false, dueDate: Date(), notes: "Notes 2"),
            ToDo(title: "ToDo Three", isComplete: false, dueDate: Date(), notes: "Notes 3")
        ]
    }

    func getToDos() -> [ToDo] {
        return todos
    }

    func add(_ todo: ToDo) {
        todos.append(todo)
    }

    func update(_ todo: ToDo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
        }
    }

    func remove(id: UUID) {
        todos.removeAll { $0.id == id }
    }
}

// MARK: - Persistence

struct ToDo: Codable {
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("todos").appendingPathExtension("plist")
    
    static func loadToDos() -> [ToDo]? {
        guard let codedToDos = try? Data(contentsOf: ArchiveURL) else { return nil }
        
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<ToDo>.self, from: codedToDos)
    }
    
    static func loadSampleToDos() -> [ToDo] {
        return [
            ToDo(title: "ToDo One", isComplete: false, dueDate: Date(), notes: "Notes 1"),
            ToDo(title: "ToDo Two", isComplete: false, dueDate: Date(), notes: "Notes 2"),
            ToDo(title: "ToDo Three", isComplete: false, dueDate: Date(), notes: "Notes 3")
        ]
    }
    
    static func saveToDos(_ todos: [ToDo]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(todos)
        try? codedToDos?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}
