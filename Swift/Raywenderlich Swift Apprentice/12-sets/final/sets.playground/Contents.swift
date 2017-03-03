// -----------------
// | CREATING SETS |
// -----------------

let setOne: Set<Int>

let setTwo = Set<Int>()

print(setTwo)
// > []

let someArray = [1, 2, 3, 1]

let someSet: Set<Int> = [1, 2, 3, 1]

let anotherSet: Set = [1, 2, 3, 1]

print(someSet)
// > [2, 3, 1]

// ----------------------
// | ACCESSING ELEMENTS |
// ----------------------

print(someSet.isEmpty)
// > false
print(someSet.count)
// > 3

print(someSet.contains(1))
// > true
print(someSet.contains(4))
// > false

print(someSet.first)
// > Optional(2)

// ------------------------------
// | ADDING & REMOVING ELEMENTS |
// ------------------------------

var myTimes: Set = ["8am", "9am", "10am"]

myTimes.insert("11am")
print(myTimes)
// > ["9am", "8am", "11am", "10am"]

let removedElement = myTimes.remove("8am")
print(removedElement)
// > Optional("8am")

// -------------
// | Iteration |
// -------------

for element in myTimes {
  print(element)
}
// > 9am
// > 11am
// > 10am

// ------------------
// | SET OPERATIONS |
// ------------------

let adamTimes: Set = ["9am", "11am", "1pm"]

let unionSet = myTimes.union(adamTimes)
print(unionSet)
// > ["9am", "11am", "10am", "1pm"]

let intersectSet = myTimes.intersect(adamTimes)
print(intersectSet)
// > ["9am", "11am"]

let subtractSet = myTimes.subtract(adamTimes)
print(subtractSet)
// > ["10am"]

let exclusiveOrSet = myTimes.exclusiveOr(adamTimes)
print(exclusiveOrSet)
// > ["10am", "1pm"]
