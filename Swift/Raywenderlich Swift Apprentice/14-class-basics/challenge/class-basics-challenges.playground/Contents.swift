import Foundation

//:
//: ## Challenge A: Movie lists - benefits of reference types
//:
//: Imagine you're writing a movie-viewing application in Swift. Users can create "lists" of movies and share those lists with other users.
//: Create a User and a List class that uses reference semantics to help maintain lists between users.
//:
//: • User - Has a method addList(list:) which adds the given list to a dictionary of List objects (using the name as a key), and a getList(name:) -> List which will return the List for the provided name.
//:
//: • List - Contains a name and a Set of movie titles. A printList() method will print all the movies in the list.
//:
//: • Create jane and john users and have them create and share lists. Have both jane and john modify the same list and call printList() from both users. Are all the changes reflected?
//:
//: • What happens when you implementing the same with structs. What problems do you run into?

class User {
  var lists: [String: List] = [:]

  func addList(list: List) {
    lists[list.name] = list
  }
}

class List {
  let name: String
  var movies: [String] = []

  init(name: String) {
    self.name = name
  }

  func printList() {

    print("Movie List: \(name)")
    for movie in movies {
      print(movie)
    }
    print("\n")
  }
}

// Give John and Jane an "Action" list
let jane = User()
let john = User()
var actionList = List(name: "Action")

jane.addList(actionList)
john.addList(actionList)

// Add Janes favorites
jane.lists["Action"]?.movies.append("Rambo")
jane.lists["Action"]?.movies.append("Terminator")

// Add Johns favorites
john.lists["Action"]?.movies.append("Die Hard")

// See John's list:
john.lists["Action"]?.printList()

// See Jane's list:
jane.lists["Action"]?.printList()


//: ### What happens when you implementing the same with structs. What problems do you run into?
//: With structs and copy semantics, once John and Jane get the Action list via `addList(list:)`, they each
//: get a copy instead of sharing the same list. That way, when one adds a movie - the other doesn't see it!

//:
//: ## Challenge B: T-Shirt store - class or struct?
//:
//: Your challenge here is to build a set of objects to support a t-shirt store. Decide if each object should be a class or a struct, and why.
//:
//: • TShirt - Represents a shirt style you can buy. Each TShirt has a size, color, price, and an optional image on the front.
//:
//: • User - A registered user of the t-shirt store app. A user has a name, email, and a ShoppingCart (below).
//:
//: • Address - Represents a shipping address, containing the name, street, city, and zip code.
//:
//: • ShoppingCart - Holds a current order, which is composed of an array of TShirt that the User wants to buy, as well as a method to calculate the total cost. Additionally, there is an Address that represents where the order will be shipped.


//: ### TShirt - **Struct**
//: The TShirt can be thought of a "value", because it is not of a "thing" (a real shirt) but as a description of a shirt. For instance, a shirt would be represened as "a large green shirt order" and not "an actual large green shirt". Likewise, it will not hold any state.
//:
//: ### User - **Class**
//: The user object maps to a real person, of which there are one of (and you can't make copies of people now can you!). The same user will hold state, and can have it's stored values such as name or email change without the actual user changing.
//:
//: ### Address - **Struct**
//: An address is a classic exapmple of a value type. It is inert, and maintain state. It's best to thing of an address of a value much like you think of a temperature as a value. They both represent data not things, but addresses have multiple value that create one compound "address" value.
//:
//: ### ShoppingCart - **Class**
//: The `ShoppingCart` is a bit tricker. While it could be argued that it could be done as a value type, it's best to think of the real world semantics you are modeling. If you add an item to a shopping cart, would you expect to get a new shopping cart? Or put the new item in your existing cart? By using a class, the reference semantics help model real world behaviors.
