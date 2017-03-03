/*:
### Swift Apprentice: Error Handling

http://www.raywenderlich.com/store/swift-apprentice

*/
import UIKit

enum RollingError: ErrorType {
  case Doubles
  case OutOfFunding
}

var hasFunding: Bool = true

func roll(firstDice: Int, secondDice: Int) throws {
  let error:RollingError

  if firstDice == secondDice && hasFunding == true {
    error = .Doubles
    hasFunding = false
    throw error
  } else if firstDice == secondDice && hasFunding == false {
    hasFunding = true
    print("Huzzah! You raise another round of funding!")
  } else if hasFunding == false {
    error = .OutOfFunding
    throw error
  } else {
    print("You moved \(firstDice + secondDice) spaces")
  }
}

func move(firstDice: Int, secondDice: Int) -> String {
  do {
    try roll(firstDice, secondDice: secondDice)
    return "Successful roll."
  } catch RollingError.Doubles {
    return "You rolled doubles and have lost your funding"
  } catch RollingError.OutOfFunding {
    return "You need to do another round of funding."
  } catch {
    return "Unknown error"
  }
}

move(3, secondDice: 4)
move(3, secondDice: 3)
move(5, secondDice: 2)
move(1, secondDice: 1)
