import Foundation

// Challenge A
func repeatTask(times: Int, task: () -> Void) {
  for _ in 0..<times {
    task()
  }
}

repeatTask(10) {
  print("Swift Apprentice is a great book!")
}


// Challenge B
func mathSum(times: Int, operation: (Int) -> Int) -> Int {
  var result = 1
  for i in 1...times {
    result += operation(i)
  }
  return result
}

// Sum of first 10 square numbers
mathSum(10) { number in
  number * number
}

// Alternate solution using shorthand syntax
mathSum(10) {
  $0 * $0
}

func fibonacci(number: Int) -> Int {
  if number <= 0 {
    return 0
  }

  if number == 1 || number == 2 {
    return 1
  }

  return fibonacci(number - 1) + fibonacci(number - 2)
}

// Sum of first 10 fibonacci numbers
mathSum(10, operation: fibonacci)
