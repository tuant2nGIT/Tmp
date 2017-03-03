import Foundation

// Challenge A

var sum = 0
for i in 0...5 {
  sum += i
}
sum
// sum = 15

var aLotOfAs = ""
while aLotOfAs.characters.count < 10 {
  aLotOfAs += "a"
}
aLotOfAs
// aLotOfAs contains 10 instances of "a"
