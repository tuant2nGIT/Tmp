import Foundation

//:
//: ## Challenge A: Visualizing the initialization chain
//:
//: Create 3 simple classes called A, B, and C where C inherits from B and B inherits from A. In each class initializer, call print("I'm A!") in each respective classes initializer both before and after super.init().
//:
//: What order do you see each print() called in?

class A {
  init() {
    print("I'm A!")
  }
}

class B: A {
  override init() {
    print("I'm B!")
    super.init()
    print("I'm B!")
  }
}

class C: B {
  override init() {
    print("I'm C!")
    super.init()
    print("I'm C!")
  }
}

C()

//: ### What happens when you implementing the same with structs. What problems do you run into?
//: With structs and copy semantics, once John and Jane get the Action list via `addList(list:)`, they each
//: get a copy instead of sharing the same list. That way, when one adds a movie - the other doesn't see it!


//:
//: ## Challenge B: Deepen the class hierarchy
//:
//: Create a subclass of StudentAthlete called StudentBaseballPlayer and include properties for position, number, and battingAverage.

class Person {
  var firstName: String
  var lastName: String

  init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
  }
}

struct Grade {
  let letter: String
  let points: Double
}

class Student: Person {
  var grades: [Grade] = []
}

class StudentAthlete: Student {
  var sports: [String] = []
}

class StudentBaseballPlayer: Student {
  var battingAverage: Double = 0.0
  var number: Int
  var position: String

  init(firstName: String, lastName: String, number: Int, position: String) {
    self.number = number
    self.position = position
    super.init(firstName: firstName, lastName: lastName)
  }

}

//: ### What are the benefits and drawbacks of subclassing StudentAthlete in this scenario?
//: **Benefits:**
//:
//: * Automatically get properties all student atheletes will have - grades and names
//:
//: * Type relationship with superclasses. StudentBaseballPlayer _is_ a Student
//:
//: **Drawbacks:**
//:
//: * An initializer that is beginning to get bloated
//:
//: * `sports` is a bit awkward to a baseball player object
//:
//: * Deep class hierarchy would make similar classes difficult. For instance, an almost identical class would need to be made for a `SoftballPlayer` who joined a league after graduating. They would no longer be a `Student`, only a `Person`!
//:

//: ### Can you think of an alternative to sublcassing? Assume you could modify any class in the hierarchy.
//:
//: One could put much of this information into an object that did not inherit all the way down from person, but instead simply held information about the sport. In other words, a `Baseball` object could be owned by the `StudentAthlete` object that would simply have average, position, and number. This is known as "composition" as an alternative to "inheritance".
