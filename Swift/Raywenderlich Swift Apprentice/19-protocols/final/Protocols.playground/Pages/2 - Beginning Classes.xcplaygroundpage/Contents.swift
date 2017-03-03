//: ### Defining Protocols

class Person {
  var firstName: String
  var lastName: String

  init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
  }
}

class Student: Person {

}

class Teacher {

}

struct Sport {
  var name: String
}

//:
//: Coach and StudentAthlete are diverged in the class hierearchy,
//: but with protocols they can share a common type
//:

protocol TeamMember {
  func play()
  var role: String { get }
}

class StudentAthlete: Student, TeamMember {

  func play() {
    print("Play the game!")
  }

  var role: String {
    return "Player"
  }
}

class Coach: Teacher, TeamMember{
  func play() {
    print("Coach!")
  }

  var role: String {
    return "Coach"
  }
}

let roster: [TeamMember] = [
  Coach(),
  StudentAthlete(firstName: "Jane", lastName: "Appleseed"),
  StudentAthlete(firstName: "Johnny", lastName: "Appleseed")]

//: Protocol inheritance

protocol Animal {
  var name: String { get }
  func eat()
}

protocol Pet: Animal {
  func pet()
  func feed()
}

struct Lion: Animal {

  var name: String {
    return "Lion"
  }

  func eat() {
    print("Eat big steak!")
  }
}

struct Dog: Pet {

  var name: String {
    return "Dog"
  }

  func eat() {
    print("Puppy chow")
  }

  func pet() {
    print(" ˁ˚ᴥ˚ˀ ")
  }

  func feed() {
    print("Puppy wags tail in appreciation")
  }
}

let bigLion = Lion()
let puppy = Dog()

puppy.eat()
bigLion.eat()

puppy.feed()
// bigLion.feed() // Don't feed the animals!

//: Implementing protocols

//: The protocol can be applied to a class

class ClassyDog: Animal {

  var name: String {
    return "Dog"
  }

  func eat() {
    print("Puppy chow")
  }

  func pet() {
    print(" ˁ˚ᴥ˚ˀ ")
  }

  func feed() {
    print("Puppy wags tail in appreciation")
  }
}

//: Or a struct just the same!

struct StructyDog: Pet {

  var name = "Dog"

  func eat() {
    print("Puppy chow")
  }

  func pet() {
    print(" ˁ˚ᴥ˚ˀ ")
  }

  func feed() {
    print("Puppy wags tail in appreciation")
  }
}

//: Implementing multiple protocols

protocol Flyable {
  func fly()
}

struct Parrot: Pet, Flyable {
  var name = "Parrot"

  func fly() {
    print("Fly away!")
  }

  func eat() {
    print("Puppy chow")
  }

  func pet() {
    print(" ˁ˚ᴥ˚ˀ ")
  }

  func feed() {
    print("Puppy wags tail in appreciation")
  }
}

let parrot = Parrot()
let flyableParrot: Flyable = Parrot()
let petParrot: Pet = Parrot()

parrot.fly()
parrot.eat()
parrot.fly() // Pets by themselves don't fly!



//: Properties in protocols

protocol Collarable {
  var collarColor: String { get set }
}

struct Cat: Pet, Collarable {
  var collarColor: String = "Blue"
  var name = "Cat"

  func eat() {
    print("Puppy chow")
  }

  func pet() {
    print(" ˁ˚ᴥ˚ˀ ")
  }

  func feed() {
    print("Puppy wags tail in appreciation")
  }
}


var collarableCat: Collarable = Cat()
var petCat: Pet = Cat()

petCat.name
//petCat.name = "Fido" // name is only defined with a "get"

collarableCat.collarColor
collarableCat.collarColor = "Green"

//: Protocols in the standard library

var a = 5
var b = 5

// Int is a struct, and conforms to Equatable
a == b // 5 == 5

struct Record: Equatable {
  var wins: Int
  let losses: Int
}

func ==(lhs: Record, rhs: Record) -> Bool {
  return lhs.wins == rhs.wins &&
         lhs.losses == rhs.losses
}

let team1 = Record(wins: 23, losses: 8)
let team2 = Record(wins: 23, losses: 8)
let team3 = Record(wins: 14, losses: 11)
team1 == team2
team1 == team3

extension Record: Comparable {

}

func <(lhs: Record, rhs: Record) -> Bool {
  let lhsPercent = Double(lhs.wins) / (Double(lhs.wins) + Double(lhs.losses))
  let rhsPercent = Double(rhs.wins) / (Double(rhs.wins) + Double(rhs.losses))

  return lhsPercent > rhsPercent
}

[team1, team2, team3].sort()

extension Record: CustomStringConvertible {
  var description: String {
    return "\(wins) - \(losses)"
  }
}

// The print() method will now display the CustomStringConvertible value.
print(team1)
