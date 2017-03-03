import UIKit

var numbers = [1, 2, 3]
numbers.removeLast()
let newArray = numbers // [1, 2]






enum Month: Int {
  case January = 1, February, March, April, May, June,
  July, August, September, October, November, December

  var monthsUntilWinterBreak: Int {
    return Month.December.rawValue - self.rawValue
  }

  // 1
  init() {
    // 2
    self = .March
  }
}

let month = Month() // January
let monthsLeft = month.monthsUntilWinterBreak // 9






struct Date {
  var month: Month
  var day: Int
  init() {
    month = .January
    day = 1
  }
  init(month: Month, day: Int) {
    self.month = month
    self.day = day
  }
  // 1
  mutating func advance() {
    // 2
    day++
  }
}

let date = Date(month: .February, day: 14)
let dateMonth = date.month // February
let dateDay = date.day // 14







class Car {
  // 1
  let make: String
  // 2
  private(set) var color: String
  init() {
    make = "Ford"
    color = "Black"
  }
  required init(make: String, color: String) {
    self.make = make
    self.color = color
  }
  // 3
  func paint(color: String) {
    self.color = color
  }
}

let car = Car(make: "Tesla", color: "Red")
car.paint("Blue")






struct Utils {
  // 1
  static func factorial(number: Int) -> Int {
    // 2
    return (1...number).reduce(1, combine: *)
  }
  static func nthtriangle(number: Int) -> Int {
    return (1...number).reduce(1, combine: +)
  }
}
let factorial = Utils.factorial(6) // 720
