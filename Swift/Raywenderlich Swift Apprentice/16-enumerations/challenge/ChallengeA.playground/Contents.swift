import UIKit

// Taking the coin example from earlier in the chapter, begin with an array of coins.

enum Coin: Int {
  case Penny = 1
  case Nickel = 5
  case Dime = 10
  case Quarter = 25
}

let coinPurse: [Coin] = [.Dime, .Quarter, .Penny, .Penny, .Nickel, .Nickel]

// Write a function where you can pass in the `coinPurse`, add up the value and return the number of cents.

func purseValue(coinPurse: [Coin]) -> Int{
  var purseBalance = Int()
  for coin in coinPurse {
    purseBalance += coin.rawValue
  }
  return purseBalance
}

purseValue(coinPurse) // 47

// An advanced way to do the same thing would be to use higher order function `reduce(_:combine:)`:

let quickPurseValue = coinPurse.reduce(0) { $0 + $1.rawValue }
quickPurseValue // 47
