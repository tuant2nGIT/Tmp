//: Playground - noun: a place where people can play

// PULL OUT CODE INTO A SEPARATE FUNCTION
func printMyName() {
  print("My name is Matt Galloway.")
}
printMyName()

// FUNCTION PARAMETERS
func printMultipleOfFive(multiple: Int) {
  print("\(multiple) * 5 = \(multiple * 5)")
}
printMultipleOfFive(10)

func printMultipleOf(multiplier: Int, andValue: Int) {
  print("\(multiplier) * \(andValue) = \(multiplier * andValue)")
}
printMultipleOf(4, andValue: 2)

func printMultipleOf(multiplier: Int, and andValue: Int) {
  print("\(multiplier) * \(andValue) = \(multiplier * andValue)")
}
printMultipleOf(4, and: 2)

func printMultipleOf(multiplier: Int, _ andValue: Int) {
  print("\(multiplier) * \(andValue) = \(multiplier * andValue)")
}
printMultipleOf(4, 2)

func printMultipleOf2(multiplier: Int, and andValue: Int = 1) {
  print("\(multiplier) * \(andValue) = \(multiplier * andValue)")
}
printMultipleOf2(4, and: 2)
printMultipleOf2(4)

// RETURN VALUES
func multiply(multiple: Int, by byValue: Int) -> Int {
  return multiple * byValue
}
multiply(4, by: 2)

func multiplyAndDivide(multiple: Int, by byValue: Int) -> (multiply: Int, divide: Int) {
  return (multiple * byValue, multiple / byValue)
}
multiplyAndDivide(4, by: 2)

//func incrementAndPrint(value: Int) {
//  value++
//  print(value)
//  // error: cannot pass immutable value to mutating operator: 'value' is a 'let' constant
//}

func incrementAndPrint(var value: Int) {
  value++
  print(value)
}
var value1 = 5
incrementAndPrint(value1)
print(value1) // 5

func incrementAndPrintInOut(inout value: Int) {
  value++
  print(value)
}
var value2 = 5
incrementAndPrintInOut(&value2)
print(value2) // 6

// EXAMPLES FROM STANDARD LIBRARY

// Talk about print(...) which we've seen before

max(10, 20)

min(10, 20)

abs(-10)

abs(10)

// FUNCTIONS AS VARIABLES
func add(a: Int, _ b: Int) -> Int {
  return a + b
}
var function: (Int, Int) -> Int = add
function(4, 2)

func subtract(a: Int, _ b: Int) -> Int {
  return a - b
}
function = subtract
function(4, 2)

func printResult(function: (Int, Int) -> Int, _ a: Int, _ b: Int) {
  let result = function(a, b)
  print(result)
}
printResult(add, 4, 2)
