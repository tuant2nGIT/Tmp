//: Playground - noun: a place where people can play

// IF-STATEMENTS
if 2 > 1 {
  print("Yes, 2 is greater than 1.")
}

let animal = "Fox"
if animal == "Cat" || animal == "Dog" {
  print("Animal is a house pet.")
} else {
  print("Animal is not a house pet.")
}

let hourOfDay1 = 12
let timeOfDay1: String
if hourOfDay1 < 6 {
  timeOfDay1 = "Early morning"
} else if hourOfDay1 < 12 {
  timeOfDay1 = "Morning"
} else if hourOfDay1 < 17 {
  timeOfDay1 = "Afternoon"
} else if hourOfDay1 < 20 {
  timeOfDay1 = "Evening"
} else if hourOfDay1 < 24 {
  timeOfDay1 = "Late evening"
} else {
  timeOfDay1 = "INVALID HOUR!"
}
print(timeOfDay1)


// SCOPE
var hoursWorked = 45

var price = 0
if hoursWorked > 40 {
  let hoursOver40 = hoursWorked - 40
  price += hoursOver40 * 50
  hoursWorked -= hoursOver40
}
price += hoursWorked * 25

print(price)
//print(hoursOver40)


// TERNARY OPERATOR
let a = 5
let b = 10
let min = a < b ? a : b
let max = a > b ? a : b


// SWITCH STATEMENTS
let number = 10

switch (number) {
case 0:
  print("Zero")
default:
  print("Non-zero")
}

switch (number) {
case 10:
  print("It's ten!")
default:
  break
}

let string = "Dog"
switch (string) {
case "Cat", "Dog":
  print("Animal is a house pet.")
default:
  print("Animal is not a house pet.")
}

let hourOfDay2 = 12
let timeOfDay2: String
switch (hourOfDay2) {
case 0, 1, 2, 3, 4, 5:
  timeOfDay2 = "Early morning"
case 6, 7, 8, 9, 10, 11:
  timeOfDay2 = "Morning"
case 12, 13, 14, 15, 16:
  timeOfDay2 = "Afternoon"
case 17, 18, 19:
  timeOfDay2 = "Evening"
case 20, 21, 22, 23:
  timeOfDay2 = "Late evening"
default:
  timeOfDay2 = "INVALID HOUR!"
}
print(timeOfDay2)

switch (number) {
case let x where x % 2 == 0:
  print("Even")
default:
  print("Odd")
}

let coordinates: (x: Int, y: Int, z: Int) = (3, 2, 5)

switch (coordinates) {
case (0, 0, 0):
  print("Origin")
case (_, 0, 0):
  print("On the x-axis.")
case (0, _, 0):
  print("On the y-axis.")
case (0, 0, _):
  print("On the z-axis.")
default:
  print("Somewhere in space")
}

switch (coordinates) {
case (0, 0, 0):
  print("Origin")
case (let x, 0, 0):
  print("On the x-axis at x = \(x)")
case (0, let y, 0):
  print("On the y-axis at y = \(y)")
case (0, 0, let z):
  print("On the z-axis at z = \(z)")
case (let x, let y, let z):
  print("Somewhere in space at x = \(x), y = \(y), z = \(z)")
}

switch (coordinates) {
case (let x, let y, _) where y == x:
  print("Along the y = x line.")
case (let x, let y, _) where y == x * x:
  print("Along the y = x^2 line.")
default:
  break
}
