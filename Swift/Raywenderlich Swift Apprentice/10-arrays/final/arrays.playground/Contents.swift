// -------------------
// | CREATING ARRAYS |
// -------------------

let numbers: Array<Int>

let inferredNumbers = Array<Int>()

let alsoInferredNumbers = [Int]()

let evenNumbers = [2, 4, 6, 8]

let allZeros = [Int](count: 5, repeatedValue: 0)
// > [0, 0, 0, 0, 0]

let vowels = ["A", "E", "I", "O", "U"]

// ----------------------
// | ACCESSING ELEMENTS |
// ----------------------

var players = ["Alice", "Bob", "Cindy", "Dan"]

print(players.isEmpty)
// > false

if players.count < 2 {
  print("We need at least two players!")
} else {
  print("Let's start!")
}
// > Let's start!

var currentPlayer = players.first

print(currentPlayer)
// > Optional("Alice")

print(players.last)
// > Optional("Dan")

currentPlayer = players.minElement()
print(currentPlayer)
// > Optional("Alice")

print([2, 3, 1].first)
// > Optional(2)
print([2, 3, 1].minElement())
// > Optional(1)

if let currentPlayer = currentPlayer {
  print("\(currentPlayer) will start")
}
// > Alice will start

var firstPlayer = players[0]
print("First player is \(firstPlayer)")
// > First player is "Alice"

//var player = players[4]
// > fatal error: Array index out of range

let upcomingPlayers = players[1...2]
print(upcomingPlayers)
// > ["Bob", "Cindy"]

func isPlayerEliminated(playerName: String) -> Bool {
  if players.contains(playerName) {
    return false
  } else {
    return true
  }
}

print(isPlayerEliminated("Bob"))
// > false

players[1...3].contains("Bob")
// > true

// -------------------------
// | MANIPULATING ELEMENTS |
// -------------------------

players.append("Eli")

players += ["Gina"]

print(players)
// > ["Alice", "Bob", "Cindy", "Dan", "Eli", "Gina"]

players.insert("Frank", atIndex: 5)

// ---------------------
// | REMOVING ELEMENTS |
// ---------------------

var removedPlayer = players.removeLast()
print("\(removedPlayer) was removed")
// > Gina was removed

removedPlayer = players.removeAtIndex(2)
print("\(removedPlayer) was removed")
// > Cindy was removed

// ---------------------
// | UPDATING ELEMENTS |
// ---------------------

print(players)
// > ["Alice", "Bob", "Dan", "Eli", "Frank"]
players[3] = "Franklin"
print(players)
// > ["Alice", "Bob", "Dan", "Eli", "Franklin"]

players[0...1] = ["Donna", "Craig", "Brian", "Anna"]
print(players)
// > ["Donna", "Craig", "Brian", "Anna", "Eli", "Franklin"]

let playerAnna = players.removeAtIndex(3)
players.insert(playerAnna, atIndex: 0)
print(players)
// > ["Anna", "Donna", "Craig", "Brian", "Eli", "Franklin"]

players = players.sort()
print(players)
// > ["Anna", "Brian", "Craig", "Donna", "Eli", "Franklin"]


// -------------
// | ITERATION |
// -------------

let scores = [2, 2, 8, 6, 1, 2]

for playerName in players {
  print(playerName)
}
// > Anna
// > Brian
// > Craig
// > Donna
// > Eli
// > Franklin

for (index, playerName) in players.enumerate() {
  print("\(index + 1). \(playerName)")
}
// > 1. Anna
// > 2. Brian
// > 3. Craig
// > 4. Donna
// > 5. Eli
// > 6. Franklin

func sumOfAllItems(intArray: [Int]) -> Int {
  var sum = 0
  for number in intArray {
    sum += number
  }
  return sum
}

print(sumOfAllItems(scores))
// > 21


// -----------------------
// | SEQUENCE OPERATIONS |
// -----------------------

let sum = scores.reduce(0, combine: +)
print(sum)
// > 21

print(scores.filter({ $0 > 5 }))
// > [8, 6]

print(scores)
// > [2, 2, 8, 6, 1, 2]
let newScores = scores.map({ $0 * 2 })
print(newScores)
// > [4, 4, 16, 12, 2, 4]
