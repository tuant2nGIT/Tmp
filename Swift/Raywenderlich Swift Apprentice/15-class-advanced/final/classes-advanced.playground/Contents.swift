//:
//: Introducing inheritence
//:

struct Grade {
  var letter: Character
  var points: Double
  var credits: Double
}

class Person {
  var firstName: String
  var lastName: String

  init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
  }
}

class Student: Person {
  var grades: [Grade] = []

  func recordGrade(grade: Grade) {
    grades.append(grade)
  }
}

//:
//: Because john is a Person and not a Student, it does not have access to the recordGrade method.
//:

let john = Person(firstName: "Johnny", lastName: "Appleseed")
let jane = Student(firstName: "Jane", lastName: "Appleseed")
let history = Grade(letter: "B", points: 9.0, credits: 3.0)


jane.recordGrade( history )
// john.recordGrade( history ) // john is not a student!



//:
//: With class inheritence, methods can be overridden and behavior can be added.
//:

class StudentAthlete: Student {
  var failedClasses: [Grade] = []

  override func recordGrade(grade: Grade) {
    super.recordGrade(grade)

    if grade.letter == "F" {
      failedClasses.append(grade)
    }
  }

  func athleteIsEligable() -> Bool {
    return failedClasses.count < 3
  }
}


class StudentAthlete2: Student {
  var failedClasses: [Grade] = []

  override func recordGrade(grade: Grade) {
    super.recordGrade(grade)

    if grade.letter == "F" {
      failedClasses.append(grade)
    }
  }

  func athleteIsEligable() -> Bool {
    return failedClasses.count < 3
  }
}


//:
//: Initialization in Swift follows a 2-phase initialization approach. Stored properties must be initialized in the first phase, and `self` can be referenced in the second phase. The transition from phase 1 to phase 2 happens after all classses in the hierarchy have been initiazlized.
//:
class Student2: Person {
  var grades: [Grade]

  override init(firstName: String, lastName: String) {
    grades = []
    super.init(firstName: firstName, lastName: lastName)
  }

  init(person: Person) {
    grades = []
    super.init(firstName: person.firstName, lastName: person.lastName)
  }

  func recordGrade(grade: Grade) {
    grades.append(grade)
  }
}

class StudentAthlete3: Student2 {
  var sports: [String]

  init(firstName: String, lastName: String, sports: [String]) {
    self.sports = sports
    let passGrade = Grade(letter: "P", points: 0.0, credits: 0.0)
    super.init(firstName: firstName, lastName: lastName)
    recordGrade(passGrade)
  }

  override init(firstName: String, lastName: String) {
    fatalError("init(firstName:lastName:) has not been implemented")
  }

}

class Person3 {
  var firstName: String
  var lastName: String

  init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
  }

  deinit {
    print("\(firstName) being deallocated!")
  }
}

//:
//: The class lifecycle is handled by Reference Counting, and more notably _Automatic_ Reference Counting
//:

// Person object has a reference count of 1 (john variable)
var john3 = Person3(firstName: "Johnny", lastName: "Appleseed")

// Reference count 2 (john, anotherJohn)
var anotherJohn3: Person3? = john3

// Reference count 6 (john, anotherJohn, 4 references)
// The same reference is inside both john and anotherJohn
var lotsaJohns3 = [john3, john3, anotherJohn3, john3]

// Reference count 5 (john, 4 references in lotsaJohns)
anotherJohn3 = nil

// Reference count 1 (john)
lotsaJohns3 = []

// Reference count 0!
john3 = Person3(firstName: "Johnny", lastName: "Appleseed")


//:
//: Retain cycles happen when two objects have strong references to each other. Declaring a property weak is one way to avoid retain cycles.
//:

class Student4: Person {
  weak var partner: Student4?

  deinit {
    print("\(firstName) being deallocated!")
  }

}

var john4: Student4? = Student4(firstName: "Johnny", lastName: "Appleseed")
var jane4: Student4? = Student4(firstName: "Jane", lastName: "Appleseed")

john4?.partner = jane4
jane4?.partner = john4

john4 = nil
jane4 = nil
