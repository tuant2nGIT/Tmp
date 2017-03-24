//: Playground - noun: a place where people can play

import UIKit

var longtitude: Double
longtitude = -86.783333
longtitude = -186.783333
longtitude = -1286.783333
longtitude = -12386.783333
longtitude = -123486.783333
longtitude = -1234586.783333

var name = "Tim"
var age = 25
var ratio = 25.12313123123123

"Your name is \(name) and your age is \(ratio)"


var list = ["Tuan","Anh","Phap",1]
list.dynamicType
list.description
list.debugDescription
list.endIndex
list.count

var songs: [String] = []
songs.append("1")
songs.append("2")
songs.append("3")

var singers: [String] = ["a","b","c"]

var both = songs + singers

var info = []
info.setValue("1", forKey: "name")
info.setValue(1, forKey: "age")

var action: String
var person = "hater"
if person == "hater" {
    action = "hate"
}
else if person == "player" {
    action = "play"
}
else {
    action = "cruise"
}

for i in 0...10 {
    print("\(i) * 10 = \(i*10) \n")
}

var str = "Fakers gonna"
for j in 0...10 {
    str += " fake"
}
print(str)

for song in songs {
    str += song
}
print(str)

var peoples = ["players","haters","heart-breakers","fakers"]
var actions = ["play","hate","break","fake"]

var descs: [String] = []

for i in 0...(peoples.count - 1) {
    var people = peoples[i]
    var action = actions[i]
    
    var desc: String = people + " gonna"
    for j in 0...4 {
        desc += " \(action)"
    }
    descs.append(desc)
}
print(descs)

for i in 0...3 {
    print("\(peoples[i]) gonna \(actions[i])")
}

        