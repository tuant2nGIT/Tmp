import UIKit

// Rewrite the `IceCream` class to use default values and lazy initialization.
// 1. Change the values in the initializer to default values for the properties.
// 2. Lazily initialize the `ingredients` array.

class IceCream {
  var name = "Plain"
  lazy var ingredients: [String] = {
    return ["sugar", "milk"]
    }()

  init () {
  }
}

let iceCream = IceCream()
// ingredients not yet initialized
iceCream.ingredients.append("strawberries")
// ingredients initialized before appending
iceCream.name = "Strawberry"
