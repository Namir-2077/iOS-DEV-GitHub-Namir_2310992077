import UIKit
var greeting = "Hello there!"
var myString: String = ""
if myString.isEmpty {
    print("The string is empty")
}
let name = "Bond"
let age = 36
print("\(name), is \(age) years old.")
// The language is case-sensitive!
let count = name.count
print(count)
print("∞".count)

func multiply(firstNumber: Int, secondNumber: Int) -> Int {
    let result = firstNumber * secondNumber
    print(result)
    return result
}
multiply(firstNumber: 10, secondNumber: 20)

func sayWattup(_ to: String, anotherPerson: String = "Julius") {
    print("Wattup \(to) and \(anotherPerson)? How you doin?")
}
sayWattup("Maximus")
