import UIKit
struct PersonStruct {
    var name: String = ""
}

var structInstance = PersonStruct(name: "Namir")


class PersonClass {
    var name: String = ""
    
    init(name: String)
    {
        self.name = name
    }
    func sayHello() {
        print("Hola, my name is \(self.name)")
    }
}
var classInstance = PersonClass(name: "Namir")
classInstance.sayHello()
print(MemoryLayout<PersonClass>.size)
print(MemoryLayout<PersonStruct>.size)

withUnsafePointer(to: &classInstance) { ptr in
    print(ptr)
}
withUnsafePointer(to: &structInstance) { ptr in
    print(ptr)
}


class Vehicle {
    var currentSpeed = 0.0
    
    var description: String {
       "Travelling at \(currentSpeed) miles per hour,"
    }
    
    func makeNoise() {
        //does nothing cause generally, a vehicle does not make a noise
    }
}

class Bicycle: Vehicle {
   var hasBasket = false
}

class Tandem: Bicycle {
    var currentNumberOfPassengers = 0
}

class Train: Vehicle {
    override func makeNoise() {
        print("Choo Choo!!!")
    }
}

class Car: Vehicle {
    var gear = 1
    override var description: String {
        super.description + " in gear \(gear)"
    }
}

let vehicle1 = Vehicle()
print(vehicle1.description)

let b1 = Bicycle()
print(b1.description)

let T1 = Train()
T1.makeNoise()

let car1 = Car()
var currentSpeed = 15
print(car1.description)  
