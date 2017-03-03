import Foundation

// Challenge A

let a = 46
var b = 10

// 1
let answer1 = (a * 100) + b
answer1
// answer1 = 4610

// 2
let answer2 = (a * 100) + (b++)
answer2
// answer2 = 4610

// 3
let answer3 = (a * 100) + (++b)
answer3
// answer3 = 4612


// Challenge B

let answer4 = true && true
// true

let answer5 = false || false
// false

let answer6 = (true && 1 != 2) || (4 > 3 && 100 < 1)
// true

let answer7 = ((10 / 2) > 3) && ((10 % 2) == 0)
// true
