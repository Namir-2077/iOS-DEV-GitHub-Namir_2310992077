import UIKit

func sum(numbers: [Int]) -> Int {
    var sum = 0
    for numbers in numbers {
        sum += numbers
    }
    return sum
}


var sumClosure = { (numbers: [Int]) -> Int in
    var sum = 0
    for numbers in numbers {
        sum += numbers
    }
    return sum
}

print(sum(numbers: [1, 2, 3, 4, 5]))

print(sumClosure([1, 2, 3, 4, 5]))

let addClosure = {(firstInt: Int, secondInt: Int) -> Int in
    return firstInt + secondInt
}

func mathematicalOperations(_ firstInt: Int,_ secondInt: Int,_ addClosure: (Int, Int) -> Int) {
    print(addClosure(firstInt, secondInt))
}

mathematicalOperations(2, 3, {(firstInt: Int, secondInt: Int) -> Int in
    return firstInt * secondInt
})

mathematicalOperations(4, 3) { firstInt, secondInt in
    firstInt * secondInt
}

print( )

struct Track {
    var name: String
    var number: Int
    var ranking: Double
}

var tracks = [Track(name: "firstTrack", number: 1, ranking: 4.5), Track(name: "secondTrack", number: 2, ranking: 4.1), Track(name: "thirdTrack", number: 3, ranking: 3.9)]

var sortedTracks = tracks.sorted { $0.ranking < $1.ranking }

print(sortedTracks)

print( )

var firstNames = ["Aman", "Ramanjot", "Manpreet"]

var fullName = firstNames.map { $0 + " Singh" }

print(fullName)

var filteredNames = firstNames.filter {$0.count == 4}

print(filteredNames)
