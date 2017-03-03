//: Playground - noun: a place where people can play

// RANGES
let closedRange = 0...10

let halfOpenRange = 0..<10

let hourOfDay = 12
let timeOfDay: String
switch (hourOfDay) {
case 0...5:
  timeOfDay = "Early morning"
case 6...11:
  timeOfDay = "Morning"
case 12...16:
  timeOfDay = "Afternoon"
case 17...19:
  timeOfDay = "Evening"
case 20..<24:
  timeOfDay = "Late evening"
default:
  timeOfDay = "INVALID HOUR!"
}
timeOfDay


// LOOPS
let count = 10

// Triangle numbers
var sum1 = 0
for var i = 1; i <= count; i++ {
  sum1 += i
}
sum1

// Triangle numbers
var sum2 = 0
for i in 1...count {
  sum2 += i
}
sum2

// Fibonacci
var sum3 = 1
var lastSum3 = 0
for _ in 0..<count {
  let temp = sum3
  sum3 = sum3 + lastSum3
  lastSum3 = temp
}
sum3

// Chess board iteration
var sum7 = 0
for row in 0..<8 {
  if row % 2 == 0 {
    continue
  }

  for column in 0..<8 {
    sum7 += row * column
  }
}
sum7

var sum8 = 0
rowLoop: for row in 0..<8 {
  columnLoop: for column in 0..<8 {
    if row == column {
      continue rowLoop
    }
    sum8 += row * column
  }
}
sum8

// Made up sequence (it's powers of 2 minus 1, i.e. 3, 7, 15, 31, 63, etc)
var sum4 = 1
while sum4 < 1000 {
  sum4 = sum4 + (sum4 + 1)
}
sum4

var sum5 = 1
repeat {
  sum5 = sum5 + (sum5 + 1)
} while sum5 < 1000
sum5

var sum6 = 1
while true {
  sum6 = sum6 + (sum6 + 1)
  if sum6 >= 1000 {
    break
  }
}
sum6
