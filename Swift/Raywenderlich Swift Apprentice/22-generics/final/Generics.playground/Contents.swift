//: Playground - noun: a place where people can play

import Foundation

// try 0: values driving values
enum PetKind {
  case Cat
  case Dog
}

struct KeeperKind {
  var keeperOf: PetKind
}

let catKeeper = KeeperKind(keeperOf: .Cat)
let dogKeeper = KeeperKind(keeperOf: .Dog)

// types driving types

/* try 1: manually mirrored types

struct Cat {}
struct Dog {}

struct KeeperOfCats {}
struct KeeperOfDogs {}
*/

/* try 2: generics to establish type relationship
struct Cat {}
struct Dog {}

struct Keeper<T> {}

var theKeeper = Keeper<Cat>()
var aSecondKeeper: Keeper<Dog> = Keeper()
*/

// var aThirdKeeper = Keeper()   // <- should error

/* try 3: add identity. now we have collections
*/
struct Cat {
  var name: String
}

struct Dog {
  var name: String
}

struct Keeper<T> {
  var name: String
  var morningAnimal: T
  var afternoonAnimal: T
}

let jason = Keeper(name: "Jason",
  morningAnimal: Cat(name: "Whiskers"),
  afternoonAnimal: Cat(name: "Sleepy"))


let favoriteIntsExplicit = Array<Int>(arrayLiteral: 8, 9, 42)
let favoriteIntsInferred = Array(arrayLiteral: 8, 9, 42)
let favoriteFloatsInferred = Array<Float>(arrayLiteral: 8, 9, 42)

let favoriteIntsExplicit2: Array<Int>     = [8, 9, 42]
let favoriteIntsInferred2: Array          = [8, 9, 42]
var favoriteFloatsInferred2: Array<Float> = [8, 9, 42]


let intNames: Dictionary<Int, String> = [42: "forty-two", 7: "seven"]
let intNames2: [Int: String] = [42: "forty-two", 7: "seven"]
let intNames3 = [42: "forty-two", 7: "seven"]

enum OptionalDate {
  case None
  case Some(NSDate)
}

enum OptionalString {
  case None
  case Some(String)
}

struct Person {
  // other properties here
  var birthday: OptionalDate
  var lastName: OptionalString
}

var birthdate: Optional<NSDate> = Optional<NSDate>.None
if birthdate == Optional<NSDate>.None {
  // no birthdate
}

var birthdate2: NSDate? = nil
if birthdate == nil {
  // no birthdate
}

// later, revisiting Optional

func swapped<T, U>(x: T, y: U) -> (U, T) {
  return (y, x)
}
let (name, age) = swapped(33, y: "Jay")
