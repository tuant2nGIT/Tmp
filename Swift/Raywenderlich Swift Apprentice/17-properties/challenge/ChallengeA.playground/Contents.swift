import UIKit

// Given the `Month` enumeration you saw earlier in the chapter, rewrite `schoolSemester()` as a computed property instead of a method:


enum Month {
  case January, February, March, April, May, June, July, August,
  September, October, November, December

  var schoolSemester: String {
    switch self {
    case .August, .September, .October, .November, .December:
      return "Autumn"
    case .January, .February, .March, .April, .May:
      return "Spring"
    default:
      return "Not in the school year"
    }
  }
}

let month = Month.February
month.schoolSemester // Spring
