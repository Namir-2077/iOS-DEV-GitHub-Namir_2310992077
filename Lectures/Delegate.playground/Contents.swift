import UIKit

//Delegate is special kind of Protocol.

//Delegation(Parent) -  "You ask someone else to do the work for you."

//Delegate(Child) - Object who does the 'work'.

protocol DoChores {
    func doChores()
}

struct Parent {
    var delegate: DoChores?
}

struct Child: DoChores {
    func doChores() {
        print("Child did the cleaning!")
    }
}

struct Maid: DoChores {
        func doChores() {
            print("Maid did the cleaning!")
        }
}

var child = Child()
var maid = Maid()

var parent = Parent(delegate: child)
parent.delegate?.doChores()

parent = Parent(delegate: maid)
parent.delegate?.doChores()




protocol Developer {
    func writeCode()
    func completeProject()
    func provideTestCase()
}

// This is a Delegate
class JavaDeveloper: Developer {
    func writeCode() {
        print("I can write Java Code")
    }
    
    func completeProject() {
        print("I can complete Java Project")
    }
    
    func provideTestCase() {
        print("I can provide Java Test Cases")
    }
}

// This is a Delegete
class SwiftDeveloper: Developer {
    func writeCode() {
        print("I can write Swift Code")
    }
    
    func completeProject() {
        print("I can complete Swift Project")
    }
    
    func provideTestCase() {
        print("I can provide Swift Test Cases")
    }
}


// This is a Delegator
class Manager {
    var developerDelegate: Developer?
    
    func teamManager() {
        
    }
    
    func goOnVacation() {
        
    }
}

var manager = Manager()

var javaDeveloper = JavaDeveloper()

var swiftDeveloper = SwiftDeveloper()

manager.developerDelegate = javaDeveloper
manager.developerDelegate?.writeCode()

manager.developerDelegate = swiftDeveloper
manager.developerDelegate?.writeCode()




//Practice Problem

//Coffee Machine & Payment Delegate
//A Coffee Machine does not handle payment itslef, it delegates payment responsibility to a payment system.

protocol PaymentDelegate {
    func makePayment()
    func getCoffee()
}

class coffeeMachine: PaymentDelegate {
    func makePayment() {
        print("Payment Accepeted")
    }
    
    func getCoffee() {
        print("Coffee is ready!")
    }
}


class PaymentSystem {
    var coffeeDelegate : PaymentDelegate?
    
    func makePayment(amount: Int) {
        print("Payment Processed")
    }
}

var pay = PaymentSystem()

var coffee = coffeeMachine()

pay.coffeeDelegate = coffee
pay.coffeeDelegate?.makePayment()
pay.coffeeDelegate?.getCoffee()
 
