import UIKit

// List out all the months in a year
enum Month: Int {
  case January = 1, February, March, April, May, June, July,
  August, September, October, November, December
}

// Figure out which semester the month belongs
func schoolSemester(month: Month) -> String {
  switch month {
  case .August, .September, .October, .November, .December:
    return "Autumn"
  case .January, .February, .March, .April, .May:
    return "Spring"
  default:
    return "Not in the school year"
  }
}

// Print out the result in the playground sidebar
var month = Month.April
month = .September
schoolSemester(month) // "Autumn"


func monthsUntilWinterBreak(month: Month) -> Int {
  return Month.December.rawValue - month.rawValue
}
monthsUntilWinterBreak(.April) // 8

if let fifthMonth = Month(rawValue: 5) {
  monthsUntilWinterBreak(fifthMonth)  // 7
}




enum Coin: Int {
  case Penny = 1
  case Nickel = 5
  case Dime = 10
  case Quarter = 25
}

let coin = Coin.Quarter
coin.rawValue // 25





enum WithdrawalResult {
  case Success(Int)
  case Error(String)
}

var balance = 100

func withdraw(amount: Int) -> WithdrawalResult {
  if amount <= balance {
    balance -= amount
    return .Success(balance)
  } else {
    return .Error("Not enough money!")
  }
}

let result = withdraw(99)

switch result {
case let .Success(newBalance):
  print("Your new balance is: \(newBalance)")
case let .Error(message):
  print(message)
}





enum HTTPMethod {
  case GET
  case POST(String)
}





enum TrafficLight {
  case Red, Yellow, Green
}
let trafficLight = TrafficLight.Red




var age: Int?
age = 17
age = nil

let email: Optional<String> = .None
let website: Optional<String> = .Some("raywenderlich.com")

switch website {
case .None:
  print("No value")
case let .Some(value):
  print("Got a value! \(value)")
}

let optionalNil: Optional<Int> = .None

optionalNil == nil    // true
optionalNil == .None  // true
