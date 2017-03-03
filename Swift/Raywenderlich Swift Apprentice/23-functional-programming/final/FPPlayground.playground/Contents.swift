//: Playground - noun: a place where people can play

import Foundation
import UIKit

let animals: [String] = ["cat", "dog", "rat", "sheep", "dolphin", "fish", "tiger"]

func capitalize(s: String) -> String {
  return s.uppercaseString
}

//
// transforming an array with a loop
//

var uppercaseAnimals: [String] = []
for animal in animals {
  let uppercaseAnimal = capitalize(animal)
  uppercaseAnimals.append(uppercaseAnimal)
}
uppercaseAnimals // =>  ["CAT","DOG","RAT","SHEEP","DOLPHIN","FISH","TIGER"]

func characterForCharacterName(characterName: String) -> Character
{
  let curlyBracedCharacterName = "\\N{\(characterName)}"
  let charStr = curlyBracedCharacterName.stringByApplyingTransform(NSStringTransformToUnicodeName, reverse: true)
  return charStr!.characters.first!
}

var animalEmojis: [Character] = []
for uppercaseAnimal in uppercaseAnimals {
  let emoji = characterForCharacterName(uppercaseAnimal)
  animalEmojis.append(emoji)
}
animalEmojis

//
// defining our own `map` as a free function
//

func map<InputType, OutputType>(inputs: [InputType], transform: (InputType) -> (OutputType)) -> [OutputType]
{
  var outputs: [OutputType] = []
  for inputItem in inputs {
    let outputItem = transform(inputItem)
    outputs.append(outputItem)
  }
  return outputs
}

let uppercaseAnimals2 = map(animals, transform: capitalize)
let animalEmojis2 = map(uppercaseAnimals, transform: characterForCharacterName)

//
// using Swift's `map` method
//

let uppercaseAnimals3 = animals.map(capitalize)
let animalEmojis3 = uppercaseAnimals.map(characterForCharacterName)

//
// examples of pure and non-pure functions
//

// pure. Inputs deterministically drive output
func distanceTraveled(t: Float) -> Float {
  return 60 * t
}

// impure. Random factor
func distanceTraveledRand(t: Float) -> Float {
  let booster = 1 + Float(arc4random_uniform(2))
  return booster * 60 * t
}

// impure. External variable
let specialBoosterVariable: Float = 1331
func distanceTraveledExternal(t: Float) -> Float {
  let booster = specialBoosterVariable
  return booster * 60 * t
}

// Impure. Evolving internal state
func distanceTraveledMemory(t: Float) -> Float {
  struct Memory {
    static var x: Float = 1
  }
  Memory.x = Memory.x * 60 * t
  return Memory.x
}

distanceTraveledMemory(2)
distanceTraveledMemory(2)

//
// passing map a closure, not a named function
//

let uppercaseAnimals4 = animals.map( { $0.uppercaseString })

//
// FILTER
//

func isThreeCharacters(s: String) -> Bool
{
  return s.characters.count == 3
}

let threeLetterAnimals = animals.filter( { $0.characters.count == 3 } )
threeLetterAnimals

let pictures = animals.filter({$0.characters.count == 3}).map(characterForCharacterName)
pictures

//
// REDUCE
//

func sum(items: [Int]) -> Int
{
  return items.reduce(0, combine: +)
}
let total = sum([1, 2, 3])


func concatenate(items: [String]) -> String
{
  return items.reduce("", combine: +)
}
let phrase = concatenate(["Hello"," ","World"])


//
// emoji annotations
//

/*
  A raw unicode annotation entry has the form

  public typealias AnnotationInfo = (codePoints: [Character], annotations: [String])
*/

let unicodeAnnotations = loadUnicodeAnnotationData()

typealias AnnotationPair = (chars: Set<Character>, annotation: Set<String>)
let pairs: [AnnotationPair] = unicodeAnnotations.map({ (Set($0.0), Set($0.1)) })

pairs.count

//: Question: How many distinct annotations are there?

let distinctAnnotationsCount = pairs.map({$1}).reduce(Set(), combine: {$0.union($1)}).count
distinctAnnotationsCount

//: Question: what do annotations from the the first 20 entries look like?

let first20Annotations = pairs[0..<20].map({$1}).reduce(Set(), combine: {$0.union($1)})
first20Annotations


//: Question: what are the annotations on a particular character X?

func annotationsForCharacter(character: Character, annotationPairs pairs: [AnnotationPair]) -> Set<String>
{
  let result = pairs
    .filter({ $0.0.contains(character) })
    .map({$0.1})
    .reduce(Set<String>(), combine: { $0.union($1) })
  return result
}

let cat: Character = "🐈"
let catAnnotations = annotationsForCharacter(cat, annotationPairs: pairs)
catAnnotations

//: Question: what are the annotations on the character with name X?

func annotationsForCharacterName(characterName: String, annotationPairs pairs: [AnnotationPair]) -> Set<String>
{
  let ch = characterForCharacterName(characterName)
  let result = pairs
    .filter({ $0.0.contains(ch) })
    .map({$0.1})
    .reduce(Set<String>(), combine: { $0.union($1) })
  return result
}

let catAnnotations2 = annotationsForCharacterName("CAT", annotationPairs: pairs)

//: Question: what are all the characters with annotation X?

func charactersWithAnnotation(annotation: String, annotationPairs pairs: [AnnotationPair]) -> Set<Character>
{
  return pairs
    .filter({$1.contains(annotation)})
    .map({$0.0})
    .reduce(Set<Character>(), combine: { $0.union($1) })
}

let petChars = charactersWithAnnotation("pet", annotationPairs: pairs)

func characterNameForCharacter(character: Character) -> String
{
  func stripNameDelimiterIfPresentFromString(string s: String) -> String {
    if s.hasPrefix("\\N{") && s.hasSuffix("}") {
      let range = Range(start: s.characters.startIndex.advancedBy(3), end: s.characters.endIndex.predecessor())
      return s.substringWithRange(range)
    }
    else { return s }
  }

  let delimitedName = String(character).stringByApplyingTransform(NSStringTransformToUnicodeName, reverse: false)
  return stripNameDelimiterIfPresentFromString(string: delimitedName!)
}

//: Question: What are the names of all the pets?

let petNames = petChars.map(characterNameForCharacter)

// Q: what are all the distinct annotations?
