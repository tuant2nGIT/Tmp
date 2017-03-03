import Foundation

// Challenge A
func isNumberDivisible(number: Int, by byNumber: Int) -> Bool {
  return number % byNumber == 0
}

func isPrime(number: Int) -> Bool {
  if number < 0 {
    return false
  }

  if number <= 3 {
    return true
  }

  let root = Int(sqrt(Double(number)))
  for i in 2...root {
    if isNumberDivisible(number, by: i) {
      return false
    }
  }
  return true
}
isPrime(6)
isPrime(13)
isPrime(8893)


// Challenge B
func fibonacci(number: Int) -> Int {
  if number <= 0 {
    return 0
  }

  if number == 1 || number == 2 {
    return 1
  }

  return fibonacci(number - 1) + fibonacci(number - 2)
}
fibonacci(1)
fibonacci(2)
fibonacci(3)
fibonacci(4)
fibonacci(5)
fibonacci(10)
