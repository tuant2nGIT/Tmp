// ---------------
// | Challenge A |
// ---------------

// The valid statements are 1, 3, 6 and 8. Statement 2 is a valid statement; however, it creates an array, not a set.


// ---------------
// | Challenge B |
// ---------------

/* Assume you have a set with emails of 10,000 people: let emails: Set<String>. Write a function that returns true if a given email is in the set, or false otherwise. You're not allowed to use contains(_:) or to iterate over the set. */

// ------------
// | Solution |
// ------------

func containsEmail(email: String, inSet: Set<String>) -> Bool {
  var newEmails = inSet
  newEmails.insert(email)
  return newEmails.count == inSet.count
}


// ---------------
// | Challenge C |
// ---------------

/* You are a professor at the Swift university and you're teaching a 3 days course. Each day you are tracking the attendence by adding the names of everyone who showed up to a new set.

   For example: */

let day1: Set = ["Anna", "Benny", "Charlie"]
let day2: Set = ["Anna", "Benny", "Danny"]
let day3: Set = ["Anna", "Danny", "Eric"]

/*
1. Write a function that returns a set with the students who attended all 3 days.
2. Write a function that finds out who dropped out of the course after the first day.
The signature for these two functions is:

    func funcName(day1: Set<String>, day2: Set<String>, day3: Set<String>) -> Set<String>

*/

// ------------
// | Solution |
// ------------

// 1.
func attendedAllDays(day1: Set<String>, day2: Set<String>, day3: Set<String>) -> Set<String> {
  return day1.intersect(day2.intersect(day3))
}

attendedAllDays(day1, day2: day2, day3: day3)

// 2.
func droppedAfterDayOne(day1: Set<String>, day2: Set<String>, day3: Set<String>) -> Set<String> {
  return day1.subtract(day2).subtract(day3)
}

droppedAfterDayOne(day1, day2: day2, day3: day3)
