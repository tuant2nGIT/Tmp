import Foundation

//:
//: ## Challenge A: Bike protocols
//:
//: Implement Comparable and Hashable on the Bike class. Create a Set of bikes of various wheel numbers and sizes, then sort them by their wheel size.
//:

protocol Vehicle {
    func accelerate()
    func stop()
}

protocol Wheeled {
    var numberOfWheels: Int { get }
    var wheelSize: Double { get set }
}

class Bike: Wheeled {

    // Introduce a model name, so bikes can be compared on more than
    // their wheels!
    var modelName: String

    init(modelName: String) {
        self.modelName = modelName
    }

    var numberOfWheels: Int {
        return 2
    }

    private var myWheelSize: Double = 16.0
    var wheelSize: Double {
        get {
            return myWheelSize
        }
        set {
            myWheelSize = newValue
        }
    }
}

extension Bike: Hashable {
    var hashValue: Int {

        // `String` already implements `Hashable`, so factor that
        // value into the hash formula. Then, multiply by wheelsize and numberOfWheels
        // to make every model, size, number combination (fairly) unique.
        //
        // Add 10000 to numberOfWheels so that, for instance, a wheelSize of 8 with 10 wheels is
        // not equal to a wheelsize of 10 with 8 wheels
        return modelName.hashValue *
                Int(wheelSize) *
                (10000 + numberOfWheels)
    }
}

func ==(lhs: Bike, rhs: Bike) -> Bool {
    return lhs.wheelSize == rhs.wheelSize &&
            lhs.numberOfWheels == rhs.numberOfWheels &&
            lhs.modelName == rhs.modelName
}


//:
//: ## Challenge B: Pet shop tasks
//:
//: Create a collection of protocols for tasks that need doing at a pet shop. The pet shop has dogs, cats, fish and birds.
//: The pet shop duties can be broken down into these tasks:
//:
//: * All pets need to be fed.
//:
//: * Pets that can fly need to be caged.
//:
//: * Pets that can swim need a tank.
//:
//: * Pets that walk need exercise.
//:
//: * Tanks, cages, and litter boxes need to occasionally be cleaned.
//:

//: 1. Create classes or structs for each animal and adopt the appropriate protocols. Feel free to simply use a print() statement for the method implementations.

protocol Feedable {
    func feed()
}

protocol Cleanable {
    func clean()
}

protocol Cageable: Cleanable {
    func cage()
}

protocol Tankable: Cleanable {
    func tank()
}

protocol Walkable {
    func walk()
}

class Dog: Feedable, Walkable {
    func feed() {
        print("Woof...thanks!")
    }

    func walk() {
        print("Walk the dog")
    }
}

class Cat: Feedable, Cleanable {
    func feed() {
        print("Yummy meow")
    }

    func clean() {
        print("Litter box cleaned")
    }
}

class Fish: Feedable, Tankable {
    func feed() {
        print("Fish goes blub")
    }

    func tank() {
        print("Fish has been tanked")
    }

    func clean() {
        print("Fish tank has been cleaned")
    }
}

class Bird: Feedable, Cageable {
    func feed() {
        print("Tweet!")
    }

    func cage() {
        print("Cage the bird")
    }

    func clean() {
        print("Clean the cage")
    }
}

//: 2. Create homogenous arrays for animals that need to be fed, caged, cleaned, walked, and tanked. Add the appropriate animals to these arrays. The arrays should be declared using the protocol as the element type, for example var caged: [Cageable]

let dog = Dog()
let cat = Cat()
let fish = Fish()
let bird = Bird()

let walkingDuties: [Walkable] = [dog]
let feedingDuties: [Feedable] = [dog, cat, fish, bird]
let tankingDuties: [Tankable] = [fish]
let cagingDuties: [Cageable] = [bird]
let cleaningDuties: [Cleanable] = [cat, fish, bird]

// Swift's type system prevents you from adding something that
// can't be walked to a homogenous list of `Walkable`!
// let invalidWalkingDuties: [Walkable] = [dog, fish]

//: 3. Write a loop that will perform the proper tasks (such as feed, cage, walk) on each element of each array.

for walkable in walkingDuties {
    walkable.walk()
}

for feedable in feedingDuties {
    feedable.feed()
}

for tankable in tankingDuties {
    tankable.tank()
}

for cageable in cagingDuties {
    cageable.cage()
}

for cleanable in cleaningDuties {
    cleanable.clean()
}
