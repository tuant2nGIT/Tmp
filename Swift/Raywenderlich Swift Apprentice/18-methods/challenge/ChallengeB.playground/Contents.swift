import UIKit



// In the chapter, you were shown a naive way of writing `advance()` for the `Date` structure. What happens when the function should go from the end of one month to the start of the next? Rewrite `advance()` to account for advancing from December 31st to January 1st.

enum Month: Int {
  case January = 1, February, March, April, May, June,
  July, August, September, October, November, December

  // A computed property provides the number of days in each month
  var days: Int {
    switch self {
    case .January, .March, .May, .July, .August, .October, .December:
      return 31
    case .April, .June, .September, .November:
      return 30
    case .February:
      return 28
    }
  }
}

struct Date {
  var month: Month
  var day: Int
  init(month: Month, day: Int) {
    self.month = month
    self.day = day
  }
  mutating func advance() {
    // Check for the end of the month
    if day == month.days {
      // Check for the end of the year
      if month == .December {
        month = .January
      } else {
        // Increment the month
        month = Month(rawValue: month.rawValue + 1)!
      }
      // Start over at the first day of the month
      day = 1
    } else {
      // It is not the end of the month, just increment the day
      day++
    }
  }
}

var current = Date(month: .December, day: 31)
current.advance()
let currentMonth = current.month // January
let currentDay = current.day // 1
