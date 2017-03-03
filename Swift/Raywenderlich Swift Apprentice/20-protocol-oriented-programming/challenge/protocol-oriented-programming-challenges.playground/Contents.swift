import Foundation

//:
//: ## Challenge A: Protocol extension practice
//:
//: Suppose you own a retail store. You have food items, household items, clothes and electronics. Begin with an Item protocol:

protocol Item: CustomStringConvertible {
    var name: String { get }
    var clearance: Bool { get }
    var msrp: Double { get }
    func totalPrice() -> Double
}


//: Fulfill the following requirements using primarily what you've learned about protocol-oriented programming. In other words, minimize the code in your classes, structs or enums.
//:
//: * Clothes do not have sales tax, but all other items have 7.5% sales tax.
//:
//: * When on clearance, food items are discounted 50%, household and clothes are discounted 25% and electronics are discounted 5%.
//:
//: * Items should implement CustomStringConvertible and return name. Food items should also print their expiration dates.

protocol TaxableItem: Item { }

protocol ClearanceableItem: Item {
    var adjustedMsrp: Double { get }
}

extension Item where Self: TaxableItem, Self: ClearanceableItem {
    func totalPrice() -> Double {
        return adjustedMsrp + (adjustedMsrp * 0.075)
    }
}

extension Item {
    func totalPrice() -> Double {
        return msrp
    }
}

extension Item {
    var description: String {
        return name
    }
}

struct Clothing: ClearanceableItem {
    let name: String
    let msrp: Double
    let clearance: Bool

    var adjustedMsrp: Double {
        return msrp * (clearance ? 0.75 : 1.0)
    }
}

struct Electronic: TaxableItem, ClearanceableItem {
    let name: String
    let msrp: Double
    let clearance: Bool

    var adjustedMsrp: Double {
        return msrp * (clearance ? 0.9 : 1.0)
    }
}

struct Food: TaxableItem {
    let name: String
    let msrp: Double
    let clearance: Bool
    let expirationMonth: Int
    let expirationYear: Int

    var adjustedMsrp: Double {
        return msrp * (clearance ? 0.50 : 1.0)
    }

    var description: String {
        return "\(name) - expires \(expirationMonth)/\(expirationYear)"
    }
}

Food(name: "Bread", msrp: 2.99, clearance: false, expirationMonth: 11, expirationYear: 2016).totalPrice()
Clothing(name: "Shirt", msrp: 12.99, clearance: true).totalPrice()
Clothing(name: "Last season shirt", msrp: 12.99, clearance: false).totalPrice()
Electronic(name: "Apple TV", msrp: 139.99, clearance: false).totalPrice()
Electronic(name: "Apple TV 3rd gen", msrp: 99.99, clearance: true).totalPrice()

// Custom string convertible demonstration
Food(name: "Bread", msrp: 2.99, clearance: false, expirationMonth: 11, expirationYear: 2016)
Electronic(name: "Apple TV 3rd gen", msrp: 99.99, clearance: true)

//:
//: ## Challenge B: Randomization
//:
//: Write a protocol extension on SequenceType named randomize() that will rearrange the elements in random order. You can test out your implementation on an ordinary Array, which implements SequenceType.
//:
//: **Hints**:
//:
//: * Your method signature should be `randomize() -> [Generator.Element]`. The type `[Generator.Element]` is an array of whatever type (such as a String or an Int) the SequenceType holds. (You will learn more about this in the Generics chapter)
//:
//: * You can call the arc4random_uniform() method like this: `arc4random_uniform(2)` to randomly generate a 1 or 0 for your randomization algorithm.
//:

import Darwin

extension SequenceType {
    func randomize() -> [Generator.Element] {
        var returnArray: [Generator.Element] = []
        for i in self {
            if arc4random_uniform(2) == 0 {
                returnArray.append(i)
            } else {
                let randomIndex: Int = Int(arc4random_uniform(UInt32(returnArray.count)))
                returnArray.insert(i, atIndex: randomIndex)
            }
        }
        return returnArray
    }
}

let ordered = [1, 2, 3, 4, 5, 6, 7, 8, 9]

// Try it a few times!

ordered.randomize()
ordered.randomize()
ordered.randomize()
ordered.randomize()
