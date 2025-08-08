import UIKit

class Shoe: CustomStringConvertible {
    let color: String
    let size: Int
    let hasLaces: Bool
    
    init(color: String, size: Int, hasLaces: Bool) {
        self.color = color
        self.size = size
        self.hasLaces = hasLaces
    }
    var description: String {
        return "Shoe: \(color), \(size) size, \(hasLaces ? "has" : "does not have") laces"
    }
}
let myShoe = Shoe(color: "black", size: 10, hasLaces: true)
print(myShoe)

print("*******")

struct Book: CustomStringConvertible {
    var title: String
    var author: String
    
    var description: String {
        return "Book-Title \(title), Book-Author \(author)"
    }
}
let b1 = Book(title: "The Alchemist", author: "Paulo Coelho")
print(b1.title)
print(b1.author)
print(b1)

struct Employee: Equatable {
    let firstName: String
    let lastName: String
    let jobTitle: String
    let phoneNumber: String
    
    static func == (lhs: Employee, rhs: Employee) -> Bool {
        return lhs.firstName == rhs.firstName &&
        lhs.lastName == rhs.lastName &&
        lhs.jobTitle == rhs.jobTitle &&
        lhs.phoneNumber == rhs.phoneNumber
    }
}

let currentEmp = Employee(firstName: "John", lastName: "Loyd", jobTitle: "Software Engineer", phoneNumber: "+1234567890")
let selectedEmp = Employee(firstName: "John", lastName: "Loyd", jobTitle: "Software Engineer", phoneNumber: "+1234567890")

if currentEmp == selectedEmp {
    print("Both are same")
}

print("*****")

struct newBook: Equatable, Comparable {
    let title: String
    let author: String
    
    static func == (lhs: newBook, rhs: newBook) -> Bool {
        return lhs.title == rhs.title &&
        lhs.author == rhs.author
    }
    
    static func < (lhs: newBook, rhs: newBook) -> Bool {
        return lhs.author < rhs.author &&
        lhs.title < lhs.title
    }
}
let b_1 = newBook(title: "Will", author: "Will Smith")
let b_2 = newBook(title: "Marlon", author: "Will Smithee")

if b_1 == b_2 {
    print("Both are same")
}
else if b_1.title != b_2.title {
    print("Both are not same")
}
else if b_1.author < b_2.author {
    print("First book's author is alphabetically smaller")
}
