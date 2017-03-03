import Foundation

let myAge: Int = 30

var averageAge: Double = Double(myAge)
averageAge = 27.5

let temperature: (Int, Int, Int, Double) = (10, 17, 2015, 15.7)

let temperature2: (month: Int, day: Int, year: Int, averageTemperature: Double) = (10, 17, 2015, 15.7)

let (day, _, _, averageTemperature) = temperature2

var temperature3: (month: Int, day: Int, year: Int, averageTemperature: Double) = (10, 17, 2015, 15.7)
temperature3.averageTemperature = 21.2

let twoIntegers = (5, 10)

let integerOne = twoIntegers.0
