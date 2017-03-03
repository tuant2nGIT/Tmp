import Foundation

// Challenge A

/*
let firstName = "Matt"

if firstName == "Matt" {
  let lastName = "Galloway"
} else if firstName == "Ray" {
  let lastName = "Wenderlich"
}

let fullName = firstName + " " + lastName
^ This line is wrong. 'lastName' is not visible to this scope.
*/

// This is the correct solution:
let firstName = "Matt"
var lastName = ""

if firstName == "Matt" {
  lastName = "Galloway"
} else if firstName == "Ray" {
  lastName = "Wenderlich"
}

let fullName = firstName + " " + lastName

// Challenge B

let coordinates = (1, 5, 0)
// "On the x/y plane"

//let coordinates = (2, 2, 2)
// "x = y = z"

//let coordinates = (3, 0, 1)
// "On the x/z plane"

//let coordinates = (3, 2, 5)
// "Nothing special"

//let coordinates = (0, 2, 4)
// "On the y/z plane"

switch (coordinates) {
case (let x, let y, let z) where x == y && y == z:
  print("x = y = z")
case (_, _, 0):
  print("On the x/y plane")
case (_, 0, _):
  print("On the x/z plane")
case (0, _, _):
  print("On the y/z plane")
default:
  print("Nothing special")
}
