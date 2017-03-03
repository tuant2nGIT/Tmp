//: Playground - noun: a place where people can play

// ARITHMETIC OPERATORS

let add = 2 + 6

let subtract = 10 - 2

let multiply = 2 * 4

let divide = 24 / 3

let modulo = 28 % 10

let moduloDecimal = 11.6 % 1.2

let shiftLeft = 1 << 3

let shiftRight = 32 >> 2

var counter = 0
counter++ // 1
counter-- // 0

var start = 8
let prefix = ++start
let postfix = start++

counter += 5 // 5
counter -= 2 // 3

let answer = ((8_000 / (5 * 10)) - 32) >> (29 % 5)

let hourlyRate = 19.5
let hoursWorked = 10
//let totalCost = hourlyRate * hoursWorked /* Binary operator '*' cannot be applied to operands of type 'Double' and 'Int' */
let totalCost = hourlyRate * Double(hoursWorked)

let testNumber = 0
let evenOdd = testNumber % 2

var answerExercise = 0
answerExercise++
answerExercise += 10
answerExercise *= 10
answerExercise = answerExercise >> 3


// COMPARISON OPERATORS
let yes: Bool = true
let no: Bool = false

let doesOneEqualTwo = (1 == 2)

let doesOneNotEqualTwo = (1 != 2)

let isOneGreaterThanTwo = (1 > 2)

let isOneLessThanTwo = (1 < 2)

let and = true && true
let or = true || false

let andTrue = 1 < 2 && 4 > 3
let andFalse = 1 < 2 && 3 > 4

let orTrue = 1 < 2 || 3 > 4
let orFalse = 1 == 2 || 3 == 4

let andOr = (1 < 2 && 3 > 4) || 1 < 4
