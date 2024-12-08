import Algorithms
import RegexBuilder

struct Day06: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  private var grid: [[Character]] {
    data.split(separator: "\n").map({ Array(String($0)) })
  }

  private enum Direction: Character {
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

  private struct Grid: CustomStringConvertible {
    let size: (width: Int, height: Int)
    var cells: [[Character]]

    init(data: String) {
      cells = data.split(separator: "\n").map({ Array(String($0)) })
      let width = cells[0].count
      let height = cells.count
      size = (width: width, height: height)
    }

    func position(for lookup: Character) -> Position? {
      for (row, line) in cells.enumerated() {
        for (col, char) in line.enumerated() {
          if char == lookup {
            return Position(gridSize: size, row: row, col: col)
          }
        }
      }
      return nil
    }

    var startPosition: Position {
      guard let start = position(for: "^") else {
        fatalError("Start position not found")
      }
      return start
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
        fatalError("can't mark \(position)")
      }
      cells[position.row][position.col] = char
    }
  }

  private struct Position: Equatable, Hashable, CustomStringConvertible {
    let gridWidth: Int
    let gridHeight: Int
    var row: Int
    var col: Int

    init(gridSize: (width: Int, height: Int), row: Int, col: Int) {
      self.gridWidth = gridSize.width
      self.gridHeight = gridSize.height
      self.row = row
      self.col = col
    }

    init(gridWidth: Int, gridHeight: Int, row: Int, col: Int) {
      self.gridWidth = gridWidth
      self.gridHeight = gridHeight
      self.row = row
      self.col = col
    }

    var isValid: Bool {
      row >= 0 && row < gridHeight && col >= 0 && col < gridWidth
    }

    func position(towards direction: Direction) -> Position {
      switch direction {
      case .north: return Position(gridWidth: gridWidth, gridHeight: gridHeight, row: row - 1, col: col)
      case .south: return Position(gridWidth: gridWidth, gridHeight: gridHeight, row: row + 1, col: col)
      case .east: return Position(gridWidth: gridWidth, gridHeight: gridHeight, row: row, col: col + 1)
      case .west: return Position(gridWidth: gridWidth, gridHeight: gridHeight, row: row, col: col - 1)
      }
    }

    var description: String {
      "(\(row), \(col))"
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
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

      var nextPos = currentPosition.position(towards: direction)
      while nextPos.isValid && grid.charAt(position: nextPos) == "#" {
        direction.turn()
        nextPos = currentPosition.position(towards: direction)
      }
      currentPosition = nextPos
    } while currentPosition.isValid

    return stepCount
  }


  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    let initialGrid = Grid(data: data)
    var grid = initialGrid

    var blockPositions = Set<Position>()
    var stepCount = 0

    var currentPosition = grid.startPosition
    var direction = Direction.north

    var history = [DirectedPosition]()
    var visitedPositions = Set<DirectedPosition>()

    repeat {
      let directedPosition = DirectedPosition(position: currentPosition, direction: direction)
      if visitedPositions.contains(directedPosition) {
        fatalError("🔴 Infinite Loop detected!")
      }
      visitedPositions.insert(directedPosition)
      history.append(directedPosition)

      // Mark current position with X
      let char = grid.charAt(position: currentPosition)
      if char != "#" && char != "O" /*&& char != "^"*/ {
        grid.mark(position: currentPosition, char: direction.character)
        stepCount += 1
      }

      var nextPos = currentPosition.position(towards: direction)
      while nextPos.isValid && grid.charAt(position: nextPos) == "#" {
        direction.turn()
        nextPos = currentPosition.position(towards: direction)
        grid.mark(position: currentPosition, char: "+")
      }

      currentPosition = nextPos
    } while currentPosition.isValid

    struct DirectedPosition: Hashable {
      let position: Position
      let direction: Direction
    }

    var relevantPositions: [DirectedPosition] {
      var positionSet = Set<DirectedPosition>()
      return history.filter {
        if positionSet.contains($0) {
          return false
        } else {
          positionSet.insert($0)
        }
        return initialGrid.charAt(position: $0.position) != "^"
      }
    }

    // Backtracking to find more!
    for lastEntry in relevantPositions {
      grid = initialGrid
      currentPosition = grid.startPosition
      direction = Direction.north
      let blockPosition = lastEntry.position

      grid.mark(position: blockPosition, char: "O")

      var visitedPositions = Set<DirectedPosition>()

      repeat {
        let directedPosition = DirectedPosition(position: currentPosition, direction: direction)

        if visitedPositions.contains(directedPosition) {
          blockPositions.insert(blockPosition)
          break
        }
        visitedPositions.insert(directedPosition)

        let char = grid.charAt(position: currentPosition)
        if char != "#" && char != "O" {
          grid.mark(position: currentPosition, char: direction.character)
        }

        var nextPos = currentPosition.position(towards: direction)
        while nextPos.isValid && (grid.charAt(position: nextPos) == "#" || grid.charAt(position: nextPos) == "O") {
          direction.turn()
          nextPos = currentPosition.position(towards: direction)
          grid.mark(position: currentPosition, char: "+")
        }

        currentPosition = nextPos
      } while currentPosition.isValid
    }

    return blockPositions.count
  }
}
