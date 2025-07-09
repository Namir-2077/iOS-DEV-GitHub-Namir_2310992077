import UIKit
struct size {
    var width: Double
    var height: Double
    
    func area() -> Double {
        let area = width * height
        print("The size of the desired shape is: \(area).")
        return area
    }
    
    mutating func newSize() {
        width += 1
        height += 1
    }
}
var size1 = size(width: 10.0, height: 20.0)
size1.area()
size1.newSize()
size1.area()
size1.newSize()
size1.area()
size1.newSize()
size1.area()

