// -------------------------
// | CREATING DICTIONARIES |
// -------------------------

let pairs: Dictionary<String, Int>

let inferredPairs = Dictionary<String, Int>()

let alsoInferredPairs = [String: Int]()

let namesAndScores = ["Anna": 2, "Brian": 2, "Craig": 8, "Donna": 6]
print(namesAndScores)
// > ["Brian": 2, "Anna": 2, "Craig": 8, "Donna": 6]

var emptyDictionary: [Int: Int]
emptyDictionary = [:]

// --------------------
// | ACCESSING VALUES |
// --------------------

print(namesAndScores["Anna"])
// > Optional(2)

print(namesAndScores["Greg"])
// > nil

print(namesAndScores.isEmpty)
// > false
print(namesAndScores.count)
// > 4

print(Array(namesAndScores.keys))
// > ["Brian", "Anna", "Craig", "Donna"]
print(Array(namesAndScores.values))
// > [2, 2, 8, 6]

// -----------------
// | ADDING VALUES |
// -----------------

var bobData = ["name": "Bob", "profession": "Card Player", "country": "USA"]

bobData.updateValue("CA", forKey: "state")

bobData["city"] = "San Francisco"

// -------------------
// | UPDATING VALUES |
// -------------------

bobData.updateValue("Bobby", forKey: "name")
// > Bob

bobData["profession"] = "Mailman"

bobData.removeValueForKey("state")

bobData["city"] = nil

// -------------
// | ITERATION |
// -------------

for (key, value) in namesAndScores {
  print("\(key) - \(value)")
}
// > Brian - 2
// > Anna - 2
// > Craig - 8
// > Donna - 6

for key in namesAndScores.keys {
  print("\(key), ", terminator: "") // no newline
}
print("") // print one final newline
// > Brian, Anna, Craig, Donna,

// -----------------------
// | Sequence Operations |
// -----------------------

let namesString = namesAndScores.reduce("", combine: { $0 + "\($1.0), " })
print(namesString)

print(namesAndScores.filter({ $0.1 < 5 }))
// > [("Brian", 2), ("Anna", 2)]

// ----------------
// | Running Time |
// ----------------

print("some string".hashValue)
// > 4799450059642629719
print(1.hashValue)
// > 1
print(false.hashValue)
// > 0
