import UIKit

// Problem Statement- Versions tracker protocol challange

// You are building a Versiion Tracker for a software product. A verson number consists of a major and a minor integer value, and should support:
// 1. Printing a user-friendlly versoin string
// 2. Comparing version to dertemine which one is newer
// 3. Sorting a collection of versions


struct Version: Comparable, CustomStringConvertible {
    let major: Int
    let minor: Int
  
    static func < (lhs: Version, rhs: Version) -> Bool {
        if lhs.major == rhs.major {
            return lhs.minor < rhs.minor
        }
        return lhs.major < rhs.major
    }
    
    var description: String {
        return "\(major).\(minor)"
    }
}

let v1 = Version(major: 1, minor: 2)
let v2 = Version(major: 2, minor: 3)
let v3 = Version(major: 1, minor: 1)
let v4 = Version(major: 2, minor: 1)
let v5 = Version(major: 1, minor: 3)

var versions: [Version] = [v1, v2, v3, v4, v5]

versions.sort(by : <)

print("Version count: \(versions.count)")
print()

print(v1 == v2)
print(v1 == v3)
print(v1 == v4)
print(v3 == v5)

print()

print("List of Versions:")
var count = 1
for v in versions {
    print("v\(count): \(v)")
    count += 1
}
