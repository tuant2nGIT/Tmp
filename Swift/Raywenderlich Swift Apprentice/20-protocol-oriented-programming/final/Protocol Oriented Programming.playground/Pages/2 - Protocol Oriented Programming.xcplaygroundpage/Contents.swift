//: # Protocol Oriented Programming

//: Protocol extensions

protocol TeamRecord {
  var wins: Int { get }
  var losses: Int { get }
  func winningPercentage() -> Double
}

// Providing default behavior based on classes
class TeamRecordBase: TeamRecord {
  var wins: Int = 0
  var losses: Int = 0

  func winningPercentage() -> Double {
    return Double(wins) / Double(wins) + Double(losses)
  }
}

// Default behavior using protocol extensions
extension TeamRecord {
  var gamesPlayed: Int {
    return wins + losses
  }
}

//: Providing default implementations

extension TeamRecord {
  func winningPercentage() -> Double {
    return Double(wins) / (Double(wins) + Double(losses))
  }
}

struct BaseballRecord: TeamRecord {
  var wins: Int
  var losses: Int
  let gamesPlayed = 162
}


struct BasketballRecord: TeamRecord {
    var wins: Int
    var losses: Int
    let seasonLength = 82
}

let team1: TeamRecord = BaseballRecord(wins: 10, losses: 5)
let team2: BaseballRecord = BaseballRecord(wins: 10, losses: 5)

team1.gamesPlayed // 15
team2.gamesPlayed // 162!!

struct HockeyRecord: TeamRecord {
  var wins: Int
  var losses: Int
  var ties: Int

  // Hockey record introduces ties, and has
  // its own implementation of winningPercentage
  func winningPercentage() -> Double {
    return Double(wins) / (Double(wins) + Double(losses) + Double(ties))
  }
}

let baseballRecord: TeamRecord = BaseballRecord(wins: 10, losses: 6)
let hockeyRecord: TeamRecord = HockeyRecord(wins: 8, losses: 7, ties: 1)

baseballRecord.winningPercentage()
hockeyRecord.winningPercentage()

//: Type constraints

protocol PlayoffEligible {
  var minimumWinsForPlayoffs: Int { get }
}

extension TeamRecord where Self: PlayoffEligible {
  func isPlayoffEligible() -> Bool {
    return self.wins > minimumWinsForPlayoffs
  }
}

protocol Tieable {
  var ties: Int { get }
}

extension TeamRecord where Self: Tieable {
  func winningPercentage() -> Double {
    return Double(wins) / (Double(wins) + Double(losses) +
        Double(ties))
  }
}

struct HockeyRecord2: TeamRecord, Tieable {
    var wins: Int
    var losses: Int
    var ties: Int
}
let hockeyRecord2: TeamRecord = HockeyRecord2(wins: 8, losses: 7,
    ties: 1)
hockeyRecord.winningPercentage() // .500

//: Protocol-oriented motivation

// Inheritance is only possible with classes.
struct StructHockeyRecord { //: TeamRecordBase {

}

//: Programming to interfaces, not implementations

var teamRecords: [TeamRecord]
var teamRecordsFromClass: [TeamRecordBase]

//: Multiple Inheritance

protocol TieableRecord {
  var ties: Int { get }
}

//: Replacing deep class hierarchies

protocol Person {
  var firstName: String { get }
  var lastName: String { get }
  func fullName() -> String
}

extension Person {
  func fullName() -> String {
    return "\(firstName) \(lastName)"
  }
}

protocol Student: Person {
  var studentId: Int { get }
  func recordGrade()
}

extension Student {
  func recordGrade() {
    //...
  }
}


protocol Athlete {
  var sports: [String] { get }
}


struct StudentAthlete: Student, Athlete {
  var firstName: String
  var lastName: String
  var studentId: Int
  var sports: [String] = []
}

//: Extending and providing default behavior on standard library types

extension CollectionType {
  func take2() -> [Self.Generator.Element?] {
    return [self.first, self[self.startIndex.successor()]]
  }
}

[1, 2, 4, 6, 0].take2()

protocol Bird {
  var canFly: Bool { get }
}

protocol Flyable {

}

extension Bird where Self: Flyable {
  var canFly: Bool {
    return true
  }
}
