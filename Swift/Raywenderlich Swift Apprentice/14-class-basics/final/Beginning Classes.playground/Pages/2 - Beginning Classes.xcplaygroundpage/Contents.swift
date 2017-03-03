//: [Previous](@previous)
//:
//: # Beginning Classes
//:
//: An introduction to classes in Swift

//: ## Creating Classes
//: // TODO - Narrative with chapter

//: ### Defining Classes

class Person {
  var firstName: String
  var lastName: String

  init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
  }

  func fullName() -> String {
    return "\(firstName) \(lastName)"
  }
}

let john = Person(firstName: "Johnny", lastName: "Appleseed")


//:
//: Working with references
//:

struct ClimateControl {
  var temperature: Double
  var humidity: Double
}

var homeSetting = ClimateControl(temperature: 71.0, humidity: 30.0)
var awaySetting = homeSetting

awaySetting.temperature = 63.0

print(homeSetting.temperature) // 71.0
print(awaySetting.temperature) // 63.0



var john2 = Person(firstName: "Johnny", lastName: "Appleseed")
var homeOwner = john2

john2.firstName = "John" // John wants to use his short name!

print(john2.firstName) // “John”
print(homeOwner.firstName) // “John”


//:
//: Identity
//:

var john3 = Person(firstName: "Johnny", lastName: "Appleseed")
var homeOwner2 = john3
var imposter = Person(firstName: "Johnny", lastName: "Appleseed")

print( john3 === homeOwner2 ) // true
print( john === imposter ) // false
print( imposter === homeOwner2 ) // false

homeOwner2 = imposter

print ( john3 === homeOwner2 ) // false

homeOwner2 = john3
print ( john3 === homeOwner2 ) // true

//:
//: Methods and mutability
//:

struct Grade {
  let letter: String
  let points: Double
  let credits: Double
}

class Student {
  var firstName: String
  var lastName: String
  var grades: [Grade] = []

  init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
  }

  // recordGrade mutates the state of Student,
  // by appending a new Grade
  func recordGrade(grade: Grade) {
    grades.append(grade)
  }
}


let jane = Student(firstName: "Jane", lastName: "Appleseed")
let history = Grade(letter: "B", points: 9.0, credits: 3.0)
let math = Grade(letter: "A", points: 16.0, credits: 4.0)

jane.recordGrade(history)
jane.recordGrade(math)

// Access control

public var publicString: String = "Everyone can see me!"

internal class InternalClass {
  private func sayHi() {
    print("Hi!")
  }

  func speak() {
    sayHi()
  }
}


print(publicString) // "Everyone can see me!"

let myClass = InternalClass()
// myClass.sayHi() // Build error if in another file
myClass.speak() // "Hi!"

class EncapsulatedStudent {
    var firstName: String
    var lastName: String

    // Making `grades` private prevents
    // accessing the array directly
    private var grades: [Grade] = []

    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }

    func recordGrade(grade: Grade) {
        if grade.letter == "F" &&
            (grades.contains { $0.letter == "F" }) {
          // Second F! Double-secret probation!
        }

        grades.append(grade)
    }
}
