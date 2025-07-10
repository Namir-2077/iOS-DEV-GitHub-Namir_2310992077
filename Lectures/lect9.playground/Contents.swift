import UIKit
struct Book {
    let name: String? //Optional String
    let announcementYear: Int? //Optional Int
}

let firstBook = Book(name: "First Book", announcementYear: 2023)

let secondBook = Book(name: "Second Book", announcementYear: 2024)

let books = [firstBook, secondBook]
//let books: [Book]? = [firstBook, secondBook] "Optional Array of 'Book'!!!"

let thirdBook = Book(name: "Third Book", announcementYear: nil)

if (thirdBook.announcementYear != nil) {
    print(thirdBook.announcementYear!) //'(!)' sign used to "Force-Unwrap" {as well}
}
else {
    print("Publication year not available yet")
}

//************//

//Optional Chaining:
struct Person {
    var age: Int
    var residence: Residence?
}

struct Residence {
    var address: Address?
}

struct Address {
    var buildingNumber: String?
    var streetName: String?
    var apartmentNumber: String?
}

let firstPerson = Person(age: 20, residence: Residence(address: Address(buildingNumber: "A3 Block", streetName: "Sunset Boulevaurd", apartmentNumber: "157")))

if let residenceOfFirstPerson = firstPerson.residence {
    if let address = residenceOfFirstPerson.address {
        if let apartmentNumber = address.apartmentNumber {
            print(apartmentNumber)
        }
    }
}

if let apartmentNumber = firstPerson.residence?.address?.apartmentNumber {
    print(apartmentNumber)
}
