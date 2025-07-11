import UIKit
/*guard (condition) else {
    return
}
This instructs the compiler to go ahead.
*/

class Animal {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

class Dog: Animal {
    func bark() {
        print("Woof!")
    }
}

class Cat: Animal {
    func meow() {
        print("Meow!")
    }
}

class Bird: Animal {
    func chirp() {
        print("Tweet!")
    }
}

var allPets: [Animal] = [Dog(name: "Leo"), Cat(name: "King"), Bird(name: "Penguin")]

func getClientPet(allPets: [Animal]) -> Animal {
    return allPets[2]
}

let pet = getClientPet(allPets: allPets)

