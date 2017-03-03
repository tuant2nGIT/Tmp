import Foundation

// Challenge A
var name: String? = "Ray"
//var age: Int = nil // <-- INVALID
let distance: Float = 26.7
var middleName: String? = nil


// Challenge B
func divideIfWhole(value: Int, by divisor: Int) -> Int? {
  if value % divisor == 0 {
    return value / divisor
  } else {
    return nil
  }
}

if let answer = divideIfWhole(10, by: 2) {
  print("Yep, it divides \(answer) times.")
} else {
  print("Not divisible :[.")
}

if let answer = divideIfWhole(10, by: 3) {
  print("Yep, it's divideIfWhole \(answer) times.")
} else {
  print("Not divisible :[.")
}


// Challenge C
let answer1 = divideIfWhole(10, by: 2) ?? 0
print("It divides \(answer1) times.")

let answer2 = divideIfWhole(10, by: 3) ?? 0
print("It divides \(answer2) times.")
