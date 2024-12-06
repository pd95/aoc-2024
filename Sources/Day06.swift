import Algorithms
import RegexBuilder

struct Day06: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var grid: [[Character]] {
    data.split(separator: "\n").map({ Array(String($0)) })
  }

  var startPosition: (row: Int, col: Int) {
    for (row, line) in grid.enumerated() {
      for (col, char) in line.enumerated() {
        if char == "^" {
          return (row, col)
        }
      }
    }
    fatalError("Start position not found")
  }

  enum Direction: Character {
    case north = "N"
    case south = "S"
    case east  = "E"
    case west  = "W"

    var character: Character {
      self.rawValue
    }

    var turned: Direction {
      switch self {
      case .north: return .east
      case .south: return .west
      case .east: return .south
      case .west: return .north
      }
    }

    mutating func turn() {
      self = turned
    }
  }

  struct Grid: CustomStringConvertible {
    let size: (width: Int, height: Int)
    var cells: [[Character]]

    init(data: String) {
      cells = data.split(separator: "\n").map({ Array(String($0)) })
      let width = cells[0].count
      let height = cells.count
      size = (width: width, height: height)
    }

    var startPosition: Position {
      for (row, line) in cells.enumerated() {
        for (col, char) in line.enumerated() {
          if char == "^" {
            return Position(gridSize: size, row: row, col: col)
          }
        }
      }
      fatalError("Start position not found")
    }

    var description: String {
      cells.map { String($0) }.joined(separator: "\n")
    }

    func charAt(position: Position) -> Character? {
      if position.isValid == false { return nil }
      return cells[position.row][position.col]
    }

    mutating func mark(position: Position, char: Character) {
      guard position.isValid else {
        print("can't mark \(position)")
        return
      }
      cells[position.row][position.col] = char
    }
  }

  struct Position: CustomStringConvertible {
    let gridSize: (width: Int, height: Int)
    var row: Int
    var col: Int

    var isValid: Bool {
      row >= 0 && row < gridSize.height && col >= 0 && col < gridSize.width
    }

    func position(towards direction: Direction) -> Position {
      switch direction {
      case .north: return Position(gridSize: gridSize, row: row - 1, col: col)
      case .south: return Position(gridSize: gridSize, row: row + 1, col: col)
      case .east: return Position(gridSize: gridSize, row: row, col: col + 1)
      case .west: return Position(gridSize: gridSize, row: row, col: col - 1)
      }
    }

    var description: String {
      "(\(row), \(col))"
    }
  }

  func part1() -> Int {
    var stepCount = 0

    var grid = Grid(data: data)
    var currentPosition = grid.startPosition
    var direction = Direction.north

    repeat {
      // Mark current position with X
      let char = grid.charAt(position: currentPosition)
      if char == "." || char == "^" {
        grid.mark(position: currentPosition, char: "X")
        stepCount += 1
      }
      // print("\(stepCount) \(currentPosition) \(direction)")
      // print(grid.description)


      var nextPos = currentPosition.position(towards: direction)
      while nextPos.isValid && grid.charAt(position: nextPos) == "#" {
        direction.turn()
        // print("  => turning \(direction)")
        nextPos = currentPosition.position(towards: direction)
      }
      currentPosition = nextPos
    } while currentPosition.isValid

    print("🔴 Leaving grid")

    return stepCount
  }

  func part2() -> Int {
    var loopPossibilities = 0

    var grid = Grid(data: data)
    var currentPosition = grid.startPosition
    var direction = Direction.north


    repeat {
      // Mark current position with X
      guard let char = grid.charAt(position: currentPosition) else {
        fatalError("This should not happen: access to invalid position \(currentPosition)")
      }
      if char == "." || char == "^" {

        // Check if blocking the next position would cause a loop
        let blockPosition = currentPosition.position(towards: direction)
        if blockPosition.isValid && grid.charAt(position: blockPosition) != "#" {
          print("🟡 Checking for loop")
          var tempGrid = grid
          tempGrid.mark(position: blockPosition, char: "O")
          tempGrid.mark(position: currentPosition, char: "+")

          let tempDirection = direction.turned
          var tempPosition = currentPosition
          repeat {
            tempPosition = tempPosition.position(towards: tempDirection)
            if tempPosition.isValid {
              let tempChar = grid.charAt(position: tempPosition)
              if tempChar == tempDirection.character {
                print(tempGrid.description)
                print("🟢 Loop is possible!")

                loopPossibilities += 1
                break
              }
            }
          } while tempPosition.isValid

          grid.mark(position: currentPosition, char: char)
        }

        grid.mark(position: currentPosition, char: direction.character)

      } else {

        // detect a possible loop whenever we cross our path
        if char == "N" && direction == .west ||
            char == "W" && direction == .south ||
            char == "E" && direction == .north ||
            char == "S" && direction == .east
        {
          let blockPosition = currentPosition.position(towards: direction)
          var tempGrid = grid
          tempGrid.mark(position: blockPosition, char: "O")
          tempGrid.mark(position: currentPosition, char: "+")
          print(tempGrid.description)
          print("🟢 Loop is possible!")
          loopPossibilities += 1
        }
      }
      // print(">>> \(currentPosition) \(direction)")
      // print(grid.description)


      var nextPos = currentPosition.position(towards: direction)
      while nextPos.isValid && grid.charAt(position: nextPos) == "#" {
        grid.mark(position: currentPosition, char: "+")
        direction.turn()
        // print("  => turning \(direction)")
        nextPos = currentPosition.position(towards: direction)
      }
      currentPosition = nextPos
    } while currentPosition.isValid

    print("🔴 Leaving grid")



    return loopPossibilities
  }
}
