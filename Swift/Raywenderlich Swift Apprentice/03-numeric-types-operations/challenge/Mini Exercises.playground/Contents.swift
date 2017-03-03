import Foundation

let testNumber = 42
let evenOdd = testNumber % 2
// 'evenOdd' is 0 when 'testNumber' is even. 'evenOdd' is 1 when 'testNumber' is odd.

var answer = 0
answer++
answer += 10
answer *= 10
answer >>= 3
answer
// answer = 13

let myAge = 26
let isTeenager = myAge >= 13 && myAge <= 19

let theirAge = 30
let bothTeenagers = theirAge >= 13 && myAge <= 19 && isTeenager
