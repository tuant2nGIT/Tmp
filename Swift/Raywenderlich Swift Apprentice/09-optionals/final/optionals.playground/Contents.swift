import Foundation

var name: String = "Matt Galloway"
var age: Int = 30
var occupation: String = "Software Developer & Author"

var errorCode: Int?
errorCode = 100
errorCode = nil

let ageInteger: Int? = 30
print(ageInteger)

//print(ageInteger + 1)

// IF-LET BINDING (AND FORCED UNWRAPPING)
var authorName: String? = "Matt Galloway"

var unwrappedAuthorName1 = authorName!
print("Author is \(unwrappedAuthorName1)")

//authorName = nil
//var unwrappedAuthorName2 = authorName!
//print("Author is \(unwrappedAuthorName2)")

if authorName != nil {
  var unwrappedAuthorName = authorName!
  print("Author is \(unwrappedAuthorName)")
} else {
  print("No author.")
}

if let unwrappedAuthorName = authorName {
  print("Author is \(unwrappedAuthorName)")
} else {
  print("No author.")
}

//let authorName: String? = "Matt Galloway"
let authorAge: Int? = 30

if let name: String = authorName,
  age: Int = authorAge {
    print("The author is \(name) who is \(age) years old.")
} else {
  print("No author or no age.")
}


// NIL COALESCING
var optionalInt: Int? = 10
//optionalInt = nil
let result: Int = optionalInt ?? 0
