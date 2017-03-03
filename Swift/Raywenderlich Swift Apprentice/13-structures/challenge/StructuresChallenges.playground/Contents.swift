import Foundation

//:
//: ## Challenge A: Clothing your structs
//:
//: Create a T-shirt struct that has size, color and material options. Provide methods to calculate the cost of a shirt based on its attributes.

let Small = "Small"
let Medium = "Medium"
let Large = "Large"
let XLarge = "XLarge"

let Cotton = "Cotton"
let Polyester = "Polyester"
let Wool = "Wool"

struct TShirt {
  let size: String
  let color: String
  let material: String

  // Note: Using a Float is good for demonstrations, but you should not use Floats or
  // Doubles for currency!
  //
  // Read http://stackoverflow.com/questions/3730019/why-not-use-double-or-float-to-represent-currency
  func cost() -> Double {

    let basePrice = 10.0

    let sizeMultiplier: Double
    switch size {
    case Small, Medium:
      sizeMultiplier = 1.0
    case Large, XLarge:
      sizeMultiplier = 1.1
    default:
      // Special order!
      sizeMultiplier = 1.2
    }

    let materialMultipler: Double
    switch material {
    case Cotton:
      materialMultipler = 1.0
    case Polyester:
      materialMultipler = 1.1
    case Polyester:
      materialMultipler = 1.5
    default:
      // Special order!
      materialMultipler = 2.0
    }

    return basePrice * sizeMultiplier * materialMultipler
  }
}

TShirt(size: Medium, color: "Green", material: Cotton).cost()
TShirt(size: XLarge, color: "Gray", material: Wool).cost()



//:
//: ## Challenge B: Battling ships
//:
//: Write the engine for a Battleship-like game. If you aren't familiar with Battleship, see here: http://abt.cm/1YBeWms
//:
//: • Use an (x, y) coordinate system for your locations.
//:
//: • Make a struct for each ship. Record an origin, direction and length.
//:
//: • Each ship should be able to report if a “shot” has resulted in a “hit” or is off by 1.


struct Coordinate {
  let x: Int
  let y: Int
}

struct Ship {
  let origin: Coordinate
  let direction: String
  let length: Int

  func isHit(coordinate: Coordinate) -> Bool {
    if direction == "Right" {
      return origin.y == coordinate.y &&
        coordinate.x >= origin.x &&
        coordinate.x - origin.x < length
    } else {
      return origin.x == coordinate.x &&
        coordinate.y >= origin.y &&
        coordinate.y - origin.y < length
    }
  }
}

struct Board {

  var ships: [Ship] = []

  func fire(location: Coordinate) -> Bool {
    for ship in ships {
      if ship.isHit(location) {
        print("Hit!")
        return true
      }
    }

    return false
  }
}

let patrolBoat = Ship(origin: Coordinate(x: 2, y: 2), direction: "Right", length: 2)
let battleship = Ship(origin: Coordinate(x: 5, y: 3), direction: "Down", length: 4)
let submarine = Ship(origin: Coordinate(x: 0, y: 0), direction: "Down", length: 3)

var board = Board()
board.ships.appendContentsOf([patrolBoat, battleship, submarine])

// patrolBoat
board.fire(Coordinate(x: 2, y: 2))

// miss
board.fire(Coordinate(x: 2, y: 3))

// end of battleship
board.fire(Coordinate(x: 5, y: 6))

// miss (just past the end of battleship)
board.fire(Coordinate(x: 5, y: 7))
