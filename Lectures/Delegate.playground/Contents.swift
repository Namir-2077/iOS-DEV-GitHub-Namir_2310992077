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
 
struct Maid: DoChores {
        func doChores() {
            print("Maid did the cleaning!")
        }
    }
    
}

var child = Child()
var maid = Maid()

var parent = Parent(delegate: child)
parent.delegate?.doChores()

parent = Parent(delegate: maid)
parent.delegate?.doChores()
