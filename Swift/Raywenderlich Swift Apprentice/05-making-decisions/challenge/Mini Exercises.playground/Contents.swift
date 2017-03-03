import Foundation

let myAge = 30
if myAge >= 13 && myAge <= 19 {
  print("Teenager")
} else {
  print("Not a teenager")
}

switch (myAge) {
case let x where x >= 0 && x <= 2:
  print("Infant")
case let x where x >= 3 && x <= 12:
  print("Child")
case let x where x >= 13 && x <= 19:
  print("Teenager")
case let x where x >= 20 && x <= 39:
  print("Adult")
case let x where x >= 40 && x <= 60:
  print("Middle aged")
case let x where x >= 61:
  print("Elderly")
default:
  print("Invalid age")
}

let tuple = ("Matt", 30)
switch (tuple) {
case (let name, let x) where x >= 0 && x <= 2:
  print("\(name) is a infant")
case (let name, let x) where x >= 3 && x <= 12:
  print("\(name) is a child")
case (let name, let x) where x >= 13 && x <= 19:
  print("\(name) is a teenager")
case (let name, let x) where x >= 20 && x <= 39:
  print("\(name) is an adult")
case (let name, let x) where x >= 40 && x <= 60:
  print("\(name) is a middle aged")
case (let name, let x) where x >= 61:
  print("\(name) is a elderly")
default:
  print("Invalid age")
}
