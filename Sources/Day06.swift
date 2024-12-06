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

    var grid = grid
    let width = grid[0].count
    let height = grid.count
    let startPosition = startPosition

    var currentPosition = Position(
      gridSize: (width: width, height: height),
      row: startPosition.row,
      col: startPosition.col
    )
    var direction = Direction.north

    func printGrid() {
      print(grid.map { String($0) }.joined(separator: "\n"))
    }

    repeat {
      // Mark current position with X
      let char = grid[currentPosition.row][currentPosition.col]
      if char == "." || char == "^" {
        grid[currentPosition.row][currentPosition.col] = "X"
        stepCount += 1
      }
      //print("\(stepCount) \(currentPosition) \(direction)")
      //printGrid()


      var nextPos = currentPosition.position(towards: direction)
      while nextPos.isValid && grid[nextPos.row][nextPos.col] == "#" {
        direction.turn()
        //print("  => turning \(direction)")
        nextPos = currentPosition.position(towards: direction)
      }
      currentPosition = nextPos
    } while currentPosition.isValid

    print("🔴 Leaving grid")

    return stepCount
  }

  func part2() -> Int {
    var loopPossibilities = 0

    var grid = grid
    let width = grid[0].count
    let height = grid.count
    let startPosition = startPosition

    var currentPosition = Position(
      gridSize: (width: width, height: height),
      row: startPosition.row,
      col: startPosition.col
    )
    var direction = Direction.north

    func printGrid() {
      print(grid.map { String($0) }.joined(separator: "\n"))
    }

    repeat {
      // Mark current position with X
      let char = grid[currentPosition.row][currentPosition.col]
      if char == "." || char == "^" {

        // Check if blocking the next position would cause a loop
        let blockPosition = currentPosition.position(towards: direction)
        if blockPosition.isValid && grid[blockPosition.row][blockPosition.col] != "#" {
//          let oldChar = grid[blockPosition.row][blockPosition.col]
//          grid[blockPosition.row][blockPosition.col] = "O"
//          grid[currentPosition.row][currentPosition.col] = "+"

          let tempDirection = direction.turned
          var tempPosition = currentPosition
          repeat {
            tempPosition = tempPosition.position(towards: tempDirection)
            if tempPosition.isValid {
              let tempChar = grid[tempPosition.row][tempPosition.col]
              if tempChar == tempDirection.character {
                //printGrid()
//                print("🟢 Loop is possible!")
                loopPossibilities += 1
                break
              }
            }
          } while tempPosition.isValid

//          grid[blockPosition.row][blockPosition.col] = oldChar
          grid[currentPosition.row][currentPosition.col] = char
        }

        grid[currentPosition.row][currentPosition.col] = direction.character

      } else {

        // detect a possible loop whenever we cross our path
        if char == "N" && direction == .west ||
            char == "W" && direction == .south ||
            char == "E" && direction == .north ||
            char == "S" && direction == .east
        {
//          let blockPosition = currentPosition.position(towards: direction)
//          let oldChar = grid[blockPosition.row][blockPosition.col]
//          grid[blockPosition.row][blockPosition.col] = "O"
//          grid[currentPosition.row][currentPosition.col] = "+"
//          printGrid()
//          grid[blockPosition.row][blockPosition.col] = oldChar
//          grid[currentPosition.row][currentPosition.col] = char

//          print("🟢 Loop is possible!")
          loopPossibilities += 1
        }
      }
//      print(">>> \(currentPosition) \(direction)")
//      printGrid()


      var nextPos = currentPosition.position(towards: direction)
      while nextPos.isValid && grid[nextPos.row][nextPos.col] == "#" {
        grid[currentPosition.row][currentPosition.col] = "+"
        direction.turn()
//        print("  => turning \(direction)")
        nextPos = currentPosition.position(towards: direction)
      }
      currentPosition = nextPos
    } while currentPosition.isValid

    print("🔴 Leaving grid")



    return loopPossibilities
  }
}
