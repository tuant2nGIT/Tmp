import Foundation
import Darwin

//:
//: A simple distance calculation
//:

let latitude: Double = 44.9871
let longitude: Double = -93.2758
let range: Double = 200.0

func isInRange(lat: Double, long: Double) -> Bool {
  // And you thought in Math class you would never use the Pythagorean theorem!
  let difference = sqrt(pow((latitude - lat), 2) + pow((longitude - long), 2))
  let distance = difference * 0.002
  return distance < range
}

//:
//: Adding a second location adds complexity
//:

let latitude_1: Double = 44.9871
let longitude_1: Double = -93.2758

let latitude_2: Double = 44.9513
let longitude_2: Double = -93.0942

let range2: Double = 200.0

func isInRange2(lat: Double, long: Double) -> Bool {
  // And you thought in Math class
  // you would never use the Pythagorean theorem!
  let difference = sqrt(pow((latitude - lat), 2) + pow((longitude - long), 2))
  let distance = difference * 0.002
  return distance < range
}

//: Introducing your first structure

struct Location {
  let latitude: Double
  let longitude: Double
}

let pizzaLocation =
Location(latitude: 44.9871, longitude: -93.2758)

//: Add another struct, to contain the location as well as the range

struct DeliveryRange {
  var range: Double
  let center: Location
}

let storeLocation =
Location(latitude: 44.9871, longitude: -93.2758)

var pizzaRange =
DeliveryRange(range: 200, center: storeLocation)

//
//: Accessing members
//

pizzaRange.range

pizzaRange.center.latitude

pizzaRange.range = 250

//:
//:
//:

let constPizzaRange =
DeliveryRange(range: 200, center: storeLocation)

// Error: change ‘let’ to ‘var’ to make it mutable
//constPizzaRange.range = 250

//
//: Struct Initializers
//


struct Location2 {
  let latitude: Double
  let longitude: Double

  // String in GPS format “44.9871,-93.2758”
  init(coordinateString: String) {
    let crdSplit = coordinateString.characters.split(isSeparator: {$0 == "," })
    latitude = atof(String(crdSplit.first!))
    longitude = atof(String(crdSplit.last!))
  }
}


let coords = Location2(coordinateString: "44.9871,-93.2758")
print(coords.latitude) // 44.9871
print(coords.longitude) // -93.2758

struct Order {
  var toppings: [String]
  var size: String
  var crust: String

  init(toppings: [String], size: String, crust: String) {
    self.toppings = toppings
    self.size = size
    self.crust = crust
  }

  init(size: String, crust: String) {
    self.toppings = ["Cheese"]
    self.size = size
    self.crust = crust
  }

  init(special: String) {
    self.size = "Large"
    self.crust = "Regular"

    if special == "Veggie" {
      self.toppings = ["Cheese", "Tomatoes", "Green Pepper", "Mushrooms"]
    } else if special == "Meat" {
      self.toppings = ["Sausage", "Pepperoni", "Ham", "Bacon"]
    } else {
      self.toppings = ["Cheese"]
    }
  }
}

//:
//: Initializer Rules
//:



struct ClimateControl {
  var temperature: Double
  var humidity: Double?

  init(temp: Double) {
    temperature = temp
  }

  init(temp: Double, hum: Double) {
    temperature = temp
    humidity = hum
  }
}

let ecoMode = ClimateControl(temp: 75.0)
let dryAndComfortable = ClimateControl(temp: 71.0, hum: 30.0)

struct ClimateControl2 {
  var temperature: Double = 68.0
  var humidity: Double?
}

let defaultClimate = ClimateControl2()
print(defaultClimate.temperature) // 68.0

//:
//: Introducing Methods
//:

struct DeliveryRange3 {
  var range: Double
  let center: Location2

  func isInRange(customer: Location2) -> Bool {
    let difference = sqrt(pow((latitude - center.latitude), 2) +
      pow((longitude - center.longitude), 2))
    return difference < range
  }
}

let range3 = DeliveryRange3(range: 150, center: Location2(coordinateString: "44.9871,-93.2758"))

let customer3 = Location2(coordinateString: "44.9850,-93.2750")

range3.isInRange(customer3) // true!

//:
//: Extensions
//:

extension Location2 {
  func isNorthernHemisphere() -> Bool {
    return latitude > 0.0
  }
}

let location = Location2(coordinateString: "44.9850,-93.2750")
location.isNorthernHemisphere()

//:
//: Structs as values
//:

// Assign the literal ‘5’ into a, an Int.
var a: Int = 5

// Assign the value in a to b.
var b: Int = a

print(a) // 5
print(b) // 5

// Assign the value ’10’ to a
a = 10

// a now has ’10’, b still has ‘5’
print(a) // 10
print(b) // 5


var r1: DeliveryRange3 = DeliveryRange3(range: 200, center: Location2(coordinateString: "44.9871,-93.2758"))

// Assign the value in range1 to range2
var r2: DeliveryRange3 = r1

print(r1.range) // 200
print(r2.range) // 200

// Modify the range of range1 to ‘100’
r1.range = 100

// range1 now has ’100’, b still has ‘200’
print(r1.range) // 100
print(r2.range) // 200
