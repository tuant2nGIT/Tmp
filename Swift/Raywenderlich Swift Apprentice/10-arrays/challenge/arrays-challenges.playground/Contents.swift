// ---------------
// | Challenge A |
// ---------------

// The valid statements are 1, 3, 4, 6, 9, 10 and 13.


// ---------------
// | Challenge B |
// ---------------

/* Write a function that removes all occurrences of a given integer from an array of integers. This is the signature of the function:

func removeOnce(itemToRemove: Int, fromArray: [Int]) -> [Int]
*/

func removeOnce(itemToRemove: Int, fromArray: [Int]) -> [Int] {
  var result = fromArray
  if let index = fromArray.indexOf(itemToRemove) {
    result.removeAtIndex(index)
  }
  return result
}


// ---------------
// | Challenge C |
// ---------------

/* Write a function that removes all occurrences of a given integer from an array of integers. This is the signature of the function:

    func remove(itemToRemove: Int, fromArray: [Int]) -> [Int]
*/

// --------------
// | Solution 1 |
// --------------

func remove1(itemToRemove: Int, fromArray: [Int]) -> [Int] {
  var newArray = [Int]()
  for item in fromArray {
    if item != itemToRemove {
      newArray.append(item)
    }
  }
  return newArray
}

// --------------
// | Solution 2 |
// --------------

func remove2(itemToRemove: Int, fromArray: [Int]) -> [Int] {
  return fromArray.filter({$0 != itemToRemove})
}


// ---------------
// | Challenge D |
// ---------------

/* Arrays have a reverse() method that reverses the order of its items. Can you write a function that reverses an array without using reverse()? This is the signature of the function:

    func reverse(array: [Int]) -> [Int]
*/

// ------------
// | Solution |
// ------------

func reverse(array: [Int]) -> [Int] {
  var newArray = [Int]()
  for item in array {
    newArray.insert(item, atIndex: 0)
  }
  return newArray
}


// ---------------
// | Challenge E |
// ---------------

/* You have this function that returns a random number between 0 and the given argument: */

import Foundation
func randomFromZeroTo(number: Int) -> Int {
  return Int(arc4random_uniform(UInt32(number)))
}

/* Use it to write a function that shuffles the elements of an array in random order. This is the signature of the function:

    func randomArray(array: [Int]) -> [Int]
*/

// ------------
// | Solution |
// ------------

func randomArray(array: [Int]) -> [Int] {
  var newArray = array
  for index in 0..<array.count {
    let randomIndex = randomFromZeroTo(array.count)
    let value = newArray[randomIndex]
    newArray[randomIndex] = newArray[index]
    newArray[index] = value
  }
  return newArray
}
