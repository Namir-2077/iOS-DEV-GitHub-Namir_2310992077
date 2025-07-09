import UIKit
var names: [String] = ["Namir", "Maximus", "Caesar", "Tron"]

names.contains("Caesar")
names.contains("Clu")

print(names.count)

print(names[3])

names[2] = "Troy"
print(names[2])

//append an array
names.append("Theodore")

names.insert("Ryan", at: 2)
print(names[2])

