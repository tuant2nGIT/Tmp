//: Playground - noun: a place where people can play

// CLOSURES
var multiplyClosure: (Int, Int) -> Int

multiplyClosure = { (a: Int, b: Int) -> Int in
  return a * b
}
multiplyClosure(4, 2)

multiplyClosure = { (a: Int, b: Int) -> Int in
  a * b
}
multiplyClosure(4, 2)

multiplyClosure = { (a: Int, b: Int) in
  a * b
}
multiplyClosure(4, 2)

multiplyClosure = { (a, b) in
  a * b
}
multiplyClosure(4, 2)

multiplyClosure = { $0 * $1 }
multiplyClosure(4, 2)


func operateOnNumbers(a: Int, _ b: Int, operation: (Int, Int) -> Int) -> Int {
  let result = operation(a, b)
  print(result)
  return result
}

let addClosure = { (a: Int, b: Int) in
  a + b
}
operateOnNumbers(4, 2, operation: addClosure)

func addFunction(a: Int, b: Int) -> Int {
  return a + b
}
operateOnNumbers(4, 2, operation: addFunction)

operateOnNumbers(4, 2, operation: { (a: Int, b: Int) -> Int in
  return a + b
})

operateOnNumbers(4, 2, operation: {
  $0 + $1
})

operateOnNumbers(4, 2) {
  $0 + $1
}

let voidClosure: () -> Void = {
  print("Swift Apprentice is awesome!")
}
voidClosure()

var counter = 0
let incrementCounter = {
  counter++
}
incrementCounter()
incrementCounter()
incrementCounter()
incrementCounter()
incrementCounter()
counter

func countingClosure() -> (() -> Int) {
  var counter = 0
  let incrementCounter: () -> Int = {
    return counter++
  }
  return incrementCounter
}

let counter1 = countingClosure()
let counter2 = countingClosure()

counter1() // 0
counter2() // 0
counter1() // 1
counter1() // 2
counter2() // 1
