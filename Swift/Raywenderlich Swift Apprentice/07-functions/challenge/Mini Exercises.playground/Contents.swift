import Foundation

// Functions
func printFullName(firstName: String, lastName: String) {
  print(firstName + " " + lastName)
}
printFullName("Matt", lastName: "Galloway")

func printFullName(firstName: String, _ lastName: String) {
  print(firstName + " " + lastName)
}
printFullName("Matt", "Galloway")

func calculateFullName(firstName: String, _ lastName: String) -> String {
  return firstName + " " + lastName
}
let fullName = calculateFullName("Matt", "Galloway")

func calculateFullName2(firstName: String, _ lastName: String) -> (String, Int) {
  let fullName = firstName + " " + lastName
  return (fullName, fullName.characters.count)
}
let fullNameLength = calculateFullName2("Matt", "Galloway").1
