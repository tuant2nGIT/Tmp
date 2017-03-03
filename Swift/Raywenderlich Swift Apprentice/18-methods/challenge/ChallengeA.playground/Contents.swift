import UIKit

// Given the `Circle` structure, write a method that can change an instance's area by a growth factor. For example if you call `circle.growByAFactor(3), the area of the instance will triple.
// Hint: Make use of the setter for `area`.

class Circle {
  var radius: Double = 0
  var area: Double {
    get {
      return M_PI * radius * radius
    }
    set {
      radius = sqrt(newValue / M_PI)
    }
  }

  init (radius: Double) {
    self.radius = radius
  }

  func growByAFactor(factor: Double) {
    area = area * factor
  }
}

let circle = Circle(radius: 5)
let originalCircleArea = circle.area // 78.54
circle.growByAFactor(3)
let newCircleArea = circle.area // 235.62
