// ---------------
// | Challenge A |
// ---------------

// The valid statements are 3, 5, 8, 9 and 10.


// ---------------
// | Challenge B |
// ---------------

/* Write a function that replaces the values of two keys in a dictionary. This is the signature of the function:

    func replaceValueForKey(key1: String, withValueForKey key2: String, inDictionary: [String: Int]) -> [String: Int]
*/

// ------------
// | Solution |
// ------------

func replaceValueForKey(key1: String, withValueForKey key2: String, inDictionary: [String: Int]) -> [String: Int] {
  var newDictionary = inDictionary
  let oldValue = newDictionary[key1]
  newDictionary[key1] = newDictionary[key2]
  newDictionary[key2] = oldValue
  return newDictionary
}

// ---------------
// | Challenge C |
// ---------------

/* Given a dictionary with 2-letter state codes as keys and the full state name as values, write a function that prints all the states whose name is longer than 8 characters. For example, for this dictionary ["NY": "New York", "CA": "California"] the output would be "California". */

// ------------
// | Solution |
// ------------

func printLongStateNames(dictionary: [String: String]) {
  for (_, value) in dictionary {
    if value.characters.count > 8 {
      print(value)
    }
  }
}

// ---------------
// | Challenge D |
// ---------------

/* Write a function that combines two dictionaries into one. If a certain key appears in both dictionaries, ignore the pair from the first dictionary. This is the signature of the function:

    func combine(dict1: [String: String], with dict2: [String: String]) -> [String: String]
*/

// ------------
// | Solution |
// ------------

func combine(dict1: [String: String], with dict2: [String: String]) -> [String: String] {
  var newDictionary = dict1
  for (key, value) in dict2 {
    newDictionary[key] = value
  }
  return newDictionary
}
