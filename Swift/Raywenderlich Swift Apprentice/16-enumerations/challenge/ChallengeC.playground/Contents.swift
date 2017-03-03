import UIKit

// Taking the example from earlier in the chapter, begin with the `Direction` enumeration:

enum Direction {
  case North
  case South
  case East
  case West
}

// Calculate the position of a game character on a map after making a series of movements:

var movements: [Direction] = [.North, .North, .West, .South,
  .West, .South, .South, .East, .East, .South, .East]

// Hint: Use a tuple for the location:

var location = (x: 0, y: 0)

for movement in movements {
  switch movement {
  case .North:
    location.x += 1
  case .South:
    location.x -= 1
  case .East:
    location.y += 1
  case .West:
    location.y -= 1
  }
}

let currentX = location.x // -2
let currentY = location.y // -1
