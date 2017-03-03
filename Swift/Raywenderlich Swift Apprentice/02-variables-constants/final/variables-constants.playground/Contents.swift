//: Playground - noun: a place where people can play

let number: Int = 10
//number = 0 /* Cannot assign to value: 'constantNumber' is a 'let' constant */

let pi: Double = 3.14159

var variableNumber: Int = 42
variableNumber = 0
variableNumber = 1_000_000

var 🐶💩: Int = -1

var integer: Int = 100
var decimal: Double = 12.5
//integer = decimal /* Cannot assign a value of type 'Double' to a value of type 'Int' */
integer = Int(decimal)

let coordinates: (Int, Int) = (2, 3)
let x1: Int = coordinates.0
let y1: Int = coordinates.1

let coordinatesNamed: (x: Int, y: Int) = (2, 3)
let x2: Int = coordinatesNamed.x
let y2: Int = coordinatesNamed.y

let coordinates3D: (x: Int, y: Int, z: Int) = (2, 3, 1)
let (x3, y3, z3) = coordinates3D
print(x3)
print(y3)
print(z3)

let (x4, y4, _) = coordinates3D

let typeInferedInt = 42 /* Type = Int */
let typeInferedDouble = 3.14159 /* Type = Double */
