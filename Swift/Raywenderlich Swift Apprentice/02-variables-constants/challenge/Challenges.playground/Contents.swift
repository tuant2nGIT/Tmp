import Foundation

// Challenge A

// 1 - VALID CODE
var age = 25
age = 30

// 2 - INVALID CODE
//let age = 25
//age = 30

let tuple: (day: Int, month: Int, year: Int) = (15, 8, 2015)
//let day = tuple.Day
// Invalid because it should be 'day' instead of 'Day'


// Challenge B

let tuple1 = (100, 1.5, 10)
let value = tuple1.1
// value = 1.5

let tuple2: (day: Int, month: Int, year: Int) = (15, 8, 2015)
let month = tuple2.month
// month = 8
