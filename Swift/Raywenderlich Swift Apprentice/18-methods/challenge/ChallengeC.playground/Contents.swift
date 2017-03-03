import UIKit

// The `Car` class you saw earlier in the chapter needs an attribute to describe movement:
// 1. Add a property called `speed`.
// 2. Ensure that `speed` can only be assigned internally from the class. W
// 3. Write two methods: `accelerate()`, which sets the speed to 20, and `applyBrakes()`, which sets the speed to 0.

class Car {
  let make: String
  private(set) var color: String
  // Add a property with a default value becasue it will always be the same no matter which initializer is used
  // Make the property `private(set)` so that it cannot be assigned outside the class
  private(set) var speed = 0
  init() {
    make = "Ford"
    color = "Black"
  }
  required init(make: String, color: String) {
    self.make = make
    self.color = color
  }
  func paint(color c: String) {
    self.color = c
  }
  func accelerate() {
    speed = 20
  }
  func applyBrakes() {
    speed = 0
  }
}
// 5
let car = Car(make: "Acura", color: "Blue")
var speed = car.speed // 0
car.accelerate()
speed = car.speed // 20
car.applyBrakes()
speed = car.speed // 0
