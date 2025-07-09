import UIKit
let temperature = 75
switch temperature {
case 65...75:
    print("The temperature is just right.")
case ..<65:
    print("It's too cold.")
default:
    print("It's too hot.")
}
print("**************")
