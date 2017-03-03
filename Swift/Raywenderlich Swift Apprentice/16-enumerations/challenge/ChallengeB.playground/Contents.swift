import UIKit

// Taking the example from earlier in the chapter, begin with the `Month` enumeration:

enum Month: Int {
  case January = 1, February, March, April, May, June, July, August, September, October, November, December
}

// Write a function to calculate the number of months until summer, with the following signature: monthsUntilSummer(month: Month) -> Int

// Hint: you'll need to account for a negative value if summer has already passed. To do that, loop back around for the next full year.

func monthsUntilSummer(month: Month) -> Int {
  var monthsLeft = Month.June.rawValue - month.rawValue
  if monthsLeft < 0 {
    monthsLeft += 12
  }
  return monthsLeft
}
monthsUntilSummer(.November) // 7
