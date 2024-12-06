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

    static prefix func - (direction: Direction) -> Direction {
      direction.turned.turned
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

    func contains(_ char: Character) -> Bool {
      position(for: char) != nil
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
        print("can't mark \(position)")
        return
      }
      cells[position.row][position.col] = char
//      print(description)
    }
  }

  struct Position: Equatable, Hashable, CustomStringConvertible {
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

  func findLoopPossibilities(_ grid: Grid, currentPosition: Position, direction: Direction, backtracking: Bool = false) -> Set<Position> {
    var blockPositions = Set<Position>()
    var grid = grid

    guard let char = grid.charAt(position: currentPosition) else {
      return blockPositions
    }

//    print(">>> \(currentPosition) \(direction)")
//    print(grid.description)

    var direction = direction
    var nextPos = currentPosition.position(towards: direction)

    if backtracking {
      if char == direction.character {
        print("🟢 Loop detected at \(currentPosition)!")
        blockPositions.insert(currentPosition)
        return blockPositions
      }
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
//        print(tempGrid.description)
        print("🟢 Loop is possible!")
        blockPositions.insert(blockPosition)
      }
    }


    if char != "#" && char != "O" {
      grid.mark(position: currentPosition, char: direction.character)
    }

    while nextPos.isValid && (grid.charAt(position: nextPos) == "#" || grid.charAt(position: nextPos) == "O") {
      grid.mark(position: currentPosition, char: "+")
      direction.turn()
//      print("  => turning \(direction)")
      nextPos = currentPosition.position(towards: direction)
    }
//    print(grid.description)

    if nextPos.isValid {
      blockPositions = blockPositions.union(findLoopPossibilities(grid, currentPosition: nextPos, direction: direction, backtracking: backtracking))

      if !backtracking &&  grid.charAt(position: nextPos) == "." {
//        print("trying to backtrack")
        var tempGrid = grid
        tempGrid.mark(position: nextPos, char: "O")
        tempGrid.mark(position: currentPosition, char: "+")
//        print(tempGrid)
        if findLoopPossibilities(tempGrid, currentPosition: currentPosition, direction: direction, backtracking: true).isEmpty == false {
//          print("Loop found while backtracking")
          blockPositions.insert(nextPos)
        }

      }
    }

//    print("🟡 returning \(blockPositions)")
    return blockPositions
  }

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
        print("🔴 Infinite Loop detected!")
        return -1
      }
      visitedPositions.insert(directedPosition)
      history.append(directedPosition)

      // Mark current position with X
      let char = grid.charAt(position: currentPosition)
      if char != "#" && char != "O" /*&& char != "^"*/ {
        grid.mark(position: currentPosition, char: direction.character)
        stepCount += 1
      }
//      print("\(stepCount) \(currentPosition) \(direction)")
//      print(grid.description)
//      try? await Task.sleep(for: .seconds(0.1))

      var nextPos = currentPosition.position(towards: direction)
      while nextPos.isValid && grid.charAt(position: nextPos) == "#" {
        direction.turn()
//        print("  => turning \(direction)")
        nextPos = currentPosition.position(towards: direction)
        grid.mark(position: currentPosition, char: "+")
//        print("\(stepCount) \(currentPosition) \(direction)")
//        print(grid.description)
      }

      currentPosition = nextPos
    } while currentPosition.isValid

    print("🔴 Leaving grid at \(currentPosition)", history.count)
//    print(grid.description)

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

    print("  Processing \(relevantPositions.count) positions..")

    // Backtracking to find more!
    for (index, lastEntry) in relevantPositions.enumerated() {
      grid = initialGrid
      currentPosition = grid.startPosition
      direction = Direction.north
      let blockPosition = lastEntry.position
      //print("🟡 Start testing \(index): \(blockPosition)")

      grid.mark(position: blockPosition, char: "O")

      var visitedPositions = Set<DirectedPosition>()

//      print("\(index) \(currentPosition) \(direction)")
//      print(grid.description)

      repeat {
        let directedPosition = DirectedPosition(position: currentPosition, direction: direction)

        if visitedPositions.contains(directedPosition) {
          blockPositions.insert(blockPosition)
          //print("🟢 Loop is possible! \(blockPosition)... same position visited before!")
          break
        }
        visitedPositions.insert(directedPosition)

        let char = grid.charAt(position: currentPosition)
//        if char == direction.character {
//          blockPositions.insert(blockPosition)
//          print("🟢 Loop is possible! \(blockPosition) (total \(blockPositions.count))")
//          break
//        }
        if char != "#" && char != "O" {
          grid.mark(position: currentPosition, char: direction.character)
        }
//        print(">>> \(currentPosition) \(direction)")
//        print(grid.description)
//        try? await Task.sleep(for: .seconds(0.1))

        var nextPos = currentPosition.position(towards: direction)
        while nextPos.isValid && (grid.charAt(position: nextPos) == "#" || grid.charAt(position: nextPos) == "O") {
          direction.turn()
          //print("\(currentPosition)  => turning \(direction)")
          nextPos = currentPosition.position(towards: direction)
          grid.mark(position: currentPosition, char: "+")
          //try? await Task.sleep(for: .seconds(0.1))
        }

        currentPosition = nextPos
      } while currentPosition.isValid
      //print("🟡 Done testing \(index)")
      //try? await Task.sleep(for: .seconds(0.1))

    }

    return blockPositions.count
  }
}
