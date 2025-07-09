import UIKit
var names: [String] = ["Namir", "Maximus", "Caesar", "Tron"]

names.contains("Caesar")
names.contains("Clu")

print(names.count)

print(names[3])

names[2] = "Troy"
print(names[2])
print(names)

//append an array
names.append("Theodore")

names.insert("Ryan", at: 2)
print(names[2])
print(names)

names.remove(at: 2)
print(names)

//to remove the last element of an array use: "names.removeLast()"
//to remove all the elements of an array use: "names.removeAll()"

let arr1 = [1, 2, 3]
let arr2 = [4, 5, 6]
let containerArr = [arr1, arr2]
print(containerArr[0])
print(containerArr[0][0])


//Dictionary:
var scores = ["Richard": 500, "Luke": 400, "Cheryl": 900]
scores["Oli"] = 699
scores.updateValue(580, forKey: "Luke")
print(scores)
if let oldValue = scores.updateValue(580, forKey: "Luke") {
    print("Luke's old value was \(oldValue)")
}

scores.removeValue(forKey: "Oli")
print(scores)

if let removeValue = scores.removeValue(forKey: "Oli") {
    print("Value Removed \(removeValue)")
}

let names1 = Array(scores.keys) //Storing individual dictionary as an array
let points = Array(scores.values)
print(names1)
print(points)


//Loops:

//For Loop:
for i in 1...5 {
    print("i: \(i)") //Closed Range Operator '...' that means it will include '5' as well
}

print("*************")

for i in 1..<5 {
    print("i: \(i)") //Half Range Operator '..<' that means it won't include '5'
}

for name in names {
    print("Hello \(name)!!!")
}

for letter in "ABCDEFGH" {
    print("The Letter is: \(letter)")
}

print("*************")

for (index, letter) in "ABCDEFGH".enumerated() {
    print("The Letter is: \(letter) at index: \(index)")
}

let vehicles = ["Unicycle": 1, "Bicycle": 2, "Tricycle": 3, "Car": 4]
for (vehicleName, wheelCount) in vehicles {
    print(vehicleName + " has \(wheelCount) wheels")
}


//While:
var numLives = 9

while numLives > 0 {
    print("You have \(numLives) lives left!")
    numLives -= 1
}

print("*************")

//Repeat: (Do-While)
var steps = 0

repeat {
    print("Number Of Steps: \(steps)")
    steps += 10
} while steps < 30

//Break:
for counter in -3...3 {
    print(counter)
    
    if counter == 0 {
        break
    }
}
print("Ended The Loop")
